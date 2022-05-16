import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logic_circuits_simulator/dialogs/new_project.dart';
import 'package:logic_circuits_simulator/models/projects.dart';
import 'package:logic_circuits_simulator/pages/project.dart';
import 'package:logic_circuits_simulator/state/project.dart';
import 'package:logic_circuits_simulator/state/projects.dart';
import 'package:provider/provider.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({Key? key}) : super(key: key);

  static const String routeName = '/projects';

  void onNewProject(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const NewProjectDialog();
      },
    );
  }

  void onProjectDelete(BuildContext context, ProjectEntry p) {
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
                Provider.of<ProjectsState>(context, listen: false)
                    .deleteProject(p.projectId);
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              child: const Text('Delete'),
            ),
          ],
          title: Text('Delete project ${p.projectName}'),
          content: const Text('Are you sure you want to delete the project?'),
        );
      },
    );
  }

  void onProjectSelect(BuildContext context, ProjectEntry p) {
    Provider.of<ProjectState>(context, listen: false).currentProject = p;
    Provider.of<ProjectState>(context, listen: false).registerSaveHandler((p) async {
      await Provider.of<ProjectsState>(context, listen: false).updateProject(p);
    });
    Navigator.of(context).pushNamed(ProjectPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final projects = Provider.of<ProjectsState>(context).projects;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        centerTitle: true,
      ),
      body: projects.isNotEmpty
          ? SingleChildScrollView(
            child: Wrap(
                runSpacing: 8,
                spacing: 8,
                children:
                    projects.map((p) => IntrinsicWidth(
                      child: ProjectTile(
                        p,
                        onProjectDelete: () => onProjectDelete(context, p),
                        onProjectExport: () {
                          // TODO: Implement project export
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Export coming soon...')));
                        },
                        onProjectSelect: () => onProjectSelect(context, p),
                      ),
                    )).toList(growable: false),
              ),
          )
          : Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'No projects',
                    style: Theme.of(context).textTheme.headline4,
                    textAlign: TextAlign.center,
                  ),
                  const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: 'Use the '),
                        WidgetSpan(
                            child: Icon(
                          Icons.add,
                          size: 16,
                        )),
                        TextSpan(text: ' button to add a new project.'),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onNewProject(context),
        tooltip: 'New Project',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ProjectTile extends StatelessWidget {
  final ProjectEntry project; 
  final void Function() onProjectSelect;
  final void Function() onProjectDelete;
  final void Function() onProjectExport;

  const ProjectTile(this.project,
      {Key? key, required this.onProjectSelect, required this.onProjectDelete, required this.onProjectExport})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onProjectSelect,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Text(
                          project.projectName,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      const SizedBox(width: 36,),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    DateFormat.yMMMd().add_jms().format(project.lastUpdate.toLocal()),
                    style: Theme.of(context).textTheme.caption,
                    textAlign: TextAlign.end,
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
                    value: 'export',
                    child: Text('Export'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
                onSelected: (selectedOption) {
                  switch (selectedOption) {
                    case 'delete':
                      onProjectDelete();
                      break;
                    case 'export':
                      onProjectExport();
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
