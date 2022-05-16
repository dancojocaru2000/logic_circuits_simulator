
import 'package:flutter/material.dart';
import 'package:logic_circuits_simulator/models/project.dart';
import 'package:logic_circuits_simulator/pages/edit_component.dart';
import 'package:logic_circuits_simulator/pages_arguments/edit_component.dart';
import 'package:logic_circuits_simulator/state/project.dart';
import 'package:provider/provider.dart';

class ProjectPage extends StatelessWidget {
  const ProjectPage({Key? key}) : super(key: key);

  static const String routeName = '/project';

  void onComponentDelete(BuildContext context, ComponentEntry c) {
    showDialog(
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
                Provider.of<ProjectState>(context, listen: false)
                    .deleteComponent(c.componentId);
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              child: const Text('Delete'),
            ),
          ],
          title: Text('Delete component ${c.componentName}'),
          content: const Text('Are you sure you want to delete the component?'),
        );
      },
    );
  }

  Future<bool> onComponentEdit(BuildContext context, ComponentEntry c, {bool newComponent = false}) {
    return Navigator.of(context).pushNamed(
      EditComponentPage.routeName, 
      arguments: EditComponentPageArguments(
        component: c,
        newComponent: newComponent,
      ),
    ).then((value) => value == true,);
  }

  void onComponentCreate(BuildContext context) async {
    final newComponent = await Provider.of<ProjectState>(context, listen: false).newComponent();
    // ignore: use_build_context_synchronously
    if (!await onComponentEdit(context, newComponent, newComponent: true)) {
      // ignore: use_build_context_synchronously
      await Future.delayed(
        const Duration(milliseconds: 500), 
        () => Provider.of<ProjectState>(context, listen: false)
          .deleteComponent(newComponent.componentId),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final project = Provider.of<ProjectState>(context).currentProject;
    final index = Provider.of<ProjectState>(context).index;

    return WillPopScope(
      onWillPop: () async {
        final ps = Provider.of<ProjectState>(context, listen: false);
        if (ps.needsSaving) {
          Future? saveFuture;
          await showDialog(
            context: context, 
            barrierDismissible: false,
            builder: (context) {
              saveFuture ??= ps.saveProject().then((_) {
                Navigator.of(context).pop();
              });
              return Center(
                child: Card(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Saving...'),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }
        ps.noProject();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(project?.projectName ?? 'No Project'),
          centerTitle: true,
        ),
        body: project == null ? Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'No project selected',
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ) : CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: SliverToBoxAdapter(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'Components',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        onComponentCreate(context);
                      }, 
                      icon: const Icon(Icons.add),
                      tooltip: 'New Component',
                    ),
                  ],
                ),
              ),
            ),
            if (index.components.isNotEmpty) 
              SliverToBoxAdapter(
                child: Wrap(
                  runSpacing: 8,
                  spacing: 8,
                  children: index.components.map((c) => IntrinsicWidth(
                    child: ComponentCard(
                      component: c,
                      onComponentDelete: () => onComponentDelete(context, c),
                      onComponentEdit: () => onComponentEdit(context, c),
                    ),
                  )).toList(growable: false),   
                ),
              )
            else
              SliverToBoxAdapter(
                child: Center(
                  child: Text(
                    'No Components',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ComponentCard extends StatelessWidget {
  final ComponentEntry component;

  final void Function() onComponentDelete;
  final void Function() onComponentEdit;

  const ComponentCard({Key? key, required this.component, required this.onComponentDelete, required this.onComponentEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          onComponentEdit();
        },
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          component.componentName,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      const SizedBox(width: 36,),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
                onSelected: (selectedOption) {
                  switch (selectedOption) {
                    case 'delete':
                      onComponentDelete();
                      break;
                    default:
                      throw Exception('Unexpected option: $selectedOption');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
