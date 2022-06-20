// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'component.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
      dependencies: (json['dependencies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
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
  val['dependencies'] = instance.dependencies;
  return val;
}
