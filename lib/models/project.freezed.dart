// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'project.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ProjectIndex _$ProjectIndexFromJson(Map<String, dynamic> json) {
  return _ProjectIndex.fromJson(json);
}

/// @nodoc
mixin _$ProjectIndex {
  List<ComponentEntry> get components => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProjectIndexCopyWith<ProjectIndex> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectIndexCopyWith<$Res> {
  factory $ProjectIndexCopyWith(
          ProjectIndex value, $Res Function(ProjectIndex) then) =
      _$ProjectIndexCopyWithImpl<$Res>;
  $Res call({List<ComponentEntry> components});
}

/// @nodoc
class _$ProjectIndexCopyWithImpl<$Res> implements $ProjectIndexCopyWith<$Res> {
  _$ProjectIndexCopyWithImpl(this._value, this._then);

  final ProjectIndex _value;
  // ignore: unused_field
  final $Res Function(ProjectIndex) _then;

  @override
  $Res call({
    Object? components = freezed,
  }) {
    return _then(_value.copyWith(
      components: components == freezed
          ? _value.components
          : components // ignore: cast_nullable_to_non_nullable
              as List<ComponentEntry>,
    ));
  }
}

/// @nodoc
abstract class _$$_ProjectIndexCopyWith<$Res>
    implements $ProjectIndexCopyWith<$Res> {
  factory _$$_ProjectIndexCopyWith(
          _$_ProjectIndex value, $Res Function(_$_ProjectIndex) then) =
      __$$_ProjectIndexCopyWithImpl<$Res>;
  @override
  $Res call({List<ComponentEntry> components});
}

/// @nodoc
class __$$_ProjectIndexCopyWithImpl<$Res>
    extends _$ProjectIndexCopyWithImpl<$Res>
    implements _$$_ProjectIndexCopyWith<$Res> {
  __$$_ProjectIndexCopyWithImpl(
      _$_ProjectIndex _value, $Res Function(_$_ProjectIndex) _then)
      : super(_value, (v) => _then(v as _$_ProjectIndex));

  @override
  _$_ProjectIndex get _value => super._value as _$_ProjectIndex;

  @override
  $Res call({
    Object? components = freezed,
  }) {
    return _then(_$_ProjectIndex(
      components: components == freezed
          ? _value._components
          : components // ignore: cast_nullable_to_non_nullable
              as List<ComponentEntry>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ProjectIndex implements _ProjectIndex {
  const _$_ProjectIndex({required final List<ComponentEntry> components})
      : _components = components;

  factory _$_ProjectIndex.fromJson(Map<String, dynamic> json) =>
      _$$_ProjectIndexFromJson(json);

  final List<ComponentEntry> _components;
  @override
  List<ComponentEntry> get components {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_components);
  }

  @override
  String toString() {
    return 'ProjectIndex(components: $components)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ProjectIndex &&
            const DeepCollectionEquality()
                .equals(other._components, _components));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_components));

  @JsonKey(ignore: true)
  @override
  _$$_ProjectIndexCopyWith<_$_ProjectIndex> get copyWith =>
      __$$_ProjectIndexCopyWithImpl<_$_ProjectIndex>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ProjectIndexToJson(this);
  }
}

abstract class _ProjectIndex implements ProjectIndex {
  const factory _ProjectIndex(
      {required final List<ComponentEntry> components}) = _$_ProjectIndex;

  factory _ProjectIndex.fromJson(Map<String, dynamic> json) =
      _$_ProjectIndex.fromJson;

  @override
  List<ComponentEntry> get components => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_ProjectIndexCopyWith<_$_ProjectIndex> get copyWith =>
      throw _privateConstructorUsedError;
}

ComponentEntry _$ComponentEntryFromJson(Map<String, dynamic> json) {
  return _ComponentEntry.fromJson(json);
}

/// @nodoc
mixin _$ComponentEntry {
  String get componentId => throw _privateConstructorUsedError;
  String get componentName => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get componentDescription => throw _privateConstructorUsedError;
  List<String> get inputs => throw _privateConstructorUsedError;
  List<String> get outputs => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  List<String>? get truthTable => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  List<String>? get logicExpression => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: false)
  bool get visualDesigned => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: [])
  List<String> get dependencies => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ComponentEntryCopyWith<ComponentEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ComponentEntryCopyWith<$Res> {
  factory $ComponentEntryCopyWith(
          ComponentEntry value, $Res Function(ComponentEntry) then) =
      _$ComponentEntryCopyWithImpl<$Res>;
  $Res call(
      {String componentId,
      String componentName,
      @JsonKey(includeIfNull: false) String? componentDescription,
      List<String> inputs,
      List<String> outputs,
      @JsonKey(includeIfNull: false) List<String>? truthTable,
      @JsonKey(includeIfNull: false) List<String>? logicExpression,
      @JsonKey(defaultValue: false) bool visualDesigned,
      @JsonKey(defaultValue: []) List<String> dependencies});
}

