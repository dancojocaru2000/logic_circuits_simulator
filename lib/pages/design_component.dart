import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hetu_script/hetu_script.dart';
import 'package:hetu_script/values.dart';
import 'package:logic_circuits_simulator/components/visual_component.dart';
import 'package:logic_circuits_simulator/models.dart';
import 'package:logic_circuits_simulator/pages_arguments/design_component.dart';
import 'package:logic_circuits_simulator/state/component.dart';
import 'package:logic_circuits_simulator/state/project.dart';
import 'package:logic_circuits_simulator/state/projects.dart';
import 'package:logic_circuits_simulator/utils/future_call_debounce.dart';
import 'package:logic_circuits_simulator/utils/iterable_extension.dart';
import 'package:logic_circuits_simulator/utils/provider_hook.dart';
import 'package:logic_circuits_simulator/utils/stack_canvas_controller_hook.dart';
import 'package:provider/provider.dart';
import 'package:stack_canvas/stack_canvas.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

Key canvasKey = GlobalKey();
Key pickerKey = GlobalKey();

class DesignComponentPage extends HookWidget {
  final ComponentEntry component;

  const DesignComponentPage({required this.component, super.key});
  DesignComponentPage.fromArguments(DesignComponentPageArguments args, {super.key})
    : component = args.component;

  static const String routeName = '/project/component/design';

