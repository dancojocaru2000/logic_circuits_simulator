// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'edit_component.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$EditComponentPageArguments {
  ComponentEntry get component => throw _privateConstructorUsedError;
  bool get newComponent => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EditComponentPageArgumentsCopyWith<EditComponentPageArguments>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EditComponentPageArgumentsCopyWith<$Res> {
  factory $EditComponentPageArgumentsCopyWith(EditComponentPageArguments value,
          $Res Function(EditComponentPageArguments) then) =
      _$EditComponentPageArgumentsCopyWithImpl<$Res>;
  $Res call({ComponentEntry component, bool newComponent});

  $ComponentEntryCopyWith<$Res> get component;
}

/// @nodoc
class _$EditComponentPageArgumentsCopyWithImpl<$Res>
    implements $EditComponentPageArgumentsCopyWith<$Res> {
  _$EditComponentPageArgumentsCopyWithImpl(this._value, this._then);

  final EditComponentPageArguments _value;
  // ignore: unused_field
  final $Res Function(EditComponentPageArguments) _then;

  @override
  $Res call({
    Object? component = freezed,
    Object? newComponent = freezed,
  }) {
    return _then(_value.copyWith(
      component: component == freezed
          ? _value.component
          : component // ignore: cast_nullable_to_non_nullable
              as ComponentEntry,
      newComponent: newComponent == freezed
          ? _value.newComponent
          : newComponent // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  @override
  $ComponentEntryCopyWith<$Res> get component {
    return $ComponentEntryCopyWith<$Res>(_value.component, (value) {
      return _then(_value.copyWith(component: value));
    });
  }
}

/// @nodoc
abstract class _$$_EditComponentPageArgumentsCopyWith<$Res>
    implements $EditComponentPageArgumentsCopyWith<$Res> {
  factory _$$_EditComponentPageArgumentsCopyWith(
          _$_EditComponentPageArguments value,
          $Res Function(_$_EditComponentPageArguments) then) =
      __$$_EditComponentPageArgumentsCopyWithImpl<$Res>;
  @override
  $Res call({ComponentEntry component, bool newComponent});

  @override
  $ComponentEntryCopyWith<$Res> get component;
}

/// @nodoc
class __$$_EditComponentPageArgumentsCopyWithImpl<$Res>
    extends _$EditComponentPageArgumentsCopyWithImpl<$Res>
    implements _$$_EditComponentPageArgumentsCopyWith<$Res> {
  __$$_EditComponentPageArgumentsCopyWithImpl(
      _$_EditComponentPageArguments _value,
      $Res Function(_$_EditComponentPageArguments) _then)
      : super(_value, (v) => _then(v as _$_EditComponentPageArguments));

  @override
  _$_EditComponentPageArguments get _value =>
      super._value as _$_EditComponentPageArguments;

  @override
  $Res call({
    Object? component = freezed,
    Object? newComponent = freezed,
  }) {
    return _then(_$_EditComponentPageArguments(
      component: component == freezed
          ? _value.component
          : component // ignore: cast_nullable_to_non_nullable
              as ComponentEntry,
      newComponent: newComponent == freezed
          ? _value.newComponent
          : newComponent // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_EditComponentPageArguments implements _EditComponentPageArguments {
  const _$_EditComponentPageArguments(
      {required this.component, this.newComponent = false});

  @override
  final ComponentEntry component;
  @override
  @JsonKey()
  final bool newComponent;

  @override
  String toString() {
    return 'EditComponentPageArguments(component: $component, newComponent: $newComponent)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_EditComponentPageArguments &&
            const DeepCollectionEquality().equals(other.component, component) &&
            const DeepCollectionEquality()
                .equals(other.newComponent, newComponent));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(component),
      const DeepCollectionEquality().hash(newComponent));

  @JsonKey(ignore: true)
  @override
  _$$_EditComponentPageArgumentsCopyWith<_$_EditComponentPageArguments>
      get copyWith => __$$_EditComponentPageArgumentsCopyWithImpl<
          _$_EditComponentPageArguments>(this, _$identity);
}

abstract class _EditComponentPageArguments
    implements EditComponentPageArguments {
  const factory _EditComponentPageArguments(
      {required final ComponentEntry component,
      final bool newComponent}) = _$_EditComponentPageArguments;

  @override
  ComponentEntry get component => throw _privateConstructorUsedError;
  @override
  bool get newComponent => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_EditComponentPageArgumentsCopyWith<_$_EditComponentPageArguments>
      get copyWith => throw _privateConstructorUsedError;
}