/// @nodoc
class _$ComponentEntryCopyWithImpl<$Res>
    implements $ComponentEntryCopyWith<$Res> {
  _$ComponentEntryCopyWithImpl(this._value, this._then);

  final ComponentEntry _value;
  // ignore: unused_field
  final $Res Function(ComponentEntry) _then;

  @override
  $Res call({
    Object? componentId = freezed,
    Object? componentName = freezed,
    Object? componentDescription = freezed,
    Object? inputs = freezed,
    Object? outputs = freezed,
    Object? truthTable = freezed,
    Object? logicExpression = freezed,
    Object? visualDesigned = freezed,
    Object? dependencies = freezed,
  }) {
    return _then(_value.copyWith(
      componentId: componentId == freezed
          ? _value.componentId
          : componentId // ignore: cast_nullable_to_non_nullable
              as String,
      componentName: componentName == freezed
          ? _value.componentName
          : componentName // ignore: cast_nullable_to_non_nullable
              as String,
      componentDescription: componentDescription == freezed
          ? _value.componentDescription
          : componentDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      inputs: inputs == freezed
          ? _value.inputs
          : inputs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      outputs: outputs == freezed
          ? _value.outputs
          : outputs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      truthTable: truthTable == freezed
          ? _value.truthTable
          : truthTable // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      logicExpression: logicExpression == freezed
          ? _value.logicExpression
          : logicExpression // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      visualDesigned: visualDesigned == freezed
          ? _value.visualDesigned
          : visualDesigned // ignore: cast_nullable_to_non_nullable
              as bool,
      dependencies: dependencies == freezed
          ? _value.dependencies
          : dependencies // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
abstract class _$$_ComponentEntryCopyWith<$Res>
    implements $ComponentEntryCopyWith<$Res> {
  factory _$$_ComponentEntryCopyWith(
          _$_ComponentEntry value, $Res Function(_$_ComponentEntry) then) =
      __$$_ComponentEntryCopyWithImpl<$Res>;
  @override
  $Res call(
      {String componentId,
      String componentName,
      @JsonKey(includeIfNull: false) String? componentDescription,
      List<String> inputs,
      List<String> outputs,
      @JsonKey(includeIfNull: false) List<String>? truthTable,
      @JsonKey(includeIfNull: false) List<String>? logicExpression,
      @JsonKey(defaultValue: false) bool visualDesigned,
      @JsonKey(defaultValue: []) List<String> dependencies});
}

/// @nodoc
class __$$_ComponentEntryCopyWithImpl<$Res>
    extends _$ComponentEntryCopyWithImpl<$Res>
    implements _$$_ComponentEntryCopyWith<$Res> {
  __$$_ComponentEntryCopyWithImpl(
      _$_ComponentEntry _value, $Res Function(_$_ComponentEntry) _then)
      : super(_value, (v) => _then(v as _$_ComponentEntry));

  @override
  _$_ComponentEntry get _value => super._value as _$_ComponentEntry;

  @override
  $Res call({
    Object? componentId = freezed,
    Object? componentName = freezed,
    Object? componentDescription = freezed,
    Object? inputs = freezed,
    Object? outputs = freezed,
    Object? truthTable = freezed,
    Object? logicExpression = freezed,
    Object? visualDesigned = freezed,
    Object? dependencies = freezed,
  }) {
    return _then(_$_ComponentEntry(
      componentId: componentId == freezed
          ? _value.componentId
          : componentId // ignore: cast_nullable_to_non_nullable
              as String,
      componentName: componentName == freezed
          ? _value.componentName
          : componentName // ignore: cast_nullable_to_non_nullable
              as String,
      componentDescription: componentDescription == freezed
          ? _value.componentDescription
          : componentDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      inputs: inputs == freezed
          ? _value._inputs
          : inputs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      outputs: outputs == freezed
          ? _value._outputs
          : outputs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      truthTable: truthTable == freezed
          ? _value._truthTable
          : truthTable // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      logicExpression: logicExpression == freezed
          ? _value._logicExpression
          : logicExpression // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      visualDesigned: visualDesigned == freezed
          ? _value.visualDesigned
          : visualDesigned // ignore: cast_nullable_to_non_nullable
              as bool,
      dependencies: dependencies == freezed
          ? _value._dependencies
          : dependencies // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ComponentEntry implements _ComponentEntry {
  const _$_ComponentEntry(
      {required this.componentId,
      required this.componentName,
      @JsonKey(includeIfNull: false) this.componentDescription,
      required final List<String> inputs,
      required final List<String> outputs,
      @JsonKey(includeIfNull: false) final List<String>? truthTable,
      @JsonKey(includeIfNull: false) final List<String>? logicExpression,
      @JsonKey(defaultValue: false) required this.visualDesigned,
      @JsonKey(defaultValue: []) required final List<String> dependencies})
      : _inputs = inputs,
        _outputs = outputs,
        _truthTable = truthTable,
        _logicExpression = logicExpression,
        _dependencies = dependencies;

  factory _$_ComponentEntry.fromJson(Map<String, dynamic> json) =>
      _$$_ComponentEntryFromJson(json);

  @override
  final String componentId;
  @override
  final String componentName;
  @override
  @JsonKey(includeIfNull: false)
  final String? componentDescription;
  final List<String> _inputs;
  @override
  List<String> get inputs {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_inputs);
  }

  final List<String> _outputs;
  @override
  List<String> get outputs {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_outputs);
  }

  final List<String>? _truthTable;
  @override
  @JsonKey(includeIfNull: false)
  List<String>? get truthTable {
    final value = _truthTable;
    if (value == null) return null;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _logicExpression;
  @override
  @JsonKey(includeIfNull: false)
  List<String>? get logicExpression {
    final value = _logicExpression;
    if (value == null) return null;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(defaultValue: false)
  final bool visualDesigned;
  final List<String> _dependencies;
  @override
  @JsonKey(defaultValue: [])
  List<String> get dependencies {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dependencies);
  }

  @override
  String toString() {
    return 'ComponentEntry(componentId: $componentId, componentName: $componentName, componentDescription: $componentDescription, inputs: $inputs, outputs: $outputs, truthTable: $truthTable, logicExpression: $logicExpression, visualDesigned: $visualDesigned, dependencies: $dependencies)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ComponentEntry &&
            const DeepCollectionEquality()
                .equals(other.componentId, componentId) &&
            const DeepCollectionEquality()
                .equals(other.componentName, componentName) &&
            const DeepCollectionEquality()
                .equals(other.componentDescription, componentDescription) &&
            const DeepCollectionEquality().equals(other._inputs, _inputs) &&
            const DeepCollectionEquality().equals(other._outputs, _outputs) &&
            const DeepCollectionEquality()
                .equals(other._truthTable, _truthTable) &&
            const DeepCollectionEquality()
                .equals(other._logicExpression, _logicExpression) &&
            const DeepCollectionEquality()
                .equals(other.visualDesigned, visualDesigned) &&
            const DeepCollectionEquality()
                .equals(other._dependencies, _dependencies));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(componentId),
      const DeepCollectionEquality().hash(componentName),
      const DeepCollectionEquality().hash(componentDescription),
      const DeepCollectionEquality().hash(_inputs),
      const DeepCollectionEquality().hash(_outputs),
      const DeepCollectionEquality().hash(_truthTable),
      const DeepCollectionEquality().hash(_logicExpression),
      const DeepCollectionEquality().hash(visualDesigned),
      const DeepCollectionEquality().hash(_dependencies));

  @JsonKey(ignore: true)
  @override
  _$$_ComponentEntryCopyWith<_$_ComponentEntry> get copyWith =>
      __$$_ComponentEntryCopyWithImpl<_$_ComponentEntry>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ComponentEntryToJson(this);
  }
}

abstract class _ComponentEntry implements ComponentEntry {
  const factory _ComponentEntry(
      {required final String componentId,
      required final String componentName,
      @JsonKey(includeIfNull: false)
          final String? componentDescription,
      required final List<String> inputs,
      required final List<String> outputs,
      @JsonKey(includeIfNull: false)
          final List<String>? truthTable,
      @JsonKey(includeIfNull: false)
          final List<String>? logicExpression,
      @JsonKey(defaultValue: false)
          required final bool visualDesigned,
      @JsonKey(defaultValue: [])
          required final List<String> dependencies}) = _$_ComponentEntry;

  factory _ComponentEntry.fromJson(Map<String, dynamic> json) =
      _$_ComponentEntry.fromJson;

  @override
  String get componentId => throw _privateConstructorUsedError;
  @override
  String get componentName => throw _privateConstructorUsedError;
  @override
  @JsonKey(includeIfNull: false)
  String? get componentDescription => throw _privateConstructorUsedError;
  @override
  List<String> get inputs => throw _privateConstructorUsedError;
  @override
  List<String> get outputs => throw _privateConstructorUsedError;
  @override
  @JsonKey(includeIfNull: false)
  List<String>? get truthTable => throw _privateConstructorUsedError;
  @override
  @JsonKey(includeIfNull: false)
  List<String>? get logicExpression => throw _privateConstructorUsedError;
  @override
  @JsonKey(defaultValue: false)
  bool get visualDesigned => throw _privateConstructorUsedError;
  @override
  @JsonKey(defaultValue: [])
  List<String> get dependencies => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_ComponentEntryCopyWith<_$_ComponentEntry> get copyWith =>
      throw _privateConstructorUsedError;
}
