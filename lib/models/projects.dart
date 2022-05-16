import 'package:freezed_annotation/freezed_annotation.dart';

part 'projects.freezed.dart';
part 'projects.g.dart';

@freezed
class ProjectsIndex with _$ProjectsIndex {
  const factory ProjectsIndex({
    required List<ProjectEntry> projects,
  }) = _ProjectsIndex;

  factory ProjectsIndex.fromJson(Map<String, Object?> json) => _$ProjectsIndexFromJson(json);
}

@freezed 
class ProjectEntry with _$ProjectEntry {
  const factory ProjectEntry({
    required DateTime lastUpdate,
    required String projectName,
    required String projectId,
  }) = _ProjectEntry;

  factory ProjectEntry.fromJson(Map<String, Object?> json) => _$ProjectEntryFromJson(json);
}