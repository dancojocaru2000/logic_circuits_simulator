import 'package:freezed_annotation/freezed_annotation.dart';

part 'wiring.freezed.dart';
part 'wiring.g.dart';

@freezed
class Wiring with _$Wiring {
  const factory Wiring({
    required List<WiringInstance> instances,
    required List<WiringWire> wires,
  }) = _Wiring;

  factory Wiring.fromJson(Map<String, dynamic> json) => _$WiringFromJson(json);
}

@freezed 
class WiringInstance with _$WiringInstance {
  const factory WiringInstance({
    required String instanceId,
    required String componentId,
  }) = _WiringInstance;

  factory WiringInstance.fromJson(Map<String, dynamic> json) => _$WiringInstanceFromJson(json);
}

@freezed
class WiringWire with _$WiringWire {
  const factory WiringWire({
    required String wireId,
    required String output,
    required String input,
  }) = _WiringWire;

  factory WiringWire.fromJson(Map<String, dynamic> json) => _$WiringWireFromJson(json);
}
