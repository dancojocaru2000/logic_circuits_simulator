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
