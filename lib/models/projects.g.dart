// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projects.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ProjectsIndex _$$_ProjectsIndexFromJson(Map<String, dynamic> json) =>
    _$_ProjectsIndex(
      projects: (json['projects'] as List<dynamic>)
          .map((e) => ProjectEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_ProjectsIndexToJson(_$_ProjectsIndex instance) =>
    <String, dynamic>{
      'projects': instance.projects,
    };

_$_ProjectEntry _$$_ProjectEntryFromJson(Map<String, dynamic> json) =>
    _$_ProjectEntry(
      lastUpdate: DateTime.parse(json['lastUpdate'] as String),
      projectName: json['projectName'] as String,
      projectId: json['projectId'] as String,
    );

Map<String, dynamic> _$$_ProjectEntryToJson(_$_ProjectEntry instance) =>
    <String, dynamic>{
      'lastUpdate': instance.lastUpdate.toIso8601String(),
      'projectName': instance.projectName,
      'projectId': instance.projectId,
    };
