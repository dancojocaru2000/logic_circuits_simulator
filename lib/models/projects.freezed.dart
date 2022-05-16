// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'projects.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ProjectsIndex _$ProjectsIndexFromJson(Map<String, dynamic> json) {
  return _ProjectsIndex.fromJson(json);
}

/// @nodoc
mixin _$ProjectsIndex {
  List<ProjectEntry> get projects => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProjectsIndexCopyWith<ProjectsIndex> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectsIndexCopyWith<$Res> {
  factory $ProjectsIndexCopyWith(
          ProjectsIndex value, $Res Function(ProjectsIndex) then) =
      _$ProjectsIndexCopyWithImpl<$Res>;
  $Res call({List<ProjectEntry> projects});
}

/// @nodoc
class _$ProjectsIndexCopyWithImpl<$Res>
    implements $ProjectsIndexCopyWith<$Res> {
  _$ProjectsIndexCopyWithImpl(this._value, this._then);

  final ProjectsIndex _value;
  // ignore: unused_field
  final $Res Function(ProjectsIndex) _then;

  @override
  $Res call({
    Object? projects = freezed,
  }) {
    return _then(_value.copyWith(
      projects: projects == freezed
          ? _value.projects
          : projects // ignore: cast_nullable_to_non_nullable
              as List<ProjectEntry>,
    ));
  }
}

/// @nodoc
abstract class _$$_ProjectsIndexCopyWith<$Res>
    implements $ProjectsIndexCopyWith<$Res> {
  factory _$$_ProjectsIndexCopyWith(
          _$_ProjectsIndex value, $Res Function(_$_ProjectsIndex) then) =
      __$$_ProjectsIndexCopyWithImpl<$Res>;
  @override
  $Res call({List<ProjectEntry> projects});
}

/// @nodoc
class __$$_ProjectsIndexCopyWithImpl<$Res>
    extends _$ProjectsIndexCopyWithImpl<$Res>
    implements _$$_ProjectsIndexCopyWith<$Res> {
  __$$_ProjectsIndexCopyWithImpl(
      _$_ProjectsIndex _value, $Res Function(_$_ProjectsIndex) _then)
      : super(_value, (v) => _then(v as _$_ProjectsIndex));

  @override
  _$_ProjectsIndex get _value => super._value as _$_ProjectsIndex;

  @override
  $Res call({
    Object? projects = freezed,
  }) {
    return _then(_$_ProjectsIndex(
      projects: projects == freezed
          ? _value._projects
          : projects // ignore: cast_nullable_to_non_nullable
              as List<ProjectEntry>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ProjectsIndex implements _ProjectsIndex {
  const _$_ProjectsIndex({required final List<ProjectEntry> projects})
      : _projects = projects;

  factory _$_ProjectsIndex.fromJson(Map<String, dynamic> json) =>
      _$$_ProjectsIndexFromJson(json);

  final List<ProjectEntry> _projects;
  @override
  List<ProjectEntry> get projects {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_projects);
  }

  @override
  String toString() {
    return 'ProjectsIndex(projects: $projects)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ProjectsIndex &&
            const DeepCollectionEquality().equals(other._projects, _projects));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_projects));

  @JsonKey(ignore: true)
  @override
  _$$_ProjectsIndexCopyWith<_$_ProjectsIndex> get copyWith =>
      __$$_ProjectsIndexCopyWithImpl<_$_ProjectsIndex>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ProjectsIndexToJson(this);
  }
}

abstract class _ProjectsIndex implements ProjectsIndex {
  const factory _ProjectsIndex({required final List<ProjectEntry> projects}) =
      _$_ProjectsIndex;

  factory _ProjectsIndex.fromJson(Map<String, dynamic> json) =
      _$_ProjectsIndex.fromJson;

  @override
  List<ProjectEntry> get projects => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_ProjectsIndexCopyWith<_$_ProjectsIndex> get copyWith =>
      throw _privateConstructorUsedError;
}

ProjectEntry _$ProjectEntryFromJson(Map<String, dynamic> json) {
  return _ProjectEntry.fromJson(json);
}

/// @nodoc
mixin _$ProjectEntry {
  DateTime get lastUpdate => throw _privateConstructorUsedError;
  String get projectName => throw _privateConstructorUsedError;
  String get projectId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProjectEntryCopyWith<ProjectEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectEntryCopyWith<$Res> {
  factory $ProjectEntryCopyWith(
          ProjectEntry value, $Res Function(ProjectEntry) then) =
      _$ProjectEntryCopyWithImpl<$Res>;
  $Res call({DateTime lastUpdate, String projectName, String projectId});
}

/// @nodoc
class _$ProjectEntryCopyWithImpl<$Res> implements $ProjectEntryCopyWith<$Res> {
  _$ProjectEntryCopyWithImpl(this._value, this._then);

  final ProjectEntry _value;
  // ignore: unused_field
  final $Res Function(ProjectEntry) _then;

  @override
  $Res call({
    Object? lastUpdate = freezed,
    Object? projectName = freezed,
    Object? projectId = freezed,
  }) {
    return _then(_value.copyWith(
      lastUpdate: lastUpdate == freezed
          ? _value.lastUpdate
          : lastUpdate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      projectName: projectName == freezed
          ? _value.projectName
          : projectName // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: projectId == freezed
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_ProjectEntryCopyWith<$Res>
    implements $ProjectEntryCopyWith<$Res> {
  factory _$$_ProjectEntryCopyWith(
          _$_ProjectEntry value, $Res Function(_$_ProjectEntry) then) =
      __$$_ProjectEntryCopyWithImpl<$Res>;
  @override
  $Res call({DateTime lastUpdate, String projectName, String projectId});
}

/// @nodoc
class __$$_ProjectEntryCopyWithImpl<$Res>
    extends _$ProjectEntryCopyWithImpl<$Res>
    implements _$$_ProjectEntryCopyWith<$Res> {
  __$$_ProjectEntryCopyWithImpl(
      _$_ProjectEntry _value, $Res Function(_$_ProjectEntry) _then)
      : super(_value, (v) => _then(v as _$_ProjectEntry));

  @override
  _$_ProjectEntry get _value => super._value as _$_ProjectEntry;

  @override
  $Res call({
    Object? lastUpdate = freezed,
    Object? projectName = freezed,
    Object? projectId = freezed,
  }) {
    return _then(_$_ProjectEntry(
      lastUpdate: lastUpdate == freezed
          ? _value.lastUpdate
          : lastUpdate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      projectName: projectName == freezed
          ? _value.projectName
          : projectName // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: projectId == freezed
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ProjectEntry implements _ProjectEntry {
  const _$_ProjectEntry(
      {required this.lastUpdate,
      required this.projectName,
      required this.projectId});

  factory _$_ProjectEntry.fromJson(Map<String, dynamic> json) =>
      _$$_ProjectEntryFromJson(json);

  @override
  final DateTime lastUpdate;
  @override
  final String projectName;
  @override
  final String projectId;

  @override
  String toString() {
    return 'ProjectEntry(lastUpdate: $lastUpdate, projectName: $projectName, projectId: $projectId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ProjectEntry &&
            const DeepCollectionEquality()
                .equals(other.lastUpdate, lastUpdate) &&
            const DeepCollectionEquality()
                .equals(other.projectName, projectName) &&
            const DeepCollectionEquality().equals(other.projectId, projectId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(lastUpdate),
      const DeepCollectionEquality().hash(projectName),
      const DeepCollectionEquality().hash(projectId));

  @JsonKey(ignore: true)
  @override
  _$$_ProjectEntryCopyWith<_$_ProjectEntry> get copyWith =>
      __$$_ProjectEntryCopyWithImpl<_$_ProjectEntry>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ProjectEntryToJson(this);
  }
}

abstract class _ProjectEntry implements ProjectEntry {
  const factory _ProjectEntry(
      {required final DateTime lastUpdate,
      required final String projectName,
      required final String projectId}) = _$_ProjectEntry;

  factory _ProjectEntry.fromJson(Map<String, dynamic> json) =
      _$_ProjectEntry.fromJson;

  @override
  DateTime get lastUpdate => throw _privateConstructorUsedError;
  @override
  String get projectName => throw _privateConstructorUsedError;
  @override
  String get projectId => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_ProjectEntryCopyWith<_$_ProjectEntry> get copyWith =>
      throw _privateConstructorUsedError;
}
