import 'package:freezed_annotation/freezed_annotation.dart';

part 'project.freezed.dart';
part 'project.g.dart';

@freezed
class ProjectIndex with _$ProjectIndex {
  const factory ProjectIndex({
    required List<ComponentEntry> components,
  }) = _ProjectIndex;

  factory ProjectIndex.fromJson(Map<String, Object?> json) => _$ProjectIndexFromJson(json);
}

@freezed
class ComponentEntry with _$ComponentEntry {
  const factory ComponentEntry({
    required String componentId,
    required String componentName,
    @JsonKey(includeIfNull: false)
    String? componentDescription,
    required List<String> inputs,
    required List<String> outputs,
    @JsonKey(includeIfNull: false)
    List<String>? truthTable,
    @JsonKey(includeIfNull: false)
    String? logicExpression,
  }) = _ComponentEntry;

  factory ComponentEntry.fromJson(Map<String, Object?> json) => _$ComponentEntryFromJson(json);
}
