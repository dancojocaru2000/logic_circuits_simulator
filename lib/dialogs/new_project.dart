import 'dart:io';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logic_circuits_simulator/state/projects.dart';
import 'package:logic_circuits_simulator/utils/provider_hook.dart';
import 'package:provider/provider.dart';

class NewProjectDialog extends HookWidget {
  const NewProjectDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final projectsState = useProvider<ProjectsState>();
    final newDialogNameController = useTextEditingController();
    useListenable(newDialogNameController);

    final newProjectAction = useMemoized(() {
      if (newDialogNameController.text.isEmpty) return null;
      return () {
        projectsState.newProject(newDialogNameController.text.trim());
        Navigator.pop(context);
      };
    }, [newDialogNameController.text]); 

    final importProjectAction = useMemoized(() {
      return () async {
        final projectsState = Provider.of<ProjectsState>(context, listen: false);
        final msg = ScaffoldMessenger.of(context);
        final nav = Navigator.of(context);

        try {
          final inputFiles = await FilePicker.platform.pickFiles(
            dialogTitle: 'Import Project',
            allowedExtensions: Platform.isLinux || Platform.isWindows ? ['lcsproj'] : null,
            lockParentWindow: true,
            type: Platform.isLinux || Platform.isWindows ? FileType.custom : FileType.any,
            allowMultiple: false,
            withData: true,
          );

          if (inputFiles == null) {
            return;
          }

          final inputFile = inputFiles.files.first;

          final dec = ZipDecoder();
          final archive = dec.decodeBytes(inputFile.bytes!);
          
          // bool editAfter = false;
          final result = await projectsState.importProject(
            archive: archive,
            onConflictingId: () async {
              final response = await showDialog<bool>(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Conflicting ID'),
                    content: const Text('You already have a project with the same ID as the one you are importing.\n\nAre you sure you want to replace the current project with the imported one?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        }, 
                        child: const Text('Cancel'),
                      ),
                      Theme(
                        data: ThemeData(
                          brightness: Theme.of(context).brightness,
                          primarySwatch: Colors.red,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          }, 
                          child: const Text('Overwrite and import'),
                        ),
                      ),
                    ],
                  );
                },
              );

              // Allow conflicting id ONLY if allow button is explicitly tapped
              return response == true;
            },
            onConflictingName: (String name) async {
              final response = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Conflicting name'),
                    content: Text('You already have a project named $name.\n\nYou may import the project and have both coexist, but confusion may arise.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        }, 
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        }, 
                        child: const Text('Import anyway'),
                      ),
                    ],
                  );
                },
              );

              // Allow conflicting name UNLESS deny button is explicitly tapped
              return response != false;
            },
          );

          if (result != null) {
            nav.pop();
            // if (!editAfter) {
              msg.showSnackBar(
                SnackBar(
                  content: Text('Project ${result.projectName} imported'),
                ),
              );
            // }
            // else {
            //   // TODO: Allow editing project name in the future
            // }
          }
        }
        catch (e) {
          nav.pop();
          msg.showSnackBar(
            SnackBar(
              content: Text('Failed to import project: $e'),
              duration: const Duration(seconds: 10),
            ),
          );
        }
      };
    });

    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: 'Close',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton.icon(
                      onPressed: importProjectAction,
                      icon: const Icon(Icons.download),
                      label: const Text('Import Project'),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Divider(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'OR',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Divider(),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'New Project',
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 300),
                    child: TextField(
                      controller: newDialogNameController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Project name',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.done),
                          onPressed: newProjectAction,
                        ),
                        errorText: projectsState.projects.map((p) => p.projectName).contains(newDialogNameController.text.trim())
                          ? 'A project with the same name already exists'
                          : null,
                      ),
                      onSubmitted: newProjectAction == null ? null : (_) => newProjectAction(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
