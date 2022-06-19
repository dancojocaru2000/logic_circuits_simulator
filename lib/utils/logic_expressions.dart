import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logic_circuits_simulator/utils/iterable_extension.dart';
import 'package:logic_circuits_simulator/utils/logic_operators.dart';

part 'logic_expressions.freezed.dart';

@freezed
class LogicExpression with _$LogicExpression {
  const LogicExpression._();

  const factory LogicExpression({
    required LogicOperator operator,
    required List<dynamic> arguments,
  }) = _LogicExpression;

  factory LogicExpression.ofZeroOp(ZeroOpLogicOperator operator) => LogicExpression(operator: operator, arguments: []);

  static dynamic _classify(String token) {
    final operators = [
      FalseLogicOperator(),
      TrueLogicOperator(),
      NotLogicOperator(),
      AndLogicOperator(),
      OrLogicOperator(),
      XorLogicOperator(),
      NandLogicOperator(),
      NorLogicOperator(),
      XnorLogicOperator(),
    ];

    for (final op in operators) {
      if (op.representations.contains(token)) {
        return op;
      }
    }

    final inputStart = RegExp('^[A-Za-z]');
    if (inputStart.hasMatch(token)) {
      return token;
    }

    throw Exception('Unknown operator: $token');
  }

  static List<dynamic> _tokenize(String input) {
    final space = ' '.codeUnits[0];
    final openedParen = '('.codeUnits[0];
    final closedParen = ')'.codeUnits[0];
    final transitionToOperator = RegExp('[^A-Za-z0-9]');
    final transitionToInput = RegExp('[A-Za-z]');

    List<dynamic> result = [];
    final buffer = StringBuffer();
    bool operator = false;
    int parenDepth = 0;

    for (final rune in input.runes) {
      if (rune == openedParen) {
        if (parenDepth == 0 && buffer.isNotEmpty) {
          result.add(_classify(buffer.toString()));
          buffer.clear();
        }
        else if (parenDepth > 0) {
          buffer.writeCharCode(rune);
        }
        parenDepth++;
        continue;
      }
      else if (rune == closedParen) {
        parenDepth--;
        if (parenDepth == 0) {
          result.add(_tokenize(buffer.toString()));
          buffer.clear();
        }
        else if (parenDepth < 0) {
          throw Exception('Unmached parenthesis: too many closed parenthesis');
        }
        else {
          buffer.writeCharCode(rune);
        }
        continue;
      }
      else if (parenDepth > 0) {
        // While inside paren, just add stuff to the buffer to be further
        // processed recursively and put inside of a list.
        // ~(~(A&(A+B))+B& ~A)
        //  │ │  └───┘│      │
        //  │ └───────┘      │
        //  └────────────────┘
        buffer.writeCharCode(rune);
        continue;
      }
      else if (rune == space) {
        if (buffer.isNotEmpty) {
          result.add(_classify(buffer.toString()));
          buffer.clear();
        }
      }
      else {
        if (buffer.isNotEmpty) {
          // Check if switching from operator to input.
          // This allows an expression such as A&B to be valid.
          // Switching happens when in the middle of a token
          // and changing from [A-Za-z0-9] to [^A-Za-z0-9]
          // or from [^A-Za-z] to [A-Za-z].
          // Inputs can't start with digits.
          if (!operator && transitionToOperator.hasMatch(String.fromCharCode(rune))) {
            result.add(_classify(buffer.toString()));
            buffer.clear();
          }
          else if (operator && transitionToInput.hasMatch(String.fromCharCode(rune))) {
            result.add(_classify(buffer.toString()));
            buffer.clear();
          }
        }
        if (buffer.isEmpty) {
          operator = !transitionToInput.hasMatch(String.fromCharCode(rune));
        }
        buffer.writeCharCode(rune);
      }
    }
    if (parenDepth != 0) {
      throw Exception('Unmached parenthesis: too many open parenthesis');
    }
    if (buffer.isNotEmpty) {
      result.add(_classify(buffer.toString()));
    }
    return result;
  }

  factory LogicExpression.parse(String input) {
    final tokens = _tokenize(input);

    final result = LogicExpression._parse(tokens);
    if (result is String) {
      return LogicExpression(
        operator: OrLogicOperator(), 
        arguments: [
          result, 
          LogicExpression.ofZeroOp(FalseLogicOperator()),
        ],
      );
    }
    else {
      return result;
    }
  }

