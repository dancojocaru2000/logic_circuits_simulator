import 'package:freezed_annotation/freezed_annotation.dart';

part 'design.freezed.dart';
part 'design.g.dart';

@freezed
class Design with _$Design {
  const factory Design({
    required List<DesignComponent> components,
    required List<DesignWire> wires,
    required List<DesignInput> inputs,
    required List<DesignOutput> outputs,
  }) = _Design;

  factory Design.fromJson(Map<String, dynamic> json) => _$DesignFromJson(json);
}

@freezed
class DesignComponent with _$DesignComponent {
  const factory DesignComponent({
    required String instanceId,
    required double x,
    required double y,
  }) = _DesignComponent;

  factory DesignComponent.fromJson(Map<String, dynamic> json) => _$DesignComponentFromJson(json);
}

@freezed
class DesignWire with _$DesignWire {
  const factory DesignWire({
    required String wireId,
    required double x,
    required double y,
  }) = _DesignWire;

  factory DesignWire.fromJson(Map<String, dynamic> json) => _$DesignWireFromJson(json);
}

@freezed
class DesignInput with _$DesignInput {
  const factory DesignInput({
    required String name,
    required double x,
    required double y,
  }) = _DesignInput;

  factory DesignInput.fromJson(Map<String, dynamic> json) => _$DesignInputFromJson(json);
}

@freezed
class DesignOutput with _$DesignOutput {
  const factory DesignOutput({
    required String name,
    required double x,
    required double y,
  }) = _DesignOutput;

  factory DesignOutput.fromJson(Map<String, dynamic> json) => _$DesignOutputFromJson(json);
}