  @override
  Widget build(BuildContext context) {
    final componentState = useProvider<ComponentState>();
    final canvasController = useStackCanvasController(
      offsetReference: Reference.Center,
    );

    // Simulation vars
    final isSimulating = useState(false);
    final simulatePartially = useState(false);
    
    useListenable(componentState.partialVisualSimulation!);

    // Scripting
    final scriptingEnvironment = useState<Hetu?>(null);
    final loadScript = useMemoized(() => (String script) {
      scriptingEnvironment.value = Hetu();
      scriptingEnvironment.value!.init(
        externalFunctions: {
          'unload': (
            HTEntity entity, {
            List<dynamic> positionalArgs = const [],
            Map<String, dynamic> namedArgs = const {},
            List<HTType> typeArgs = const [],
          }) {
            scriptingEnvironment.value = null;
          },
          'alert': (
            HTEntity entity, {
            List<dynamic> positionalArgs = const [],
            Map<String, dynamic> namedArgs = const {},
            List<HTType> typeArgs = const [],
          }) {
            final content = positionalArgs[0] as String;
            final title = positionalArgs[1] as String? ?? 'Script Alert';
            return showDialog(
              context: context, 
              builder: (context) {
                return AlertDialog(
                  title: Text(title),
                  content: Text(content),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          },
          'snackBar': (
            HTEntity entity, {
            List<dynamic> positionalArgs = const [],
            Map<String, dynamic> namedArgs = const {},
            List<HTType> typeArgs = const [],
          }) {
            final content = positionalArgs[0] as String;
            final actionName = positionalArgs[1] as String?;
            final actionFunction = positionalArgs[2];
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(content),
              action: actionName == null ? null : SnackBarAction(
                label: actionName, 
                onPressed: () {
                  if (actionFunction is String) {
                    scriptingEnvironment.value?.invoke(actionFunction);
                  }
                  else if (actionFunction is HTFunction && scriptingEnvironment.value != null) {
                    actionFunction.call();
                  }
                },
              ),
            ));
          },
          'setTimeout': (
            HTEntity entity, {
            List<dynamic> positionalArgs = const [],
            Map<String, dynamic> namedArgs = const {},
            List<HTType> typeArgs = const [],
          }) {
            final millis = positionalArgs[0] as int;
            final function = positionalArgs[1];
            final pos = namedArgs['positionalArgs'] ?? [];
            final named = namedArgs['namedArgs'] ?? {};
            Future.delayed(Duration(milliseconds: millis))
              .then((_) {
                if (function is String) {
                  scriptingEnvironment.value?.invoke(function, positionalArgs: pos, namedArgs: Map.castFrom(named));
                }
                else if (function is HTFunction && scriptingEnvironment.value != null) {
                  function.call(positionalArgs: pos, namedArgs: Map.castFrom(named));
                }
              });
          },
          'getInputs': (
            HTEntity entity, {
            List<dynamic> positionalArgs = const [],
            Map<String, dynamic> namedArgs = const {},
            List<HTType> typeArgs = const [],
          }) {
            return componentState.currentComponent!.inputs;
          },
          'getOutputs': (
            HTEntity entity, {
            List<dynamic> positionalArgs = const [],
            Map<String, dynamic> namedArgs = const {},
            List<HTType> typeArgs = const [],
          }) {
            return componentState.currentComponent!.outputs;
          },
          'simGetInputValues': (
            HTEntity entity, {
            List<dynamic> positionalArgs = const [],
            Map<String, dynamic> namedArgs = const {},
            List<HTType> typeArgs = const [],
          }) {
            return Map.of(componentState.partialVisualSimulation!.inputsValues);
          },
          'simGetOutputValues': (
            HTEntity entity, {
            List<dynamic> positionalArgs = const [],
            Map<String, dynamic> namedArgs = const {},
            List<HTType> typeArgs = const [],
          }) {
            return Map.of(componentState.partialVisualSimulation!.outputsValues);
          },
          'simSetInput': (
            HTEntity entity, {
            List<dynamic> positionalArgs = const [],
            Map<String, dynamic> namedArgs = const {},
            List<HTType> typeArgs = const [],
          }) {
            final inputName = positionalArgs[0] as String;
            final value = positionalArgs[1] as bool;

            return componentState.partialVisualSimulation!.modifyInput(inputName, value);
          },
          'simSetInputs': (
            HTEntity entity, {
            List<dynamic> positionalArgs = const [],
            Map<String, dynamic> namedArgs = const {},
            List<HTType> typeArgs = const [],
          }) {
            final inputs = positionalArgs[0] as Map;

            return componentState.partialVisualSimulation!.provideInputs(inputs.map((key, value) => MapEntry(key as String, value as bool)));
          },
          'simSetInputsBinary': (
            HTEntity entity, {
            List<dynamic> positionalArgs = const [],
            Map<String, dynamic> namedArgs = const {},
            List<HTType> typeArgs = const [],
          }) {
            final inputs = componentState.currentComponent!.inputs;
            final inputsNum = positionalArgs[0] as int;
            final inputsBinary = inputsNum.toRadixString(2).padLeft(inputs.length, '0');
            final inputsMap = Map.fromIterables(inputs, inputsBinary.characters.map((c) => c == '1'));

            return componentState.partialVisualSimulation!.provideInputs(inputsMap);
          },
          'simNextStep': (
            HTEntity entity, {
            List<dynamic> positionalArgs = const [],
            Map<String, dynamic> namedArgs = const {},
            List<HTType> typeArgs = const [],
          }) {
            return componentState.partialVisualSimulation!.nextStep();
          },
          'simRestart': (
            HTEntity entity, {
            List<dynamic> positionalArgs = const [],
            Map<String, dynamic> namedArgs = const {},
            List<HTType> typeArgs = const [],
          }) {
            return componentState.partialVisualSimulation!.restart();
          },
          'simIsPartiallySimulating': (
            HTEntity entity, {
            List<dynamic> positionalArgs = const [],
            Map<String, dynamic> namedArgs = const {},
            List<HTType> typeArgs = const [],
          }) {
            return simulatePartially.value;
          },
          'simSetPartiallySimulating': (
            HTEntity entity, {
            List<dynamic> positionalArgs = const [],
            Map<String, dynamic> namedArgs = const {},
            List<HTType> typeArgs = const [],
          }) {
            simulatePartially.value = positionalArgs[0] as bool;
          },
        },
      );
      scriptingEnvironment.value!.eval('''
        external fun unload
        external fun alert(message: String, [title])
        external fun snackBar(message: String, [actionName, actionFunction])
        external fun setTimeout(millis: int, function, {positionalArgs, namedArgs})
        external fun getInputs -> List
        external fun getOutputs -> List
        external fun simGetInputValues -> Map
        external fun simGetOutputValues -> Map
        external fun simSetInput(inputName: String, value: bool)
        external fun simSetInputs(values: Map)
        external fun simSetInputsBinary(values: int)
        external fun simNextStep
        external fun simRestart
        external fun simIsPartiallySimulating -> bool
        external fun simSetPartiallySimulating(partiallySimulating: bool)
      ''');
      scriptingEnvironment.value!.eval(script, type: ResourceType.hetuModule);
      try {
        scriptingEnvironment.value!.invoke('onLoad');
      } catch (e) {
        // onLoad handling is optional
      }
      try {
        scriptingEnvironment.value!.invoke('getFunctions');
      } catch (e) {
        // Getting the callable functions of the script is mandatory
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Script Loading Failed'),
              content: const Text("The script doesn't implement the getFunctions function."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        scriptingEnvironment.value = null;
      }
    }, [scriptingEnvironment.value]);

    // Design
    final movingWidgetUpdater = useState<void Function(double dx, double dy)?>(null);
    final movingWidget = useState<dynamic>(null);
    final deleteOnDrop = useState<bool>(false);    
    final designSelection = useState<String?>(null);
    final wireToDelete = useState<String?>(null);
    final sourceToConnect = useState<String?>(null);
    final hoveredIO = useState<String?>(null);
    final deleteMovingWidget = useMemoized(
      () => () async {
        if (!deleteOnDrop.value) {
          return;
        }
        final w = movingWidget.value;
        final cs = componentState;
        // First remove all connected wires
        if (w is DesignComponent) {
          // Get project state to be able to remove dependency
          final projectState = Provider.of<ProjectState>(context, listen: false);

          final wires = cs.wiringDraft.wires
            .where(
              (wire) => wire.input.startsWith('${w.instanceId}/') || wire.output.startsWith('${w.instanceId}/')
            )
            .map((wire) => wire.wireId)
            .toList();

          // Get component id before removing
          final componentId = cs.wiringDraft.instances.where((inst) => inst.instanceId == w.instanceId).first.componentId;

          await cs.updateDesign(cs.designDraft.copyWith(
            wires: cs.designDraft.wires
              .where((wire) => !wires.contains(wire.wireId))
              .toList(),
          ), commit: false);
          await cs.updateWiring(cs.wiringDraft.copyWith(
            wires: cs.wiringDraft.wires
              .where((wire) => !wires.contains(wire.wireId))
              .toList(),
          ), commit: false);
          await cs.updateDesign(cs.designDraft.copyWith(
            components: cs.designDraft.components
              .where((comp) => comp.instanceId != w.instanceId)
              .toList(),
          ));
          await cs.updateWiring(cs.wiringDraft.copyWith(
            instances: cs.wiringDraft.instances
              .where((comp) => comp.instanceId != w.instanceId)
              .toList(),
          ));

          // Remove dependency if it's the last of its kind
          if (!cs.wiringDraft.instances.map((inst) => inst.componentId).contains(componentId)) {
            componentState.removeDependency(componentId, modifyCurrentComponent: true);
            await projectState.editComponent(componentState.currentComponent!);
          }
        }
        else if (w is DesignInput) {
          final wires = cs.wiringDraft.wires
            .where(
              (wire) => wire.output == 'self/${w.name}',
            )
            .map((wire) => wire.wireId)
            .toList();

          await cs.updateDesign(cs.designDraft.copyWith(
            wires: cs.designDraft.wires
              .where((wire) => !wires.contains(wire.wireId))
              .toList(),
          ), commit: false);
          await cs.updateWiring(cs.wiringDraft.copyWith(
            wires: cs.wiringDraft.wires
              .where((wire) => !wires.contains(wire.wireId))
              .toList(),
          ));
          await cs.updateDesign(cs.designDraft.copyWith(
            inputs: cs.designDraft.inputs
              .where((input) => input.name != w.name)
              .toList(),
          ));
        }
        else if (w is DesignOutput) {
          final wires = cs.wiringDraft.wires
            .where(
              (wire) => wire.input == 'self/${w.name}',
            )
            .map((wire) => wire.wireId)
            .toList();

          await cs.updateDesign(cs.designDraft.copyWith(
            wires: cs.designDraft.wires
              .where((wire) => !wires.contains(wire.wireId))
              .toList(),
          ), commit: false);
          await cs.updateWiring(cs.wiringDraft.copyWith(
            wires: cs.wiringDraft.wires
              .where((wire) => !wires.contains(wire.wireId))
              .toList(),
          ));
          await cs.updateDesign(cs.designDraft.copyWith(
            outputs: cs.designDraft.outputs
              .where((output) => output.name != w.name)
              .toList(),
          ));
        }
      },
      [
        movingWidget.value,
        deleteOnDrop.value,
        componentState.wiringDraft,
        componentState.designDraft,
      ],
    );

    final widgets = useMemoized(() => [
      for (final subcomponent in componentState.designDraft.components)
        CanvasObject(
          dx: subcomponent.x, 
          dy: subcomponent.y, 
          width: VisualComponent.getNeededWidth(
            context,
            componentState
                .getMetaByInstance(subcomponent.instanceId)
                .item2
                .inputs,
            componentState
                .getMetaByInstance(subcomponent.instanceId)
                .item2
                .outputs,
            Theme.of(context).textTheme.bodyMedium,
          ), 
          height: max(
            componentState.getMetaByInstance(subcomponent.instanceId).item2.inputs.length,
            componentState.getMetaByInstance(subcomponent.instanceId).item2.outputs.length, 
          ) * 30 + 10, 
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (event) {
              final debouncer = FutureCallDebounce<List<double>>(
                futureCall: (xyList) {
                  final dx = xyList[0];
                  final dy = xyList[1];
                  return componentState.updateDesign(componentState.designDraft.copyWith(
                    components: componentState.designDraft.components.map(
                      (e) => e.instanceId == subcomponent.instanceId ? e.copyWith(
                        x: subcomponent.x + dx,
                        y: subcomponent.y + dy,
                      ) : e,
                    ).toList(),
                  ), commit: false);
                }, 
                combiner: (oldParams, newParams) {
                  return oldParams.zipWith([newParams], (deltas) => deltas.fold<double>(0.0, (prev, elem) => prev + elem)).toList();
                },
              );
              movingWidgetUpdater.value = (dx, dy) {
                debouncer.call([dx, dy]);
              };
              movingWidget.value = subcomponent;
            },
            onPointerUp: (event) {
              deleteMovingWidget();
              componentState.updateDesign(componentState.designDraft);
              movingWidgetUpdater.value = null;
              movingWidget.value = null;
            },
            child: MouseRegion(
              opaque: false,
              hitTestBehavior: HitTestBehavior.translucent,
              cursor: movingWidget.value == subcomponent ? SystemMouseCursors.move : MouseCursor.defer,
              child: VisualComponent(
                name: componentState.getMetaByInstance(subcomponent.instanceId).item2.componentName, 
                inputs: componentState.getMetaByInstance(subcomponent.instanceId).item2.inputs, 
                outputs: componentState.getMetaByInstance(subcomponent.instanceId).item2.outputs,
                inputColors: isSimulating.value ? {
                  for (final input in componentState.getMetaByInstance(subcomponent.instanceId).item2.inputs)
                    input: componentState.partialVisualSimulation!.inputsValues['${subcomponent.instanceId}/$input'] == true ? Colors.green 
                      : componentState.partialVisualSimulation!.inputsValues['${subcomponent.instanceId}/$input'] == false ? Colors.red 
                      : Colors.black,
                } : null,
                outputColors: isSimulating.value ? {
                  for (final output in componentState.getMetaByInstance(subcomponent.instanceId).item2.outputs)
                    output: componentState.partialVisualSimulation!.outputsValues['${subcomponent.instanceId}/$output'] == true ? Colors.green 
                      : componentState.partialVisualSimulation!.outputsValues['${subcomponent.instanceId}/$output'] == false ? Colors.red 
                      : Colors.black,
                } : null,
                isNextToSimulate: isSimulating.value && componentState.partialVisualSimulation!.nextToSimulate.contains(subcomponent.instanceId),
                onInputHovered: designSelection.value == 'wiring' && sourceToConnect.value != null ? (input) {
                  hoveredIO.value = '${subcomponent.instanceId}/$input';
                } : null,
                onInputUnhovered: designSelection.value == 'wiring' && sourceToConnect.value != null ? (input) {
                  hoveredIO.value = null;
                } : null,
                onOutputHovered: designSelection.value == 'wiring' && sourceToConnect.value == null ? (output) {
                  hoveredIO.value = '${subcomponent.instanceId}/$output';
                } : null,
                onOutputUnhovered: designSelection.value == 'wiring' && sourceToConnect.value == null ? (output) {
                  hoveredIO.value = null;
                } : null,
              ),
            ),
          ),
        ),
      for (final input in componentState.designDraft.inputs)
        CanvasObject(
          dx: input.x, 
          dy: input.y, 
          width: IOComponent.getNeededWidth(context, input.name, textStyle: Theme.of(context).textTheme.bodyMedium), 
          height: 40, 
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (event) {
              final debouncer = FutureCallDebounce<List<double>>(
                futureCall: (xyList) {
                  final dx = xyList[0];
                  final dy = xyList[1];
                  return componentState.updateDesign(componentState.designDraft.copyWith(
                    inputs: componentState.designDraft.inputs.map(
                      (e) => e.name == input.name ? e.copyWith(
                        x: input.x + dx,
                        y: input.y + dy,
                      ) : e,
                    ).toList(),
                  ), commit: false);
                }, 
                combiner: (oldParams, newParams) {
                  return oldParams.zipWith([newParams], (deltas) => deltas.fold<double>(0.0, (prev, elem) => prev + elem)).toList();
                },
              );
              movingWidgetUpdater.value = (dx, dy) {
                debouncer.call([dx, dy]);
              };
              movingWidget.value = input;
            },
            onPointerUp: (event) {
              deleteMovingWidget();
              componentState.updateDesign(componentState.designDraft);
              movingWidgetUpdater.value = null;
              movingWidget.value = null;
            },
            child: IOComponent(
              input: true,
              name: input.name,
              width: IOComponent.getNeededWidth(context, input.name, textStyle: Theme.of(context).textTheme.bodyMedium),
              color: isSimulating.value 
                ? (componentState.partialVisualSimulation!.outputsValues['self/${input.name}']! 
                  ? Colors.green
                  : Colors.red) 
                : null,
              onTap: isSimulating.value ? () {
                componentState.partialVisualSimulation!.toggleInput(input.name);
              } : null,
              onHovered: designSelection.value == 'wiring' && sourceToConnect.value == null ? () {
                hoveredIO.value = 'self/${input.name}';
              } : null,
              onUnhovered: designSelection.value == 'wiring' && sourceToConnect.value == null ? () {
                hoveredIO.value = null;
              } : null,
              flashing: designSelection.value == 'wiring' && sourceToConnect.value == null,
            ),
          ),
        ),
      for (final output in componentState.designDraft.outputs)
        CanvasObject(
          dx: output.x, 
          dy: output.y, 
          width: IOComponent.getNeededWidth(context, output.name, textStyle: Theme.of(context).textTheme.bodyMedium), 
          height: 40, 
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (event) {
              final debouncer = FutureCallDebounce<List<double>>(
                futureCall: (xyList) {
                  final dx = xyList[0];
                  final dy = xyList[1];
                  return componentState.updateDesign(componentState.designDraft.copyWith(
                    outputs: componentState.designDraft.outputs.map(
                      (e) => e.name == output.name ? e.copyWith(
                        x: output.x + dx,
                        y: output.y + dy,
                      ) : e,
                    ).toList(),
                  ), commit: false);
                }, 
                combiner: (oldParams, newParams) {
                  return oldParams.zipWith([newParams], (deltas) => deltas.fold<double>(0.0, (prev, elem) => prev + elem)).toList();
                },
              );
              movingWidgetUpdater.value = (dx, dy) {
                debouncer.call([dx, dy]);
              };
              movingWidget.value = output;
            },
            onPointerUp: (event) {
              deleteMovingWidget();
              componentState.updateDesign(componentState.designDraft);
              movingWidgetUpdater.value = null;
              movingWidget.value = null;
            },
            child: IOComponent(
              input: false,
              name: output.name,
              width: IOComponent.getNeededWidth(context, output.name, textStyle: Theme.of(context).textTheme.bodyMedium),
              color: isSimulating.value 
                ? (componentState.partialVisualSimulation!.inputsValues['self/${output.name}'] == true ? Colors.green
                  : componentState.partialVisualSimulation!.inputsValues['self/${output.name}'] == false ? Colors.red
                  : null) 
                : null,
              onHovered: designSelection.value == 'wiring' && sourceToConnect.value != null ? () {
                hoveredIO.value = 'self/${output.name}';
              } : null,
              onUnhovered: designSelection.value == 'wiring' && sourceToConnect.value != null ? () {
                hoveredIO.value = null;
              } : null,
              flashing: designSelection.value == 'wiring' && sourceToConnect.value != null,
            ),
          ),
        ),
      for (final wire in componentState.wiringDraft.wires)
        (() {
          const ioCircleDiameter = 20;

          Offset from, to;
          if (wire.output.split('/')[0] == 'self') {
            // It's a component input
            
            // Find input
            final inputName = wire.output.split('/')[1];
            final design = componentState.designDraft.inputs.where((i) => i.name == inputName).first;

            from = Offset(
              // Take into account widget length
              design.x +
                  IOComponent.getNeededWidth(
                    context,
                    inputName,
                    textStyle: Theme.of(context).textTheme.bodyMedium,
                  ),
              design.y + ioCircleDiameter + 1,
            );
          }
          else {
            // It's a subcomponent output

            // Find subcomponent
            final split = wire.output.split('/');
            final subcomponentId = split[0];
            final outputName = split[1];
            final design = componentState.designDraft.components.where((c) => c.instanceId == subcomponentId).first;
            final subcomponent = componentState.getMetaByInstance(subcomponentId).item2;

            from = Offset(
              // Take into account widget length
              design.x +
                VisualComponent.getNeededWidth(
                  context,
                  subcomponent.inputs,
                  subcomponent.outputs,
                  Theme.of(context).textTheme.bodyMedium,
                ),
              design.y +
                VisualComponent.getHeightOfIO(
                  context,
                  subcomponent.outputs,
                  subcomponent.outputs.indexOf(outputName),
                  Theme.of(context).textTheme.bodyMedium,
                ),
            );
          }

          if (wire.input.split('/')[0] == 'self') {
            // It's a component output
            
            // Find output
            final outputName = wire.input.split('/')[1];
            final design = componentState.designDraft.outputs.where((o) => o.name == outputName).first;

            to = Offset(
              design.x,
              design.y + ioCircleDiameter + 1,
            );
          }
          else {
            // It's a subcomponent input

            // Find subcomponent
            final split = wire.input.split('/');
            final subcomponentId = split[0];
            final inputName = split[1];
            final design = componentState.designDraft.components.where((c) => c.instanceId == subcomponentId).first;
            final subcomponent = componentState.getMetaByInstance(subcomponentId).item2;

            to = Offset(
              // Take into account widget length
              design.x,
              design.y +
                VisualComponent.getHeightOfIO(
                  context,
                  subcomponent.inputs,
                  subcomponent.inputs.indexOf(inputName),
                  Theme.of(context).textTheme.bodyMedium,
                ),
            );
          }

          var wireColor = Colors.black;
          if (isSimulating.value) {
            final wireValue = componentState.partialVisualSimulation!.outputsValues[wire.output];
            if (wireValue == true) {
              wireColor = Colors.green;
            }
            else if (wireValue == false) {
              wireColor = Colors.red;
            }
          }

          return CanvasObject(
            dx: min(from.dx, to.dx),
            dy: min(from.dy, to.dy),
            width: (to - from).dx.abs(),
            height: (to - from).dy.abs(),
            child: MouseRegion(
              hitTestBehavior: HitTestBehavior.translucent,
              opaque: false,
              onEnter: (_) {
                if (designSelection.value == 'wiring') {
                  wireToDelete.value = wire.wireId;
                }
              },
              onExit: (_) {
                wireToDelete.value = null;
              },
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  if (designSelection.value == 'wiring') {
                    if (wireToDelete.value != wire.wireId) {
                      wireToDelete.value = wire.wireId;
                    }
                    else {
                      // Delete the wire
                      await componentState.updateDesign(componentState.designDraft.copyWith(
                        wires: componentState.designDraft.wires.where((w) => w.wireId != wireToDelete.value).toList(),
                      ));
                      await componentState.updateWiring(componentState.wiringDraft.copyWith(
                        wires: componentState.wiringDraft.wires.where((w) => w.wireId != wireToDelete.value).toList(),
                      ));
                      wireToDelete.value = null;
                    }
                  }
                },
                child: WireWidget(
                  from: from, 
                  to: to,
                  color: wireToDelete.value == wire.wireId ? Colors.red : wireColor,
                ),
              ),
            ),
          );
        })(),
    ], [componentState.wiringDraft, componentState.designDraft, isSimulating.value, componentState.partialVisualSimulation!.outputsValues, designSelection.value, sourceToConnect.value]);
    useEffect(() {
      final wList = widgets;
      canvasController.addCanvasObjects(wList);

      return () {
        // Cleanup
        for (final obj in wList) {
          canvasController.removeCanvasObject(obj);
        }
      };
    }, [widgets]);
    useEffect(() {
      if (isSimulating.value && !simulatePartially.value && componentState.partialVisualSimulation!.nextToSimulate.isNotEmpty) {
        componentState.partialVisualSimulation!.nextStep();
      }
      return null;
    }, [componentState.partialVisualSimulation!.outputsValues.entries.map((e) => '${e.key}:${e.value}').join(';'), simulatePartially.value, isSimulating.value]);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('${isSimulating.value ? 'Simulation' : 'Design'} - ${component.componentName}'),
        actions: [
          IconButton(
            icon: Icon(isSimulating.value ? Icons.stop : Icons.play_arrow),
            tooltip: isSimulating.value ? 'Stop Simulation' : 'Start Simulation',
            onPressed: () {
              isSimulating.value = !isSimulating.value;
              designSelection.value = null;
            },
          ),
          if (isSimulating.value)
            IconButton(
              icon: const Icon(Icons.description),
              tooltip: 'Scripting',
              onPressed: () {
                showDialog(
                  context: context, 
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Scripting'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: const Text('Load Script...'),
                            onTap: () async {
                              final nav = Navigator.of(context);

                              final selectedFiles = await FilePicker.platform.pickFiles(
                                dialogTitle: "Load Script",
                                // allowedExtensions: ['ht', 'txt'],
                                type: FileType.any,
                              );
                              if (selectedFiles == null || selectedFiles.files.isEmpty) {
                                return;
                              }

                              try {
                                final file = File(selectedFiles.files[0].path!);
                                loadScript(await file.readAsString());
                              } catch (e) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Script Loading Error'),
                                      content: Text(e.toString()),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                              nav.pop();
                            },
                          ),
                          if (scriptingEnvironment.value != null) ...[
                            const Divider(),
                            for (final function in scriptingEnvironment.value!.invoke('getFunctions'))
                              ListTile(
                                title: Text(function),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  try {
                                    scriptingEnvironment.value!.invoke(function);
                                  } on HTError catch (e) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Script Error'),
                                          content: Text(e.toString()),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(), 
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    scriptingEnvironment.value = null;
                                  }
                                },
                              ),
                          ],
                        ],
                      ),
                    );
                  },
                );
              },
            )
        ],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          final stackCanvas = GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanUpdate: (update) {
              final hw = movingWidgetUpdater.value;
              if (hw == null || isSimulating.value) {
                canvasController.offset = canvasController.offset.translate(update.delta.dx, update.delta.dy);
              }
              else {
                hw(update.delta.dx, update.delta.dy);
              }
            },
            onTapUp: (update) async {
              final canvasCenterLocation = canvasController.canvasSize / 2;
              final canvasCenterLocationOffset = Offset(canvasCenterLocation.width, canvasCenterLocation.height);
              final canvasLocation = update.localPosition - canvasCenterLocationOffset + canvasController.offset;
              final ds = designSelection.value;

              if (ds == null) {
                return;
              }
              if (ds == 'wiring') {
                // Handle wire creation
                if (hoveredIO.value == null) {
                  // If clicking on something not hovered, ignore
                  return;  
                }
                else if (sourceToConnect.value == null) {
                  sourceToConnect.value = hoveredIO.value;
                  hoveredIO.value = null;
                } else {
                  // Create wire only if sink is not already connected
                  if (componentState.wiringDraft.wires.where((w) => w.input == hoveredIO.value).isNotEmpty) {
                    // Sink already connected
                    final sinkType = hoveredIO.value!.startsWith('self/') ? 'component output' : 'subcomponent input';
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Wire already connected to that $sinkType.'),
                    ));
                    return;
                  }

                  componentState.updateWiring(componentState.wiringDraft.copyWith(
                    wires: componentState.wiringDraft.wires + [
                      WiringWire(
                        wireId: const Uuid().v4(), 
                        output: sourceToConnect.value!, 
                        input: hoveredIO.value!,
                      ),
                    ],
                  ));
                  sourceToConnect.value = null;
                  hoveredIO.value = null;
                }
              }
              else if (ds.startsWith('input:')) {
                final inputName = ds.substring(6);
                componentState.updateDesign(componentState.designDraft.copyWith(
                  inputs: componentState.designDraft.inputs + [
                    DesignInput(
                      name: inputName,
                      x: canvasLocation.dx - IOComponent.getNeededWidth(context, inputName) / 2,
                      y: canvasLocation.dy,
                    ),
                  ],
                ));
                designSelection.value = null;
              }
              else if (ds.startsWith('output:')) {
                final outputName = ds.substring(7);
                componentState.updateDesign(componentState.designDraft.copyWith(
                  outputs: componentState.designDraft.outputs + [
                    DesignOutput(
                      name: outputName,
                      x: canvasLocation.dx - IOComponent.getNeededWidth(context, outputName) / 2,
                      y: canvasLocation.dy,
                    ),
                  ],
                ));
                designSelection.value = null;
              }
              else {
                final currentProjectState = Provider.of<ProjectState>(context, listen: false);

                // Add subcomponent
                final splitted = ds.split('/');
                var projectId = splitted[0];
                final componentId = splitted[1];

                if (Provider.of<ProjectState>(context, listen: false).currentProject!.projectId == projectId) {
                  projectId = 'self';
                }

                final depId = '$projectId/$componentId';
                final project = projectId == 'self' 
                  ? Provider.of<ProjectState>(context, listen: false).currentProject! 
                  : Provider.of<ProjectsState>(context, listen: false).index.projects.where((p) => p.projectId == projectId).first;
                final projectState = ProjectState();
                await projectState.setCurrentProject(project);
                final component = projectState.index.components.where((c) => c.componentId == componentId).first;

                // Add dependency
                if (!componentState.hasDependency(depId)) {
                  componentState.addDependency(
                    depId, 
                    Tuple2(
                      project,
                      component,
                    ),
                    modifyCurrentComponent: true,
                  );
                  await currentProjectState.editComponent(componentState.currentComponent!);
                }

                // Create component instance
                final instanceId = const Uuid().v4();
                await componentState.updateWiring(componentState.wiringDraft.copyWith(
                  instances: componentState.wiringDraft.instances + [
                    WiringInstance(
                      componentId: depId,
                      instanceId: instanceId,
                    ),
                  ],
                ));
                await componentState.updateDesign(componentState.designDraft.copyWith(
                  components: componentState.designDraft.components + [
                    DesignComponent(
                      instanceId: instanceId,
                      x: canvasLocation.dx,
                      y: canvasLocation.dy,
                    ),
                  ],
                ));

                // Recreate simulation with new subcomponent
                await componentState.recreatePartialSimulation();

                designSelection.value = null;
              }
            },
            child: Stack(
              children: [
                StackCanvas(
                  key: canvasKey,
                  canvasController: canvasController,
                  animationDuration: const Duration(milliseconds: 50),
                  // disposeController: false,
                  backgroundColor: Theme.of(context).colorScheme.background,
                ),
                if (!isSimulating.value) 
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: MouseRegion(
                      hitTestBehavior: HitTestBehavior.translucent,
                      opaque: false,
                      onEnter: (_) {
                        deleteOnDrop.value = true;
                      },
                      onExit: (_) {
                        deleteOnDrop.value = false;
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Icon(
                          Icons.delete,
                          color: movingWidget.value != null && deleteOnDrop.value ? Colors.red : null,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );

          final debuggingButtons = DebuggingButtons(
            partialSimulation: simulatePartially.value,
            onPartialSimulationToggle: () {
              simulatePartially.value = !simulatePartially.value;
            },
            onReset: simulatePartially.value ? () {
              componentState.partialVisualSimulation!.restart();
            } : null,
            onNextStep: simulatePartially.value && componentState.partialVisualSimulation!.nextToSimulate.isNotEmpty ? () {
              componentState.partialVisualSimulation!.nextStep();
            } : null,
          );

          final componentPicker = ComponentPicker(
            key: pickerKey,
            onSelectionUpdate: (selection) {
              designSelection.value = selection;
              if (selection != 'wiring') {
                wireToDelete.value = null;
                sourceToConnect.value = null;
              }
            },
            selection: designSelection.value,
          );

          if (orientation == Orientation.portrait) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      stackCanvas,
                      if (isSimulating.value)
                        Positioned(
                          top: 8,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: debuggingButtons,
                          ),
                        ),
                    ],
                  ),
                ),
                if (!isSimulating.value)
                  componentPicker,
              ],
            );
          }
          else {
            return Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      stackCanvas,
                      if (isSimulating.value)
                        Positioned(
                          top: 8,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: debuggingButtons,
                          ),
                        ),
                    ],
                  ),
                ),
                if (!isSimulating.value)
                  componentPicker,
              ],
            );
          }
        }
      ),
    );
  }
}

