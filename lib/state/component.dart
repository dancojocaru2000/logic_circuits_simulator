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
  Wiring? _wiringDraft;
  Design _design = const Design(components: [], wires: [], inputs: [], outputs: []);
  Design? _designDraft;
  SimulatedComponent? _simulatedComponent;
  PartialVisualSimulation? _partialVisualSimulation;

  final Map<String, Tuple2<ProjectEntry, ComponentEntry>> _dependenciesMap = {};

  ProjectEntry? get currentProject => _currentProject;
  ComponentEntry? get currentComponent => _currentComponent;
  Wiring get wiring => _wiring;
  Wiring get wiringDraft => _wiringDraft ?? _wiring;
  Design get design => _design;
  Design get designDraft => _designDraft ?? _design;
  PartialVisualSimulation? get partialVisualSimulation => _partialVisualSimulation;

  Future<SimulatedComponent> _onRequiredDependency(String depId) async {
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
      onRequiredDependency: _onRequiredDependency,
      state: state,
    );
  }

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

  Future<File> _getDesignFile() async {
    final result = File(path.join((await _getComponentDir()).path, 'design.json'));
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
    _wiringDraft = null;

    final designFile = await _getDesignFile();
    if (!await designFile.exists()) {
      _design = const Design(components: [], wires: [], inputs: [], outputs: []);
      await designFile.writeAsString(jsonEncode(_design));
    }
    else {
      _design = Design.fromJson(jsonDecode(await designFile.readAsString()));
    }
    _designDraft = null;
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

    await _loadComponentFiles();

    if (component.visualDesigned) {
      _partialVisualSimulation = await PartialVisualSimulation.init(
        project: project,
        component: component,
        state: this,
        onRequiredDependency: _onRequiredDependency,
      );
    }

    notifyListeners();
  }

  void noComponent() {
    _dependenciesMap.clear();
    _currentProject = null;
    _currentComponent = null;
    _wiring = const Wiring(instances: [], wires: []);
    _design = const Design(components: [], wires: [], inputs: [], outputs: []);
    _wiringDraft = _designDraft = null;
    _simulatedComponent = null;
    _partialVisualSimulation = null;

    notifyListeners();
  }

  Tuple2<ProjectEntry, ComponentEntry> getMetaByInstance(String instanceId) {
    for (final instance in wiring.instances) {
      if (instance.instanceId == instanceId) {
        return _dependenciesMap[instance.componentId]!;
      }
    }

    throw Exception('Instance $instanceId not found in the dependencies map');
  }

  Future<Map<String, bool>> simulate(Map<String, bool> inputs) async {

    _simulatedComponent ??= SimulatedComponent(
      project: _currentProject!, 
      component: _currentComponent!, 
      onRequiredDependency: _onRequiredDependency,
      state: this,
    );

    return _simulatedComponent!.simulate(inputs);
  }

  Future<Design> updateDesign(Design newDesign, {bool commit = true}) async {
    if (commit) {
      _design = newDesign;
      _designDraft = null;
      final designFile = await _getDesignFile();
      await designFile.writeAsString(jsonEncode(newDesign));
    }
    else {
      _designDraft = newDesign;
    }
    notifyListeners();
    return designDraft;
  }

  Future<Wiring> updateWiring(Wiring newWiring, {bool commit = true}) async {
    if (commit) {
      _wiring = newWiring;
      _wiringDraft = null;
      final wiringFile = await _getWiringFile();
      await wiringFile.writeAsString(jsonEncode(newWiring));
    }
    else {
      _wiringDraft = newWiring;
    }
    notifyListeners();
    return wiringDraft;
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
