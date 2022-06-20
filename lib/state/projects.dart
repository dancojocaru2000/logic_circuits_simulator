import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';
import 'package:logic_circuits_simulator/models.dart';
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
          .followedBy([project])
          .toList()
      )
    );
  }

  Future<T> archiveProject<T>(ProjectEntry project, Future<T> Function(Archive archive) callback) async {
    final projectsDir = await _getProjectsDir();

    // Create dir where export is prepared
    final exportDir = Directory(path.join(projectsDir.path, '.export'));
    await exportDir.create();

    // Write index.json with only that project
    final exportIndex = index.copyWith(
      projects: index.projects.where((p) => p.projectId == project.projectId).toList(growable: false),
    );
    final exportIndexFile = File(path.join(exportDir.path, 'index.json'));
    await exportIndexFile.writeAsString(jsonEncode(exportIndex));

    final exportProjectIdFile = File(path.join(exportDir.path, 'projectId.txt'));
    await exportProjectIdFile.writeAsString(project.projectId);

    // Copy project folder
    final projectDir = Directory(path.join(projectsDir.path, project.projectId));
    final exportProjectDir = Directory(path.join(exportDir.path, project.projectId));
    await exportProjectDir.create();
    await for (final entry in projectDir.list(recursive: true, followLinks: false)) {
      final filename = path.relative(entry.path, from: projectDir.path);
      if (entry is Directory) {
        final newDir = Directory(path.join(exportProjectDir.path, filename));
        await newDir.create(recursive: true);
      }
      else if (entry is File) {
        await entry.copy(path.join(exportProjectDir.path, filename));
      }
      else if (entry is Link) {
        final newLink = Link(path.join(exportProjectDir.path, filename));
        await newLink.create(await entry.target());
      }
    }
    
    // Create archive
    final archive = createArchiveFromDirectory(exportDir, includeDirName: false);

    final result = await callback(archive);

    // Remove preparation dir
    await exportDir.delete(recursive: true);

    return result;
  }

  Future<ProjectEntry?> importProject({required Archive archive, required Future<bool> Function() onConflictingId, required Future<bool> Function(String name) onConflictingName}) async {
    final projectsDir = await _getProjectsDir();

    // Create dir where import is prepared
    final importDir = Directory(path.join(projectsDir.path, '.import'));
    await importDir.create();

    extractArchiveToDisk(archive, importDir.path);

    final projectIdFile = File(path.join(importDir.path, 'projectId.txt'));
    final projectId = (await projectIdFile.readAsString()).trim();

    final indexFile = File(path.join(importDir.path, 'index.json'));
    final importIndex = ProjectsIndex.fromJson(jsonDecode(await indexFile.readAsString()));

    if (index.projects.map((p) => p.projectId).contains(projectId)) {
      if (!await onConflictingId()) {
        return null;
      }
    }
    final importIndexEntry = importIndex.projects.where((p) => p.projectId == projectId).first;

    final importProjectName = importIndexEntry.projectName;
    if (index.projects.where((p) => p.projectId != projectId).map((p) => p.projectName).contains(importProjectName)) {
      if (!await onConflictingName(importProjectName)) {
        return null;
      }
    }

    await _updateIndex(index.copyWith(
      projects: index.projects.where((p) => p.projectId != projectId).followedBy([importIndexEntry]).toList(),
    ));

    // Copy project folder
    final projectDir = Directory(path.join(projectsDir.path, projectId));
    if (await projectDir.exists()) {
      await projectDir.delete(recursive: true);
    }
    await projectDir.create();
    final importProjectDir = Directory(path.join(importDir.path, projectId));
    await for (final entry in importProjectDir.list(recursive: true, followLinks: false)) {
      final filename = path.relative(entry.path, from: importProjectDir.path);
      if (entry is Directory) {
        final newDir = Directory(path.join(projectDir.path, filename));
        await newDir.create(recursive: true);
      }
      else if (entry is File) {
        await entry.copy(path.join(projectDir.path, filename));
      }
      else if (entry is Link) {
        final newLink = Link(path.join(projectDir.path, filename));
        await newLink.create(await entry.target());
      }
    }

    await importDir.delete(recursive: true);

    return index.projects.where((p) => p.projectId == projectId).first;
  }
}
