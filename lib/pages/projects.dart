import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logic_circuits_simulator/dialogs/new_project.dart';
import 'package:logic_circuits_simulator/models/projects.dart';
import 'package:logic_circuits_simulator/pages/project.dart';
import 'package:logic_circuits_simulator/state/project.dart';
import 'package:logic_circuits_simulator/state/projects.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

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

  bool get canExport => Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  void onProjectExport(BuildContext context, ProjectEntry p) async {
    final projectsState = Provider.of<ProjectsState>(context, listen: false);
    final msg = ScaffoldMessenger.of(context);

    final outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Export ${p.projectName}',
      fileName: '${p.projectId}.lcsproj',
      allowedExtensions: ['lcsproj'],
      lockParentWindow: true,
      type: FileType.custom,
    );

    if (outputFile == null) {
      return;
    }

    final enc = ZipEncoder();
    await projectsState.archiveProject(
      p, 
      (archive) async {
        enc.encode(archive, output: OutputFileStream(outputFile));
      },
    );

    msg.showSnackBar(
      SnackBar(
        content: Text('Project ${p.projectName} exported'),
      ),
    );
  }

  bool get canShare => !(Platform.isWindows || Platform.isLinux);
  void onProjectShare(BuildContext context, ProjectEntry p) async {
    final projectsState = Provider.of<ProjectsState>(context, listen: false);

    final tmpDir = await getTemporaryDirectory();
    final archiveFile = File(path.join(tmpDir.path, '${p.projectId}.lcsproj'));

    final enc = ZipEncoder();
    await projectsState.archiveProject(
      p, 
      (archive) async {
        enc.encode(archive, output: OutputFileStream(archiveFile.path));
      },
    );

    await Share.shareFiles(
      [archiveFile.path],
      mimeTypes: ['application/zip'],
    );

    await archiveFile.delete();
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
                        onProjectExport: canExport ? () => onProjectExport(context, p) : null,
                        onProjectShare: canShare ? () => onProjectShare(context, p) : null,
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
  final void Function()? onProjectExport;
  final void Function()? onProjectShare;

  const ProjectTile(this.project,
      {Key? key, required this.onProjectSelect, required this.onProjectDelete, required this.onProjectExport, required this.onProjectShare})
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
                  padding: const EdgeInsets.symmetric(
                    vertical: 2.0,
                    horizontal: 8.0,
                  ),
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
                  if (onProjectExport != null) const PopupMenuItem(
                    value: 'export',
                    child: Text('Export'),
                  ),
                  if (onProjectShare != null) const PopupMenuItem(
                    value: 'share',
                    child: Text('Share'),
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
                      onProjectExport?.call();
                      break;
                    case 'share':
                      onProjectShare?.call();
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
