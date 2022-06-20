import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logic_circuits_simulator/models.dart';

part 'project.freezed.dart';
part 'project.g.dart';

@freezed
class ProjectIndex with _$ProjectIndex {
  const factory ProjectIndex({
    required List<ComponentEntry> components,
  }) = _ProjectIndex;

  factory ProjectIndex.fromJson(Map<String, Object?> json) => _$ProjectIndexFromJson(json);
}
