import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logic_circuits_simulator/components/truth_table.dart';
import 'package:logic_circuits_simulator/dialogs/new_ask_for_name.dart';
import 'package:logic_circuits_simulator/models/project.dart';
import 'package:logic_circuits_simulator/state/project.dart';
import 'package:logic_circuits_simulator/utils/iterable_extension.dart';
import 'package:logic_circuits_simulator/utils/provider_hook.dart';

class EditComponentPage extends HookWidget {
  final bool newComponent;
  final ComponentEntry component;

  const EditComponentPage({Key? key, this.newComponent = false, required this.component}) : super(key: key);

  static const String routeName = '/project/component/edit';

  @override
  Widget build(BuildContext context) {
    final anySave = useState(false);
    final projectState = useProvider<ProjectState>();
    ComponentEntry ce() => projectState.index.components.where((c) => c.componentId == component.componentId).first;
    final truthTable = useState(ce().truthTable?.toList());
    final logicExpression = useState(ce().logicExpression);
    final inputs = useState(ce().inputs.toList());
    final outputs = useState(ce().outputs.toList());
    final componentNameEditingController = useTextEditingController(text: ce().componentName);
    useValueListenable(componentNameEditingController);
    final dirty = useMemoized(
      () {
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
        if (truthTable.value == null && logicExpression.value == null) {
          // Don't allow saving components without functionality
          return false;
        }

        if (componentNameEditingController.text != ce().componentName) {
          return true;
        }
        if (!const ListEquality().equals(inputs.value, ce().inputs)) {
          return true;
        }
        if (!const ListEquality().equals(outputs.value, ce().outputs)) {
          return true;
        }
        if (!const ListEquality().equals(truthTable.value, ce().truthTable)) {
          return true;
        }
        if (logicExpression.value != ce().logicExpression) {
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
      ],
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
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Component name',
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                          truthTable.value = truthTable.value?.expand((element) => [element, element]).toList();
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
                  leading: inputs.value.length > 1 ? IconButton(
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
                        if (truthTable.value != null) {
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
                  title: Text(inputs.value[idx]),
                ),
                childCount: inputs.value.length,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                          truthTable.value = truthTable.value?.map((e) => '${e}0').toList();
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
                  leading: outputs.value.length > 1 ? IconButton(
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
                        if (truthTable.value != null) {
                          for (var i = 0; i < truthTable.value!.length; i++) {
                            truthTable.value!.replaceRange(i, i+1, [truthTable.value![i].replaceRange(idx, idx+1, "")]);
                          }
                        }
                        outputs.value = outputs.value.toList()..removeRange(idx, idx+1);
                      }
                    },
                  ) : null,
                  title: Text(outputs.value[idx]),
                ),
                childCount: outputs.value.length,
              ),
            ),
            if (truthTable.value == null && logicExpression.value == null) ...[
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const Divider(),
                    Text(
                      'Choose component kind',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        onPressed: () {
                          logicExpression.value = '';
                        }, 
                        child: const Text('Logic Expression'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        onPressed: () {
                          final row = "0" * outputs.value.length;
                          truthTable.value = List.generate(pow(2, inputs.value.length) as int, (_) => row);
                        }, 
                        child: const Text('Truth Table'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        onPressed: null, 
                        child: const Text('Visual Designer'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (logicExpression.value != null) ...[

            ],
            if (truthTable.value != null) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Truth Table',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TruthTableEditor(
                    truthTable: truthTable.value!,
                    inputs: inputs.value,
                    outputs: outputs.value,
                    onUpdateTable: (idx, newValue) {
                      truthTable.value = truthTable.value?.toList()?..replaceRange(idx, idx+1, [newValue]);
                    },
                  ),
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
              await projectState.editComponent(ce().copyWith(componentName: componentNameEditingController.text));
            }
            await projectState.editComponent(ce().copyWith(
              inputs: inputs.value,
              outputs: outputs.value,
              truthTable: truthTable.value,
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
