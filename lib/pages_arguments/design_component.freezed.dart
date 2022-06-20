// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'design_component.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$DesignComponentPageArguments {
  ComponentEntry get component => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DesignComponentPageArgumentsCopyWith<DesignComponentPageArguments>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DesignComponentPageArgumentsCopyWith<$Res> {
  factory $DesignComponentPageArgumentsCopyWith(
          DesignComponentPageArguments value,
          $Res Function(DesignComponentPageArguments) then) =
      _$DesignComponentPageArgumentsCopyWithImpl<$Res>;
  $Res call({ComponentEntry component});

  $ComponentEntryCopyWith<$Res> get component;
}

/// @nodoc
class _$DesignComponentPageArgumentsCopyWithImpl<$Res>
    implements $DesignComponentPageArgumentsCopyWith<$Res> {
  _$DesignComponentPageArgumentsCopyWithImpl(this._value, this._then);

  final DesignComponentPageArguments _value;
  // ignore: unused_field
  final $Res Function(DesignComponentPageArguments) _then;

  @override
  $Res call({
    Object? component = freezed,
  }) {
    return _then(_value.copyWith(
      component: component == freezed
          ? _value.component
          : component // ignore: cast_nullable_to_non_nullable
              as ComponentEntry,
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
abstract class _$$_DesignComponentPageArgumentsCopyWith<$Res>
    implements $DesignComponentPageArgumentsCopyWith<$Res> {
  factory _$$_DesignComponentPageArgumentsCopyWith(
          _$_DesignComponentPageArguments value,
          $Res Function(_$_DesignComponentPageArguments) then) =
      __$$_DesignComponentPageArgumentsCopyWithImpl<$Res>;
  @override
  $Res call({ComponentEntry component});

  @override
  $ComponentEntryCopyWith<$Res> get component;
}

/// @nodoc
class __$$_DesignComponentPageArgumentsCopyWithImpl<$Res>
    extends _$DesignComponentPageArgumentsCopyWithImpl<$Res>
    implements _$$_DesignComponentPageArgumentsCopyWith<$Res> {
  __$$_DesignComponentPageArgumentsCopyWithImpl(
      _$_DesignComponentPageArguments _value,
      $Res Function(_$_DesignComponentPageArguments) _then)
      : super(_value, (v) => _then(v as _$_DesignComponentPageArguments));

  @override
  _$_DesignComponentPageArguments get _value =>
      super._value as _$_DesignComponentPageArguments;

  @override
  $Res call({
    Object? component = freezed,
  }) {
    return _then(_$_DesignComponentPageArguments(
      component: component == freezed
          ? _value.component
          : component // ignore: cast_nullable_to_non_nullable
              as ComponentEntry,
    ));
  }
}

/// @nodoc

class _$_DesignComponentPageArguments implements _DesignComponentPageArguments {
  const _$_DesignComponentPageArguments({required this.component});

  @override
  final ComponentEntry component;

  @override
  String toString() {
    return 'DesignComponentPageArguments(component: $component)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DesignComponentPageArguments &&
            const DeepCollectionEquality().equals(other.component, component));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(component));

  @JsonKey(ignore: true)
  @override
  _$$_DesignComponentPageArgumentsCopyWith<_$_DesignComponentPageArguments>
      get copyWith => __$$_DesignComponentPageArgumentsCopyWithImpl<
          _$_DesignComponentPageArguments>(this, _$identity);
}

abstract class _DesignComponentPageArguments
    implements DesignComponentPageArguments {
  const factory _DesignComponentPageArguments(
          {required final ComponentEntry component}) =
      _$_DesignComponentPageArguments;

  @override
  ComponentEntry get component => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_DesignComponentPageArgumentsCopyWith<_$_DesignComponentPageArguments>
      get copyWith => throw _privateConstructorUsedError;
}
