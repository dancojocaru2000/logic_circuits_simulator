import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logic_circuits_simulator/models/project.dart';
import 'package:logic_circuits_simulator/models/projects.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class ProjectState extends ChangeNotifier {
  bool _dirty = false;
  final List<Future Function(ProjectEntry)> _saveHandlers = []; 

  ProjectEntry? _currentProject;
  ProjectIndex _index = const ProjectIndex(components: []);

  ProjectEntry? get currentProject => _currentProject;
  ProjectIndex get index => _index;
  bool get needsSaving => currentProject != null && _dirty;

  Future<Directory> _getProjectDir() async {
    if (_currentProject == null) {
      throw Exception('Cannot get project directory of null');
    }
    final appDir = await getApplicationDocumentsDirectory();
    final result = Directory(path.join(appDir.path, 'LogicCircuitsSimulator', 'projects', _currentProject!.projectId));
    if (!await result.exists()) {
      await result.create(recursive: true);
    }
    return result;
  }

  Future<File> _getIndexFile() async {
    final result = File(path.join((await _getProjectDir()).path, 'index.json'));
    return result;
  }

  Future<void> _loadProjectFiles() async {
    final indexFile = await _getIndexFile();
    if (!await indexFile.exists()) {
      _index = const ProjectIndex(components: []);
      await indexFile.writeAsString(jsonEncode(_index.toJson()));
    }
    else {
      _index = ProjectIndex.fromJson(jsonDecode(await indexFile.readAsString()));
    }
  }

  Future<void> _updateIndex(ProjectIndex newIndex) async {
    _dirty = true;
    _index = newIndex;
    final indexFile = await _getIndexFile();
    await indexFile.writeAsString(jsonEncode(index.toJson()));
    notifyListeners();
  }

  set currentProject(ProjectEntry? p) {
    _currentProject = p;
    _loadProjectFiles().then((_) => notifyListeners());
  }

  void noProject() {
    _currentProject = null;
    _index = const ProjectIndex(components: []);
    notifyListeners();
  }

  Future<void> deleteComponent(String componentId) async {
    await _updateIndex(index.copyWith(components: index.components.where((c) => c.componentId != componentId).toList()));
  }

  Future<ComponentEntry> newComponent() async {
    final newComponent = ComponentEntry(
      componentId: const Uuid().v4(),
      componentName: '',
      inputs: [],
      outputs: [],
    );
    await _updateIndex(index.copyWith(components: index.components + [newComponent]));
    return newComponent;
  }

  Future<void> editComponent(ComponentEntry component) async {
    if (!index.components.map((c) => c.componentId).contains(component.componentId)) {
      throw Exception('Component not in index!');
    }
    await _updateIndex(
      index.copyWith(
        components: index.components
          .where((c) => c.componentId != component.componentId)
          .toList() + [component],
      )
    );
  }

  Future<void> saveProject() async {
    if (!needsSaving) return;
    _currentProject = currentProject?.copyWith(lastUpdate: DateTime.now());
    await Future.wait(_saveHandlers.map((h) => h(_currentProject!)));
    _saveHandlers.clear();
    _dirty = false;
    notifyListeners();
  }

  void registerSaveHandler(Future Function(ProjectEntry) handler) {
    _saveHandlers.add(handler);
  }
}