  static dynamic _parse(dynamic input) {
    if (input is List) {
      final tokens = input;

      final orderedOpGroups = [
        [OrLogicOperator(), NorLogicOperator()],
        [XorLogicOperator(), XnorLogicOperator()],
        [AndLogicOperator(), NandLogicOperator()],
        [NotLogicOperator()],
        [FalseLogicOperator(), TrueLogicOperator()],
      ];

      for (final ops in orderedOpGroups) {
        for (var i = tokens.length - 1; i >= 0; i--) {
          if (ops.contains(tokens[i])) {
            if (tokens[i] is ZeroOpLogicOperator) {
              // ZeroOp operator should be alone
              if (tokens.length != 1) {
                throw Exception('ZeroOp operator should be alone');
              }
              return LogicExpression.ofZeroOp(tokens[i]);
            }
            else if (tokens[i] is OneOpLogicOperator) {
              // OneOp operator should appear prefix only
              // So index should be 0
              if (i != 0) {
                throw Exception('OneOp operator should be prefix');
              }
              // It should only be possible to get here if there is only one argument
              // follows. The only other case is someone writing:
              // ~ A B
              // which would result in [NotLogicOperator, 'A', 'B'].
              // Such syntax is ambiguous and should not be allowed:
              // (~ A) & B -or- ~ (A & B) ?
              // This is the disadvantage of linear, left-to-right notation (as opposed
              // to the notation with a bar above the NOT-ed expression).
              if (tokens.length > 2) {
                throw Exception('Ambiguous expression: ${tokens[i]} followed by multiple tokens (${tokens.skip(1).toList()})');
              }
              else if (tokens.length == 1) {
                throw Exception('Unfinished expression');
              }
              return LogicExpression(
                operator: tokens[0],
                arguments: [_parse(tokens[1])],
              );
            }
            else if (tokens[i] is TwoOpLogicOperator) {
              return LogicExpression(
                operator: tokens[i], 
                arguments: [
                  _parse(tokens.getRange(0, i).toList()),
                  _parse(tokens.getRange(i + 1, tokens.length).toList()),
                ],
              );
            }
            else {
              throw Exception('Matched with operator that somehow isn\'t Zero/One/TwoOp');
            }
          }
        }
      }

      // No operators were found. This means the only tokens are props.
      // If there is only one prop, return it alone:
      // A => [A] => A
      // If there are multiple props, apply AND:
      // A B C => [A, B, C] => A & B & C => (A & B) & C
      // Keep in mind the second case is only possible if the props are separated by spaces,
      // as the nature of prop names allowing multiple characters only allows multiple props
      // to appear one after the other if separated by spaces.
      if (tokens.length == 1) {
        return tokens[0];
      }
      else if (tokens.isEmpty) {
        // This happens in unfinished expressions:
        // A ^ ! => XOR(A, NOT(?))
        // A ^ => XOR(A, ?)
        throw Exception('Unfinished expression');
      }
      else {
        final and = AndLogicOperator();
        return _parse(tokens.expand((token) => [and, token]).skip(1).toList());
      }
    }
    else if (input is String) {
      // Prop, just return.
      // Happens in such cases:
      // B & ~ A => & [B, ~ [A]]
      // ^             ^
      return input;
    }
    
  }

  Set<String> get inputs {
    Set<String> result = {};
    for (final arg in arguments) {
      if (arg is String) {
        result.add(arg);
      }
      else if (arg is LogicExpression) {
        result.addAll(arg.inputs);
      }
      else {
        throw Exception('Unknown argument type found: ${arg.runtimeType}');
      }
    }
    return result;
  }

  bool evaluate(Map<String, bool> inputs) {
    return operator.apply(
      arguments
        .map(
          // If the argument is a logical expression, evaluate recursively
          // else it must be an input name, so replace based on supplied mapping.
          (e) => e is LogicExpression ? e.evaluate(inputs) : inputs[e]!
        )
        .toList(),
    );
  }

  List<String> computeTruthTable(List<String> inputs) {
    final ttRows = pow(2, inputs.length) as int;
    return List.generate(
      ttRows, 
      (index) => evaluate(
        { 
          for (var element in inputs.reversed.indexedMap((index, input) => [index, input])) 
          element[1] as String : (index & (pow(2, element[0] as int) as int)) != 0 
        },
      ) ? '1' : '0',
    );
  }
}
