// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ProjectIndex _$$_ProjectIndexFromJson(Map<String, dynamic> json) =>
    _$_ProjectIndex(
      components: (json['components'] as List<dynamic>)
          .map((e) => ComponentEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_ProjectIndexToJson(_$_ProjectIndex instance) =>
    <String, dynamic>{
      'components': instance.components,
    };

_$_ComponentEntry _$$_ComponentEntryFromJson(Map<String, dynamic> json) =>
    _$_ComponentEntry(
      componentId: json['componentId'] as String,
      componentName: json['componentName'] as String,
      componentDescription: json['componentDescription'] as String?,
      inputs:
          (json['inputs'] as List<dynamic>).map((e) => e as String).toList(),
      outputs:
          (json['outputs'] as List<dynamic>).map((e) => e as String).toList(),
      truthTable: (json['truthTable'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      logicExpression: (json['logicExpression'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      visualDesigned: json['visualDesigned'] as bool? ?? false,
    );

Map<String, dynamic> _$$_ComponentEntryToJson(_$_ComponentEntry instance) {
  final val = <String, dynamic>{
    'componentId': instance.componentId,
    'componentName': instance.componentName,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('componentDescription', instance.componentDescription);
  val['inputs'] = instance.inputs;
  val['outputs'] = instance.outputs;
  writeNotNull('truthTable', instance.truthTable);
  writeNotNull('logicExpression', instance.logicExpression);
  val['visualDesigned'] = instance.visualDesigned;
  return val;
}
