// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wiring.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Wiring _$$_WiringFromJson(Map<String, dynamic> json) => _$_Wiring(
      instances: (json['instances'] as List<dynamic>)
          .map((e) => WiringInstance.fromJson(e as Map<String, dynamic>))
          .toList(),
      wires: (json['wires'] as List<dynamic>)
          .map((e) => WiringWire.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_WiringToJson(_$_Wiring instance) => <String, dynamic>{
      'instances': instance.instances,
      'wires': instance.wires,
    };

_$_WiringInstance _$$_WiringInstanceFromJson(Map<String, dynamic> json) =>
    _$_WiringInstance(
      instanceId: json['instanceId'] as String,
      componentId: json['componentId'] as String,
    );

Map<String, dynamic> _$$_WiringInstanceToJson(_$_WiringInstance instance) =>
    <String, dynamic>{
      'instanceId': instance.instanceId,
      'componentId': instance.componentId,
    };

_$_WiringWire _$$_WiringWireFromJson(Map<String, dynamic> json) =>
    _$_WiringWire(
      wireId: json['wireId'] as String,
      output: json['output'] as String,
      input: json['input'] as String,
    );

Map<String, dynamic> _$$_WiringWireToJson(_$_WiringWire instance) =>
    <String, dynamic>{
      'wireId': instance.wireId,
      'output': instance.output,
      'input': instance.input,
    };
