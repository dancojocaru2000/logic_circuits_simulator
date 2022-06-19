abstract class LogicOperator {
  bool apply(List<bool> inputs);
  List<String> get representations;
  String get defaultRepresentation => representations[0];
  bool fromRepresentation(String repr) => representations.contains(repr);
}

abstract class ZeroOpLogicOperator extends LogicOperator {}

class FalseLogicOperator extends ZeroOpLogicOperator {
  @override
  bool apply(List<bool> inputs) => false;

  @override
  List<String> get representations => ['0'];

  @override
  bool operator==(other) => other is FalseLogicOperator;
  
  @override
  int get hashCode => defaultRepresentation.hashCode;
}

class TrueLogicOperator extends ZeroOpLogicOperator {
  @override
  bool apply(List<bool> inputs) => true;

  @override
  List<String> get representations => ['1'];

  @override
  bool operator==(other) => other is TrueLogicOperator;
  
  @override
  int get hashCode => defaultRepresentation.hashCode;
}

abstract class OneOpLogicOperator extends LogicOperator {}

class NotLogicOperator extends OneOpLogicOperator {
  @override
  bool apply(List<bool> inputs) => !inputs[0];

  @override
  List<String> get representations => const ['~', '!', '¬'];

  @override
  bool operator==(other) => other is NotLogicOperator;
  
  @override
  int get hashCode => defaultRepresentation.hashCode;
}

abstract class TwoOpLogicOperator extends LogicOperator {}

class AndLogicOperator extends TwoOpLogicOperator {
  @override
  bool apply(List<bool> inputs) => inputs[0] && inputs[1];

  @override
  List<String> get representations => const ['&', '∧'];

  @override
  bool operator==(other) => other is AndLogicOperator;
  
  @override
  int get hashCode => defaultRepresentation.hashCode;
}

class OrLogicOperator extends TwoOpLogicOperator {
  @override
  bool apply(List<bool> inputs) => inputs[0] || inputs[1];

  @override
  List<String> get representations => const ['|', '∨'];

  @override
  bool operator==(other) => other is OrLogicOperator;
  
  @override
  int get hashCode => defaultRepresentation.hashCode;
}

class XorLogicOperator extends TwoOpLogicOperator {
  @override
  bool apply(List<bool> inputs) => inputs[0] != inputs[1];

  @override
  List<String> get representations => const ['^', '⊕', '⊻'];

  @override
  bool operator==(other) => other is XorLogicOperator;
  
  @override
  int get hashCode => defaultRepresentation.hashCode;
}

class NandLogicOperator extends TwoOpLogicOperator {
  @override
  bool apply(List<bool> inputs) => !(inputs[0] && inputs[1]);

  @override
  List<String> get representations => const ['~&', '!&', '¬&', '~∧', '!∧', '¬∧'];

  @override
  bool operator==(other) => other is NandLogicOperator;
  
  @override
  int get hashCode => defaultRepresentation.hashCode;
}

class NorLogicOperator extends TwoOpLogicOperator {
  @override
  bool apply(List<bool> inputs) => !(inputs[0] || inputs[1]);

  @override
  List<String> get representations => const ['~|', '!|', '¬|', '~∨', '!∨', '¬∨'];

  @override
  bool operator==(other) => other is NorLogicOperator;
  
  @override
  int get hashCode => defaultRepresentation.hashCode;
}

class XnorLogicOperator extends TwoOpLogicOperator {
  @override
  bool apply(List<bool> inputs) => inputs[0] == inputs[1];

  @override
  List<String> get representations => const ['~^', '!^', '¬^', '~⊕', '!⊕', '¬⊕', '~⊻', '!⊻', '¬⊻'];

  @override
  bool operator==(other) => other is XnorLogicOperator;
  
  @override
  int get hashCode => defaultRepresentation.hashCode;
}