class DebuggingButtons extends StatelessWidget {
  final bool partialSimulation;

  final void Function() onPartialSimulationToggle;
  final void Function()? onReset;
  final void Function()? onNextStep;

  const DebuggingButtons({super.key, required this.partialSimulation, required this.onPartialSimulationToggle, this.onReset, this.onNextStep});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onPartialSimulationToggle, 
              icon: Icon(
                partialSimulation ? Icons.play_arrow : Icons.pause,
              ),
              tooltip: partialSimulation ? 'Simulate to end' : 'Simulate partially',
            ),
            IconButton(
              onPressed: onNextStep,
              icon: const Icon(Icons.navigate_next),
              tooltip: 'Simulate next step',
            ),
            IconButton(
              onPressed: onReset, 
              icon: const Icon(Icons.replay_outlined),
              tooltip: 'Restart simulation',
            ),
          ],
        ),
      ),
    );
  }
}

class ComponentPicker extends HookWidget {
  const ComponentPicker({required this.onSelectionUpdate, required this.selection, super.key});

  final String? selection;
  final void Function(String? selection) onSelectionUpdate;

  @override
  Widget build(BuildContext context) {
    final projectsState = useProvider<ProjectsState>();
    final tickerProvider = useSingleTickerProvider();
    final tabBarControllerState = useState<TabController?>(null);
    useEffect(() {
      tabBarControllerState.value = TabController(
        length: 3 + projectsState.projects.length, 
        vsync: tickerProvider,
        initialIndex: 1,
      );

      tabBarControllerState.value!.addListener(() {
        if (tabBarControllerState.value!.index == 0) {
          onSelectionUpdate('wiring');
        }
        else {
          onSelectionUpdate(null);
        }
      });

      return () {
        tabBarControllerState.value?.dispose();
      };
    }, []);
    final tabBarController = tabBarControllerState.value!;

    return OrientationBuilder(
      builder: (context, orientation) {
        return SizedBox(
          height: orientation == Orientation.portrait ? 200 : null,
          width: orientation == Orientation.landscape ? 300 : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TabBar(
                controller: tabBarController,
                tabs: [
                  const Tab(
                    text: 'Wiring',
                  ),
                  const Tab(
                    text: 'Inputs',
                  ),
                  const Tab(
                    text: 'Outputs',
                  ),
                  for (final project in projectsState.projects)
                    Tab(
                      text: project.projectName,
                    ),
                ],
                isScrollable: true,
              ),
              Expanded(
                child: TabBarView(
                  controller: tabBarController,
                  children: [
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'To create wires, click a source and then click a sink to link them.',
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'To remove wires, click them or tap them twice.',
                            ),
                          ),
                        ],
                      ),
                    ),
                    IOComponentPickerOptions(
                      orientation: orientation,
                      outputs: false,
                      selection: selection,
                      onSelected: onSelectionUpdate,
                    ),
                    IOComponentPickerOptions(
                      orientation: orientation,
                      outputs: true,
                      selection: selection,
                      onSelected: onSelectionUpdate,
                    ),
                    for (final project in projectsState.projects)
                      HookBuilder(
                        builder: (context) {
                          final scrollController = useScrollController();

                          final projectState = useFuture(() async {
                            final projectState = ProjectState();
                            await projectState.setCurrentProject(project);
                            return projectState;
                          }());

                          if (projectState.data == null) {
                            return Container();
                          }
                          final components = projectState.data!.index.components;

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('To add a component, select it below and then click on the canvas to place it.'),
                              ),
                              Expanded(
                                child: Scrollbar(
                                  controller: scrollController,
                                  scrollbarOrientation: orientation == Orientation.portrait ? ScrollbarOrientation.bottom : ScrollbarOrientation.right,
                                  child: SingleChildScrollView(
                                    controller: scrollController,
                                    scrollDirection: orientation == Orientation.portrait ? Axis.horizontal : Axis.vertical,
                                    child: Wrap(
                                      direction: orientation == Orientation.portrait ? Axis.vertical : Axis.horizontal,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: [
                                        for (final component in components)
                                          IntrinsicWidth(
                                            child: Card(
                                              color: selection == '${project.projectId}/${component.componentId}' ? Theme.of(context).colorScheme.primaryContainer : null,
                                              child: InkWell(
                                                onTap: () {
                                                  if (selection != '${project.projectId}/${component.componentId}') {
                                                    onSelectionUpdate('${project.projectId}/${component.componentId}');
                                                  }
                                                  else {
                                                    onSelectionUpdate(null);
                                                  }
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    component.componentName,
                                                    style: selection == '${project.projectId}/${component.componentId}' 
                                                      ? TextStyle(
                                                        inherit: true,
                                                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                                                      ) 
                                                      : null,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class IOComponentPickerOptions extends HookWidget {
  final Orientation orientation;
  final bool outputs;
  final String? selection;
  final void Function(String? selection) onSelected;

  const IOComponentPickerOptions({required this.orientation, required this.outputs, required this.selection, required this.onSelected, super.key,});

  String getSelectionName(String option) => '${!outputs ? "input" : "output"}:$option';

  @override
  Widget build(BuildContext context) {
    final componentState = useProvider<ComponentState>();
    
    final scrollController = useScrollController();

    final options = !outputs ? componentState.currentComponent!.inputs : componentState.currentComponent!.outputs;

    return Builder(
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('To add an ${!outputs ? "input" : "output"}, select it below and then click on the canvas to place it. You can only add one of each. Red ${!outputs ? "inputs" : "outputs"} have already been placed.'),
            ),
            Expanded(
              child: Scrollbar(
                controller: scrollController,
                scrollbarOrientation: orientation == Orientation.portrait ? ScrollbarOrientation.bottom : ScrollbarOrientation.right,
                child: SingleChildScrollView(
                  controller: scrollController,
                  scrollDirection: orientation == Orientation.portrait ? Axis.horizontal : Axis.vertical,
                  child: Wrap(
                    direction: orientation == Orientation.portrait ? Axis.vertical : Axis.horizontal,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      for (final option in options)
                        IntrinsicWidth(
                          child: Card(
                            color: (
                              !outputs
                                ? componentState.designDraft.inputs.map((input) => input.name).contains(option)
                                : componentState.designDraft.outputs.map((output) => output.name).contains(option)
                              )
                              ? const Color.fromARGB(100, 255, 0, 0)
                              : selection == getSelectionName(option) 
                              ? Theme.of(context).colorScheme.primaryContainer 
                              : null,
                            child: InkWell(
                              onTap: (
                                !outputs
                                  ? componentState.designDraft.inputs.map((input) => input.name).contains(option)
                                  : componentState.designDraft.outputs.map((output) => output.name).contains(option)
                                ) ? null : () {
                                if (selection == getSelectionName(option)) {
                                  onSelected(null);
                                }
                                else {
                                  onSelected(getSelectionName(option));
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  option,
                                  style: selection == getSelectionName(option) 
                                    ? TextStyle(
                                      inherit: true,
                                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                                    ) 
                                    : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }
    );
  }
}
