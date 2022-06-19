import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logic_circuits_simulator/utils/logic_expressions.dart';
import 'package:logic_circuits_simulator/utils/logic_operators.dart';

class LogicExpressionField extends HookWidget {
  final ValueListenable<List<String>> inputsListener;
  final String outputName;
  final String? initialText;
  final void Function(String input, LogicExpression expression)? onChanged;
  final void Function()? onInputError;

  const LogicExpressionField({required this.inputsListener, required this.outputName, this.initialText, this.onChanged, this.onInputError, super.key});

  @override
  Widget build(BuildContext context) {
    final inputs = useValueListenable(inputsListener);
    final controller = useTextEditingController(text: initialText);
    final errorText = useState<String?>(null);
    useValueListenable(controller);

    final onChg = useMemoized(() => (String newValue) {
      final trimmed = newValue.trim();

      try {
        if (trimmed.isEmpty) {
          onChanged?.call('', LogicExpression(operator: FalseLogicOperator(), arguments: []));
        }
        else {
          final newLogicExpression = LogicExpression.parse(trimmed);
          
          // Check if unknown inputs are used
          final newInputs = newLogicExpression.inputs;
          final unknownInputs = newInputs.where((input) => !inputs.contains(input)).toList();
          if (unknownInputs.isNotEmpty) {
            throw Exception('Unknown inputs found: ${unknownInputs.join(", ")}');
          }
          
          onChanged?.call(trimmed, newLogicExpression);
        }
        errorText.value = null;
      } catch (e) {
        errorText.value = e.toString();
        onInputError?.call();
      }
    }, [inputs, errorText]);
    useEffect(
      () {
        if (controller.text.isNotEmpty) {
          scheduleMicrotask(() {
            onChg(controller.text);
          });
        }
        return null;
      }, 
      [inputs],
    );

    return TextField(
      controller: controller,
      onChanged: onChg,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: 'Logic Experssion for $outputName',
        errorText: errorText.value,
      ),
    );
  }
}