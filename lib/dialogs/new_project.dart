import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logic_circuits_simulator/state/projects.dart';
import 'package:logic_circuits_simulator/utils/provider_hook.dart';

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
        projectsState.newProject(newDialogNameController.text);
        Navigator.pop(context);
      };
    }, [newDialogNameController.text]); 

    return Center(
      child: Card(
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implement project importing
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Import coming soon...'),
                      ));
                    },
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
                    ),
                    onSubmitted: newProjectAction == null ? null : (_) => newProjectAction(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
