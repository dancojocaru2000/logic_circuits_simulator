import 'package:flutter/material.dart';

class UnsatisfiedDependenciesDialog extends StatelessWidget {
  final List<String> dependencies;

  const UnsatisfiedDependenciesDialog({required this.dependencies, super.key});

  List<String> get projectIds {
    return dependencies
      .map((dep) => dep.split('/')[0])
      .toSet()
      .toList();
  }

  List<String> componentIds(String projectId) {
    return dependencies
      .map((dep) => dep.split('/'))
      .where((dep) => dep[0] == projectId)
      .map((dep) => dep[1])
      .toSet()
      .toList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Unsatisfied Dependencies'),
      content: IntrinsicWidth(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('The component you are trying to design has the following dependencies that are not available.'),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Consider importing the required projects or checking that they are up to date with the required components.'),
              ),
              ...projectIds.map(
                (pId) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text('Project $pId:'),
                      ),
                      ...componentIds(pId).map(
                        (cId) => Padding(
                          padding: const EdgeInsets.fromLTRB(16.0 + 2.0, 2.0, 2.0, 2.0),
                          child: Text('- Component $cId'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), 
          child: const Text('OK'),
        ),
      ],
    );
  }
}