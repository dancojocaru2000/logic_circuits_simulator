import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logic_circuits_simulator/components/visual_component.dart';
import 'package:logic_circuits_simulator/models.dart';
import 'package:logic_circuits_simulator/pages_arguments/design_component.dart';
import 'package:logic_circuits_simulator/state/component.dart';
import 'package:logic_circuits_simulator/utils/future_call_debounce.dart';
import 'package:logic_circuits_simulator/utils/iterable_extension.dart';
import 'package:logic_circuits_simulator/utils/provider_hook.dart';
import 'package:logic_circuits_simulator/utils/stack_canvas_controller_hook.dart';
import 'package:stack_canvas/stack_canvas.dart';

Key canvasKey = GlobalKey();

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

    final movingWidgetUpdater = useState<void Function(double dx, double dy)?>(null);
    final movingWidget = useState<dynamic>(null);
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
              componentState.updateDesign(componentState.designDraft);
              movingWidgetUpdater.value = null;
              movingWidget.value = null;
            },
            child: MouseRegion(
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
            },
            onPointerUp: (event) {
              componentState.updateDesign(componentState.designDraft);
              movingWidgetUpdater.value = null;
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
            },
            onPointerUp: (event) {
              componentState.updateDesign(componentState.designDraft);
              movingWidgetUpdater.value = null;
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
            ),
          ),
        ),
      for (final wire in componentState.wiring.wires)
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
            child: IgnorePointer(
              child: WireWidget(
                from: from, 
                to: to,
                color: wireColor,
              ),
            ),
          );
        })(),
    ], [componentState.designDraft, isSimulating.value, componentState.partialVisualSimulation!.outputsValues]);
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
            icon: Icon(isSimulating.value ? Icons.stop : Icons.start),
            tooltip: isSimulating.value ? 'Stop Simulation' : 'Start Simulation',
            onPressed: () {
              isSimulating.value = !isSimulating.value;
            },
          ),
        ],
      ),
      body: GestureDetector(
        onPanUpdate: (update) {
          final hw = movingWidgetUpdater.value;
          if (hw == null || isSimulating.value) {
            canvasController.offset = canvasController.offset.translate(update.delta.dx, update.delta.dy);
          }
          else {
            hw(update.delta.dx, update.delta.dy);
          }
        },
        child: OrientationBuilder(
          builder: (context, orientation) {
            final stackCanvas = StackCanvas(
              key: canvasKey,
              canvasController: canvasController,
              animationDuration: const Duration(milliseconds: 50),
              // disposeController: false,
              backgroundColor: Theme.of(context).colorScheme.background,
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
                ],
              );
            }
          }
        ),
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