import 'package:freezed_annotation/freezed_annotation.dart';

part 'component.freezed.dart';
part 'component.g.dart';

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
    List<String>? logicExpression,
    @JsonKey(defaultValue: false)
    required bool visualDesigned,
    @JsonKey(defaultValue: [])
    required List<String> dependencies,
    @JsonKey(defaultValue: false)
    required bool scriptBased,
  }) = _ComponentEntry;

  factory ComponentEntry.fromJson(Map<String, Object?> json) => _$ComponentEntryFromJson(json);
}
