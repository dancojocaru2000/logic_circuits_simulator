// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'design.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Design _$$_DesignFromJson(Map<String, dynamic> json) => _$_Design(
      components: (json['components'] as List<dynamic>)
          .map((e) => DesignComponent.fromJson(e as Map<String, dynamic>))
          .toList(),
      wires: (json['wires'] as List<dynamic>)
          .map((e) => DesignWire.fromJson(e as Map<String, dynamic>))
          .toList(),
      inputs: (json['inputs'] as List<dynamic>)
          .map((e) => DesignInput.fromJson(e as Map<String, dynamic>))
          .toList(),
      outputs: (json['outputs'] as List<dynamic>)
          .map((e) => DesignOutput.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_DesignToJson(_$_Design instance) => <String, dynamic>{
      'components': instance.components,
      'wires': instance.wires,
      'inputs': instance.inputs,
      'outputs': instance.outputs,
    };

_$_DesignComponent _$$_DesignComponentFromJson(Map<String, dynamic> json) =>
    _$_DesignComponent(
      instanceId: json['instanceId'] as String,
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
    );

Map<String, dynamic> _$$_DesignComponentToJson(_$_DesignComponent instance) =>
    <String, dynamic>{
      'instanceId': instance.instanceId,
      'x': instance.x,
      'y': instance.y,
    };

_$_DesignWire _$$_DesignWireFromJson(Map<String, dynamic> json) =>
    _$_DesignWire(
      wireId: json['wireId'] as String,
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
    );

Map<String, dynamic> _$$_DesignWireToJson(_$_DesignWire instance) =>
    <String, dynamic>{
      'wireId': instance.wireId,
      'x': instance.x,
      'y': instance.y,
    };

_$_DesignInput _$$_DesignInputFromJson(Map<String, dynamic> json) =>
    _$_DesignInput(
      name: json['name'] as String,
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
    );

Map<String, dynamic> _$$_DesignInputToJson(_$_DesignInput instance) =>
    <String, dynamic>{
      'name': instance.name,
      'x': instance.x,
      'y': instance.y,
    };

_$_DesignOutput _$$_DesignOutputFromJson(Map<String, dynamic> json) =>
    _$_DesignOutput(
      name: json['name'] as String,
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
    );

Map<String, dynamic> _$$_DesignOutputToJson(_$_DesignOutput instance) =>
    <String, dynamic>{
      'name': instance.name,
      'x': instance.x,
      'y': instance.y,
    };
