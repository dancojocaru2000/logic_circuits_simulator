import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logic_circuits_simulator/components/logic_expression_field.dart';
import 'package:logic_circuits_simulator/components/truth_table.dart';
import 'package:logic_circuits_simulator/dialogs/new_ask_for_name.dart';
import 'package:logic_circuits_simulator/dialogs/unsatisfied_dependencies.dart';
import 'package:logic_circuits_simulator/models.dart';
import 'package:logic_circuits_simulator/pages/design_component.dart';
import 'package:logic_circuits_simulator/pages_arguments/design_component.dart';
import 'package:logic_circuits_simulator/pages_arguments/edit_component.dart';
import 'package:logic_circuits_simulator/state/component.dart';
import 'package:logic_circuits_simulator/state/project.dart';
import 'package:logic_circuits_simulator/state/projects.dart';
import 'package:logic_circuits_simulator/utils/iterable_extension.dart';
import 'package:logic_circuits_simulator/utils/logic_expressions.dart';
import 'package:logic_circuits_simulator/utils/logic_operators.dart';
import 'package:logic_circuits_simulator/utils/provider_hook.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class EditComponentPage extends HookWidget {
  final bool newComponent;
  final ComponentEntry component;

  const EditComponentPage({super.key, this.newComponent = false, required this.component});
  EditComponentPage.fromArguments(EditComponentPageArguments args, {super.key}) 
    : component = args.component, newComponent = args.newComponent;

  static const String routeName = '/project/component/edit';

  @override
  Widget build(BuildContext context) {
    final anySave = useState(false);
    final projectState = useProvider<ProjectState>();
    ComponentEntry ce() => projectState.index.components.where((c) => c.componentId == component.componentId).first;
    final truthTable = useState(ce().truthTable?.toList());
    final logicExpressions = useState(ce().logicExpression);
    final logicExpressionsParsed = useState(
      logicExpressions.value == null
        ? null
        : List<LogicExpression?>.generate(logicExpressions.value!.length, (index) => null),
    );
    final visualDesigned = useState(ce().visualDesigned);
    final inputs = useState(ce().inputs.toList());
    final outputs = useState(ce().outputs.toList());
    final componentNameEditingController = useTextEditingController(text: ce().componentName);
    useValueListenable(componentNameEditingController);
    final dirty = useMemoized(
      () {
        const le = ListEquality();

        if (componentNameEditingController.text.isEmpty) {
          // Don't allow saving empty name
          return false;
        }
        if (inputs.value.isEmpty) {
          // Don't allow saving empty inputs
          return false;
        }
        if (outputs.value.isEmpty) {
          // Don't allow saving empty outputs
          return false;
        }
        if (truthTable.value == null && logicExpressions.value == null && !visualDesigned.value) {
          // Don't allow saving components without functionality
          return false;
        }
        if (logicExpressionsParsed.value != null && logicExpressionsParsed.value?.contains(null) != false) {
          // Don't allow saving components with errors in parsing logic expressions
          return false;
        }

        if (componentNameEditingController.text.trim() != ce().componentName.trim()) {
          return true;
        }
        if (!le.equals(inputs.value, ce().inputs)) {
          return true;
        }
        if (!le.equals(outputs.value, ce().outputs)) {
          return true;
        }
        if (!le.equals(truthTable.value, ce().truthTable)) {
          return true;
        }
        if (!le.equals(logicExpressions.value, ce().logicExpression)) {
          return true;
        }
        if (visualDesigned.value != ce().visualDesigned) {
          return true;
        }
        return false;
      },
      [
        componentNameEditingController.text,
        ce().componentName,
        inputs.value,
        ce().inputs,
        outputs.value,
        ce().outputs,
        truthTable.value,
        ce().truthTable,
        logicExpressions.value,
        ce().logicExpression,
        visualDesigned.value,
        ce().visualDesigned,
        logicExpressionsParsed.value,
      ],
    );

    final updateTTFromLE = useMemoized(
      () {
        return () {
          if (logicExpressionsParsed.value?.contains(null) != false) {
            truthTable.value = null;
          }
          else {
            truthTable.value = logicExpressionsParsed.value!.first!.computeTruthTable(inputs.value).zipWith(
              logicExpressionsParsed.value!.skip(1).map((le) => le!.computeTruthTable(inputs.value)),
              (args) => args.join(),
            ).toList();
          }
        };
      },
      [logicExpressions.value, truthTable.value]
    );

    return WillPopScope(
      onWillPop: () async {
        if (!dirty && !newComponent) {
          Navigator.of(context).pop(true);
        } else if (!dirty && anySave.value) {
          Navigator.of(context).pop(true);
        } else {
          final dialogResult = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    child: const Text('Discard'),
                  ),
                ],
                title: Text('Cancel ${newComponent ? 'Creation' : 'Editing'}'),
                content: Text(newComponent ? 'A new component will not be created.' : 'Are you sure you want to discard the changes?'),
              );
            }
          );
          if (dialogResult == true) {
            // ignore: use_build_context_synchronously
            Navigator.of(context).pop(!newComponent);
          }
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(newComponent ? 'New Component' : 'Edit Component'),
          centerTitle: true,
        ),
        body: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: SliverToBoxAdapter(
                child: TextField(
                  controller: componentNameEditingController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Component name',
                    errorText: projectState.index.components.where((c) => c.componentId != ce().componentId).map((c) => c.componentName).contains(componentNameEditingController.text.trim())
                      ? 'A component with the same name already exists'
                      : null,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'Inputs',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      tooltip: 'Add new input',
                      onPressed: () async {
                        final inputName = await showDialog<String>(
                          context: context,
                          builder: (context) {
                            return const NewAskForNameDialog(
                              title: 'New Input',
                              labelText: 'Input name',
                            );
                          },
                        );
                        if (inputName != null) {
                          if (logicExpressions.value != null) {
                            // They should update themselves
                            updateTTFromLE();
                          }
                          else if (truthTable.value != null) {
                            truthTable.value = truthTable.value?.expand((element) => [element, element]).toList();
                          }
                          inputs.value = inputs.value.toList()..add(inputName);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, idx) => ListTile(
                  title: Text(inputs.value[idx]),
                  trailing: inputs.value.length > 1 ? IconButton(
                    icon: const Icon(Icons.remove_circle),
                    color: Colors.red,
                    tooltip: 'Remove input ${inputs.value[idx]}',
                    onPressed: () async {
                      final shouldRemove = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Remove Input ${inputs.value[idx]}?'),
                            content: const Text('Are you sure you want to remove the input?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all(Colors.white),
                                  backgroundColor: MaterialStateProperty.all(Colors.red),
                                ),
                                child: const Text('Remove'),
                              ),
                            ],
                          );
                        },
                      );
                      if (shouldRemove == true) {
                        if (logicExpressions.value != null) {
                          // They should update themselves
                          updateTTFromLE();
                        }
                        else if (truthTable.value != null) {
                          final tt = truthTable.value!.toList();
                          final shiftIndex = inputs.value.length - 1 - idx;
                          final shifted = 1 << shiftIndex;
                          final indecesToRemove = [];
                          for (var i = tt.length - 1; i >= 0; i--) {
                            if (i & shifted == 0) {
                              indecesToRemove.add(i);
                            }
                          } 
                          for (final i in indecesToRemove) {
                            tt.removeAt(i);
                          }
                          truthTable.value = tt;
                        }
                        inputs.value = inputs.value.toList()..removeRange(idx, idx+1);
                      }
                    },
                  ) : null,
                ),
                childCount: inputs.value.length,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'Outputs',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      tooltip: 'Add new output',
                      onPressed: () async {
                        final outputName = await showDialog<String>(
                          context: context,
                          builder: (context) {
                            return const NewAskForNameDialog(
                              title: 'New Output',
                              labelText: 'Output name',
                            );
                          },
                        );
                        if (outputName != null) {
                          if (logicExpressions.value != null) {
                            logicExpressions.value = logicExpressions.value!.followedBy(['']).toList();
                            logicExpressionsParsed.value = logicExpressionsParsed.value?.followedBy([LogicExpression.ofZeroOp(FalseLogicOperator())]).toList();
                            updateTTFromLE();
                          }
                          else if (truthTable.value != null) {
                            truthTable.value = truthTable.value?.map((e) => '${e}0').toList();
                          }
                          outputs.value = outputs.value.toList()..add(outputName);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, idx) => ListTile(
                  title: Text(outputs.value[idx]),
                  trailing: outputs.value.length > 1 ? IconButton(
                    icon: const Icon(Icons.remove_circle),
                    color: Colors.red,
                    tooltip: 'Remove output ${outputs.value[idx]}',
                    onPressed: () async {
                      final shouldRemove = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Remove Output ${outputs.value[idx]}?'),
                            content: const Text('Are you sure you want to remove the output?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all(Colors.white),
                                  backgroundColor: MaterialStateProperty.all(Colors.red),
                                ),
                                child: const Text('Remove'),
                              ),
                            ],
                          );
                        },
                      );
                      if (shouldRemove == true) {
                        if (logicExpressions.value != null) {
                          logicExpressions.value = logicExpressions.value?.toList()?..replaceRange(idx, idx+1, []);
                          logicExpressionsParsed.value = logicExpressionsParsed.value?.toList()?..replaceRange(idx, idx+1, []);
                          updateTTFromLE();
                        }
                        else if (truthTable.value != null) {
                          for (var i = 0; i < truthTable.value!.length; i++) {
                            truthTable.value!.replaceRange(i, i+1, [truthTable.value![i].replaceRange(idx, idx+1, "")]);
                          }
                        }
                        outputs.value = outputs.value.toList()..removeRange(idx, idx+1);
                      }
                    },
                  ) : null,
                ),
                childCount: outputs.value.length,
              ),
            ),
            const SliverToBoxAdapter(
              child: Divider(),
            ),
            if (inputs.value.isEmpty && outputs.value.isEmpty)
              SliverToBoxAdapter(
                child: Text(
                  'Add inputs and outputs to continue',
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
              )
            else if (inputs.value.isEmpty)
              SliverToBoxAdapter(
                child: Text(
                  'Add inputs to continue',
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
              )
            else if (outputs.value.isEmpty)
              SliverToBoxAdapter(
                child: Text(
                  'Add outputs to continue',
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
              )
            else if (truthTable.value == null && logicExpressions.value == null && !visualDesigned.value) ...[
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Text(
                      'Choose component kind',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        onPressed: () {
                          // For each output, a separate logic expression is needed
                          logicExpressions.value = List.generate(
                            outputs.value.length, 
                            (index) => '',
                          );
                          logicExpressionsParsed.value = List.generate(
                            outputs.value.length, 
                            (index) => null,
                          );
                        }, 
                        child: const Text('Logic Expression'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        onPressed: () {
                          // Assign false by default to each output
                          final row = "0" * outputs.value.length;
                          // There are 2^inputs combinations in a truth table
                          truthTable.value = List.generate(
                            pow(2, inputs.value.length) as int, 
                            (_) => row,
                          );
                        }, 
                        child: const Text('Truth Table'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        onPressed: () {
                          visualDesigned.value = true;
                        }, 
                        child: const Text('Visual Designer'),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        onPressed: null, 
                        child: Text('Script'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (logicExpressions.value != null) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    outputs.value.length == 1 ? 'Logic Expression' : 'Logic Expressions',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LogicExpressionField(
                        inputsListener: inputs,
                        outputName: outputs.value[index],
                        initialText: logicExpressions.value![index],
                        onChanged: (newValue, newExpression) {
                          logicExpressions.value = logicExpressions.value!.toList();
                          logicExpressions.value![index] = newValue;
                          logicExpressionsParsed.value = logicExpressionsParsed.value!.toList();
                          logicExpressionsParsed.value![index] = newExpression;
                          updateTTFromLE();
                        },
                        onInputError: () {
                          logicExpressionsParsed.value = logicExpressionsParsed.value!.toList();
                          logicExpressionsParsed.value![index] = null;
                          updateTTFromLE();
                        },
                      ),
                    );
                  },
                  childCount: logicExpressions.value!.length,
                ),
              ),
            ],
            if (truthTable.value != null) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    logicExpressions.value == null ? 'Truth Table' : 'Resulting Truth Table',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ),
              if (logicExpressions.value == null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Tap output cells to toggle',
                      style: Theme.of(context).textTheme.caption,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: constraints.maxWidth),
                          child: TruthTableEditor(
                            truthTable: truthTable.value!,
                            inputs: inputs.value,
                            outputs: outputs.value,
                            // Only allow updating truth table if it is *NOT* autogenerated by logic expressions
                            onUpdateTable: logicExpressions.value != null ? null : (idx, newValue) {
                              truthTable.value = truthTable.value?.toList()?..replaceRange(idx, idx+1, [newValue]);
                            },
                          ),
                        ),
                      );
                    }
                  ),
                ),
              )
            ],
            if (visualDesigned.value) ...[
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Text(
                      "Visually Designed Component",
                      style: Theme.of(context).textTheme.headline4,
                      textAlign: TextAlign.center,
                    ),
                    if (dirty) Text(
                      "Save the component to open the designer",
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ) else Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          final nav = Navigator.of(context);
                          final projectsState = Provider.of<ProjectsState>(context, listen: false);
                          try {
                            await Provider.of<ComponentState>(context, listen: false).setCurrentComponent(
                              project: projectState.currentProject!, 
                              component: component,
                              onDependencyNeeded: (String projectId, String componentId) async {
                                if (projectId == 'self') {
                                  final maybeComponent = projectState.index.components.where((c) => c.componentId == componentId).firstOrNull;
                                  return maybeComponent == null ? null : Tuple2(projectState.currentProject!, maybeComponent);
                                }
                                else {
                                  final maybeProject = projectsState.projects.where((p) => p.projectId == projectId).firstOrNull;
                                  if (maybeProject == null) {
                                    return null;
                                  }
                                  final projectState = ProjectState();
                                  await projectState.setCurrentProject(maybeProject);
                                  final maybeComponent = projectState.index.components.where((c) => c.componentId == componentId).firstOrNull;
                                  if (maybeComponent == null) {
                                    return null;
                                  }
                                  return Tuple2(maybeProject, maybeComponent);
                                }
                              },
                            );
                            nav.pushNamed(
                              DesignComponentPage.routeName, 
                              arguments: DesignComponentPageArguments(
                                component: component,
                              ),
                            );
                          } on DependenciesNotSatisfiedException catch (e) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return UnsatisfiedDependenciesDialog(
                                  dependencies: e.dependencies,
                                );
                              }
                            );
                          }
                        }, 
                        child: const Text('Open Designer'),
                      ),
                    ),
                  ],
                ),
              )
            ],
            const SliverPadding(
              padding: EdgeInsets.only(bottom: 56 + 16 + 16),
            ),
          ],
        ),
        floatingActionButton: !dirty ? null : FloatingActionButton(
          onPressed: () async {
            if (componentNameEditingController.text.isNotEmpty) {
              await projectState.editComponent(ce().copyWith(componentName: componentNameEditingController.text.trim()));
            }
            await projectState.editComponent(ce().copyWith(
              inputs: inputs.value,
              outputs: outputs.value,
              truthTable: truthTable.value,
              logicExpression: logicExpressions.value,
              visualDesigned: visualDesigned.value,
            ));
            anySave.value = true;
            // TODO: Implement saving
          },
          tooltip: 'Save Component',
          child: const Icon(Icons.save),
        ),
      ),
    );
  }
}
