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

  SimulatedComponent({
    required this.project, 
    required this.component, 
    required this.onRequiredDependency,
    this.state
  });

  Future<SimulatedComponent> _getInstance(String instanceId, String? depId) async {
    if (!_instances.containsKey(instanceId)) {
      if (depId != null) {
        _instances[instanceId] = await onRequiredDependency(depId);
      }
      else {
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
        for (final it in component.outputs.indexedMap(
          (index, outName) => [outName, output[index]]
        )) 
        it[0] : it[1] == '1'
      };
    }
    else if (component.logicExpression != null) {
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
      return {
        for (final it in results)
        it[0] as String : it[1] as bool
      };
    }
    else if (state == null) {
      throw Exception('Cannot simulate designed component without its state');
    }
    else {
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
        for (final entry in inputs.entries)
        'self/${entry.key}': entry.value
      };
      final knownSinks = <String, bool>{};

      while (requiredSinks.isNotEmpty) {
        final sink = requiredSinks.removeAt(0);
        // C-SOURCE - WIRE-OUT -> WIRE-IN - C-SINK
        if (knownSinks.containsKey(sink)) {
          // Requirement satisfied
          continue;
        }
        else {
          // Find wire that provides sink
          final wire = wiring.wires.where((wire) => wire.input == sink).first;
          if (knownSources.containsKey(wire.output)) {
            // If we know the output provided through the wire, 
            // we know the input provided to the sink
            knownSinks[sink] = knownSources[wire.output]!;
          }
          else {
            // The instance providing the source for the wire has not been simulated.
            // See if all its sinks are known:
            final instanceId = wire.output.split('/')[0];
            final instance = await _getInstance(instanceId, null);
            final depSinks = instance.component.inputs.map((input) => '$instanceId/$input').toList();
            if (depSinks.map((depSink) => !knownSinks.containsKey(depSink)).where((cond) => cond).isEmpty) {
              // If so, then simulate
              final results = await instance.simulate({
                for (final depSink in depSinks)
                depSink.split('/')[1] : knownSinks[depSink]!
              });
              knownSources.addAll({
                for (final result in results.entries)
                '$instanceId/${result.key}' : result.value
              });
              // And resolve needed sink
              knownSinks[sink] = knownSources[wire.output]!;
            }
            else {
              // Otherwise, require the sinks and reschedule the current one
              requiredSinks.addAll(depSinks.where((depSink) => !knownSinks.containsKey(depSink)));
              requiredSinks.add(sink);
            }
          }
        }
      }

      return {
        for (final output in component.outputs)
        output : knownSinks['self/$output']!
      };
    }
  }
}