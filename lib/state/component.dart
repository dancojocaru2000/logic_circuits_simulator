import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logic_circuits_simulator/models.dart';
import 'package:logic_circuits_simulator/utils/simulation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:tuple/tuple.dart';

class ComponentState extends ChangeNotifier {
  ProjectEntry? _currentProject;
  ComponentEntry? _currentComponent;
  Wiring _wiring = const Wiring(instances: [], wires: []);
  SimulatedComponent? _simulatedComponent;

  final Map<String, Tuple2<ProjectEntry, ComponentEntry>> _dependenciesMap = {};

  ProjectEntry? get currentProject => _currentProject;
  ComponentEntry? get currentComponent => _currentComponent;
  Wiring get wiring => _wiring;

  Future<Directory> _getComponentDir() async {
    if (_currentProject == null) {
      throw Exception('Cannot get component directory without knowing project');
    }
    if (_currentComponent == null) {
      throw Exception('Cannot get component directory of null');
    }
    final appDir = await getApplicationDocumentsDirectory();
    final result = Directory(path.join(appDir.path, 'LogicCircuitsSimulator', 'projects', _currentProject!.projectId, 'components', _currentComponent!.componentId));
    if (!await result.exists()) {
      await result.create(recursive: true);
    }
    return result;
  }

  Future<File> _getWiringFile() async {
    final result = File(path.join((await _getComponentDir()).path, 'wiring.json'));
    return result;
  }

  Future<void> _loadComponentFiles() async {
    final wiringFile = await _getWiringFile();
    if (!await wiringFile.exists()) {
      _wiring = const Wiring(instances: [], wires: []);
      await wiringFile.writeAsString(jsonEncode(_wiring));
    }
    else {
      _wiring = Wiring.fromJson(jsonDecode(await wiringFile.readAsString()));
    }
  }

  Future<void> setCurrentComponent({
    required ProjectEntry project, 
    required ComponentEntry component, 
    required Future<Tuple2<ProjectEntry, ComponentEntry>?> Function(String projectId, String componentId) onDependencyNeeded,
  }) async {
    _dependenciesMap.clear();
    _simulatedComponent = null;

    _currentProject = project;
    _currentComponent = component;

    // Load dependencies
    final unsatisfiedDependencies = <String>[];
    for (final depId in component.dependencies) {
      final splitted = depId.split('/');
      final maybeDep = await onDependencyNeeded(splitted[0], splitted[1]);
      if (maybeDep == null) {
        unsatisfiedDependencies.add(depId);
      }
      else {
        _dependenciesMap[depId] = maybeDep;
      }
    }
    if (unsatisfiedDependencies.isNotEmpty) {
      throw DependenciesNotSatisfiedException(dependencies: unsatisfiedDependencies);
    }

    return _loadComponentFiles().then((_) => notifyListeners());
  }

  void noComponent() {
    _dependenciesMap.clear();
    _currentProject = null;
    _currentComponent = null;
    _wiring = const Wiring(instances: [], wires: []);
    _simulatedComponent = null;

    notifyListeners();
  }

  Future<Map<String, bool>> simulate(Map<String, bool> inputs) async {
    Future<SimulatedComponent> onRequiredDependency(String depId) async {
      final t = _dependenciesMap[depId]!;
      final proj = t.item1;
      final comp = t.item2;
      final state = comp.visualDesigned ? ComponentState() : null;
      if (state != null) {
        await state.setCurrentComponent(
          project: proj, 
          component: comp, 
          onDependencyNeeded: (projId, compId) async => _dependenciesMap['$projId/$compId'],
        );
      }
      return SimulatedComponent(
        project: proj, 
        component: comp, 
        onRequiredDependency: onRequiredDependency,
        state: state,
      );
    }

    _simulatedComponent ??= SimulatedComponent(
      project: _currentProject!, 
      component: _currentComponent!, 
      onRequiredDependency: onRequiredDependency,
      state: this,
    );

    return _simulatedComponent!.simulate(inputs);
  }
}

class DependenciesNotSatisfiedException with Exception {
  final List<String> dependencies;

  const DependenciesNotSatisfiedException({required this.dependencies});

  @override
  String toString() {
    return 'DependenciesNotSatisfiedException(${dependencies.join(", ")})';
  }
}
