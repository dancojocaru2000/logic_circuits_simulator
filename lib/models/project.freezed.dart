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
