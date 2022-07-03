import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:logic_circuits_simulator/models.dart';
import 'package:logic_circuits_simulator/state/component.dart';
import 'package:logic_circuits_simulator/utils/iterable_extension.dart';
import 'package:logic_circuits_simulator/utils/logic_expressions.dart';

class SimulatedComponent {
  final ProjectEntry project;
  final ComponentEntry component;
  final ComponentState? state;
  final Future<SimulatedComponent> Function(String depId) onRequiredDependency;
  final _instances = <String, SimulatedComponent>{};

  SimulatedComponent(
      {required this.project,
      required this.component,
      required this.onRequiredDependency,
      this.state});

  Future<SimulatedComponent> _getInstance(
      String instanceId, String? depId) async {
    if (!_instances.containsKey(instanceId)) {
      if (depId != null) {
        _instances[instanceId] = await onRequiredDependency(depId);
      } else {
        throw Exception('Attempted to get instance of unknown component');
      }
    }
    return _instances[instanceId]!;
  }

  Future<Map<String, bool>> simulate(Map<String, bool> inputs) async {
    final input = int.parse(
      component.inputs.map((input) => inputs[input]! ? '1' : '0').join(),
      radix: 2,
    );
    if (component.truthTable != null) {
      final output = component.truthTable![input];
      return {
        for (final it in component.outputs
            .indexedMap((index, outName) => [outName, output[index]]))
          it[0]: it[1] == '1'
      };
    } else if (component.logicExpression != null) {
      // Somehow?
      // A truth table should be automatically generated for every logic expression component.
      // Might as well handle cases where that isn't done anyway.
      final results = component.outputs.zipWith(
        [component.logicExpression!],
        (zips) {
          final output = zips[0];
          final le = LogicExpression.parse(zips[1]);
          return [output, le.evaluate(inputs)];
        },
      );
      return {for (final it in results) it[0] as String: it[1] as bool};
    } else if (state == null) {
      throw Exception('Cannot simulate designed component without its state');
    } else {
      // Create instances
      final wiring = state!.wiring;
      for (final instance in wiring.instances) {
        await _getInstance(instance.instanceId, instance.componentId);
      }

      // Simulate
      final requiredSinks = <String>[
        ...component.outputs.map((output) => 'self/$output'),
      ];
      final knownSources = {
        for (final entry in inputs.entries) 'self/${entry.key}': entry.value
      };
      final knownSinks = <String, bool>{};

      while (requiredSinks.isNotEmpty) {
        final sink = requiredSinks.removeAt(0);
        // C-SOURCE - WIRE-OUT -> WIRE-IN - C-SINK
        if (knownSinks.containsKey(sink)) {
          // Requirement satisfied
          continue;
        } else {
          // Find wire that provides sink
          final wire = wiring.wires.where((wire) => wire.input == sink).first;
          if (knownSources.containsKey(wire.output)) {
            // If we know the output provided through the wire,
            // we know the input provided to the sink
            knownSinks[sink] = knownSources[wire.output]!;
          } else {
            // The instance providing the source for the wire has not been simulated.
            // See if all its sinks are known:
            final instanceId = wire.output.split('/')[0];
            final instance = await _getInstance(instanceId, null);
            final depSinks = instance.component.inputs
                .map((input) => '$instanceId/$input')
                .toList();
            if (depSinks
                .map((depSink) => !knownSinks.containsKey(depSink))
                .where((cond) => cond)
                .isEmpty) {
              // If so, then simulate
              final results = await instance.simulate({
                for (final depSink in depSinks)
                  depSink.split('/')[1]: knownSinks[depSink]!
              });
              knownSources.addAll({
                for (final result in results.entries)
                  '$instanceId/${result.key}': result.value
              });
              // And resolve needed sink
              knownSinks[sink] = knownSources[wire.output]!;
            } else {
              // Otherwise, require the sinks and reschedule the current one
              requiredSinks.addAll(depSinks
                  .where((depSink) => !knownSinks.containsKey(depSink)));
              requiredSinks.add(sink);
            }
          }
        }
      }

      return {
        for (final output in component.outputs)
          output: knownSinks['self/$output']!
      };
    }
  }
}

class PartialVisualSimulation with ChangeNotifier {
  final Map<String, bool?> _outputsValues = {};
  final List<String> nextToSimulate = [];
  final List<String> _alreadySimulated = [];

