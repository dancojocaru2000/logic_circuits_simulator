import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logic_circuits_simulator/models/projects.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class ProjectsState extends ChangeNotifier {
  ProjectsState() {
    _init();
  }

  List<ProjectEntry> get projects => index.projects;
  ProjectsIndex index = const ProjectsIndex(projects: []);

  Future<Directory> _getProjectsDir() async {
    final appDir = await getApplicationDocumentsDirectory();
    final result = Directory(path.join(appDir.path, 'LogicCircuitsSimulator', 'projects'));
    if (!await result.exists()) {
      await result.create(recursive: true);
    }
    return result;
  }

  Future<File> _getIndexFile() async {
    final result = File(path.join((await _getProjectsDir()).path, 'index.json'));
    return result;
  }

  Future<void> _updateIndex(ProjectsIndex newIndex) async {
    // Sort projects when updating: latest update first
    index = newIndex.copyWith(projects: newIndex.projects.toList()..sort((p1, p2) => p2.lastUpdate.compareTo(p1.lastUpdate)));
    final indexFile = await _getIndexFile();
    await indexFile.writeAsString(const JsonEncoder.withIndent("  ").convert(index.toJson()));
    notifyListeners();
  }

  void _init() async {
    final indexFile = await _getIndexFile();
    if (await indexFile.exists()) {
      index = ProjectsIndex.fromJson(jsonDecode(await indexFile.readAsString()));
      notifyListeners();
    }
  }

  Future<void> newProject(String projectName) async {
    final id = const Uuid().v4();
    final project = ProjectEntry(
      lastUpdate: DateTime.now(), 
      projectName: projectName, 
      projectId: id,
    );
    await _updateIndex(index.copyWith(projects: index.projects + [project]));
    final projectDir = await Directory(path.join((await _getProjectsDir()).path, id)).create();
    await Directory(path.join(projectDir.path, 'components')).create();
    if (kDebugMode) {
      print('Created new project in ${projectDir.path}');
    }
  }

  Future<void> deleteProject(String projectId) async {
    await _updateIndex(index.copyWith(projects: index.projects.where((p) => p.projectId != projectId).toList()));
    await Directory(path.join((await _getProjectsDir()).path, projectId)).delete(recursive: true);
  }

  Future<void> updateProject(ProjectEntry project) async {
    if (!index.projects.map((p) => p.projectId).contains(project.projectId)) {
      throw Exception('Project not in index!');
    }
    await _updateIndex(
      index.copyWith(
        projects: index.projects
          .where((p) => p.projectId != project.projectId)
          .toList() + [project]
      )
    );
  }
}