  UnmodifiableMapView<String, bool?> get outputsValues => UnmodifiableMapView(_outputsValues);
  UnmodifiableMapView<String, bool?> get inputsValues => UnmodifiableMapView({
    for (final entry in outputsValues.entries)
      if (entry.value != null)
        for (final wire in state.wiringDraft.wires.where((w) => w.output == entry.key))
          wire.input: entry.value
  });

  final ProjectEntry project;
  final ComponentEntry component;
  final ComponentState state;
  final Future<SimulatedComponent> Function(String depId) onRequiredDependency;
  final _instances = <String, SimulatedComponent>{};

  PartialVisualSimulation._(
      {required this.project,
      required this.component,
      required this.state,
      required this.onRequiredDependency});

  Future<SimulatedComponent> _getInstance(
      String instanceId, String? depId) async {
    if (!_instances.containsKey(instanceId)) {
      if (depId != null) {
        _instances[instanceId] = await onRequiredDependency(depId);
      } else {
        throw Exception('Attempted to get instance of unknown component');
      }
    }
    return _instances[instanceId]!;
  }

  static Future<PartialVisualSimulation> init({
    required ProjectEntry project,
    required ComponentEntry component,
    required ComponentState state,
    required Future<SimulatedComponent> Function(String depId) onRequiredDependency,
    Map<String, bool>? inputs,
  }) async {
    final sim = PartialVisualSimulation._(project: project, component: component, state: state, onRequiredDependency: onRequiredDependency);

    // Create instances
    final wiring = state.wiring;
    for (final instance in wiring.instances) {
      await sim._getInstance(instance.instanceId, instance.componentId);
    }

    // Populate inputs
    inputs ??= {};
    for (final input in component.inputs) {
      if (!inputs.containsKey(input)) {
        inputs[input] = false;
      }
    }
    await sim.provideInputs(inputs);

    return sim;
  }

  Future<void> toggleInput(String inputName) {
    final inputValue = _outputsValues['self/$inputName']!;
    return modifyInput(inputName, !inputValue);
  }

  Future<void> modifyInput(String inputName, bool newValue) {
    _outputsValues['self/$inputName'] = newValue;
    for (final key in _outputsValues.keys.toList()) {
      if (!key.startsWith('self/')) {
        _outputsValues.remove(key);
      }
    }
    _alreadySimulated.clear();
    return reset();
  }

  Future<void> provideInputs(Map<String, bool> inputs) {
    _alreadySimulated.clear();
    _outputsValues.clear();
    for (final entry in inputs.entries) {
      _outputsValues['self/${entry.key}'] = entry.value;
    }
    return reset();
  }

  Future<void> reset() async {
    nextToSimulate.clear();

    final neededToBeNext = <String, List<String>>{};

    for (final wire in state.wiringDraft.wires) {
      if (_outputsValues.containsKey(wire.output)) {
        final subcomponentId = wire.input.split('/')[0];

        // Ignore component outputs, they require no computation
        if (subcomponentId == 'self') {
          continue;
        }

        // Skip already simulated subcomponents
        if (_alreadySimulated.contains(subcomponentId)) {
          continue;
        }

        if (neededToBeNext.containsKey(subcomponentId)) {
          neededToBeNext[subcomponentId]!.remove(wire.input.split('/')[1]);
          if (neededToBeNext[subcomponentId]!.isEmpty) {
            nextToSimulate.add(subcomponentId);
          }
        }
        else {
          neededToBeNext[subcomponentId] = 
            (await _getInstance(subcomponentId, null))
            .component
            .inputs
            .whereNot((e) => e == wire.input.split('/')[1])
            .toList();
          if (neededToBeNext[subcomponentId]!.isEmpty) {
            nextToSimulate.add(subcomponentId);
          }
        }
      }
    }
    
    notifyListeners();
  }

  Future<void> nextStep() async {
    if (nextToSimulate.isEmpty) {
      return;
    }

    final currentlySimulating = nextToSimulate.toList();

    for (final subcomponentId in currentlySimulating) {
      final sim = await _getInstance(subcomponentId, null);
      final outputs = await sim.simulate({
        for (final input in sim.component.inputs)
          input: inputsValues['$subcomponentId/$input']!
      });
      for (final entry in outputs.entries) {
        _outputsValues['$subcomponentId/${entry.key}'] = entry.value;
      }
      _alreadySimulated.add(subcomponentId);
    }

    return reset();
  }
}
