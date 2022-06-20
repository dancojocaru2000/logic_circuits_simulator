// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'wiring.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Wiring _$WiringFromJson(Map<String, dynamic> json) {
  return _Wiring.fromJson(json);
}

/// @nodoc
mixin _$Wiring {
  List<WiringInstance> get instances => throw _privateConstructorUsedError;
  List<WiringWire> get wires => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WiringCopyWith<Wiring> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WiringCopyWith<$Res> {
  factory $WiringCopyWith(Wiring value, $Res Function(Wiring) then) =
      _$WiringCopyWithImpl<$Res>;
  $Res call({List<WiringInstance> instances, List<WiringWire> wires});
}

/// @nodoc
class _$WiringCopyWithImpl<$Res> implements $WiringCopyWith<$Res> {
  _$WiringCopyWithImpl(this._value, this._then);

  final Wiring _value;
  // ignore: unused_field
  final $Res Function(Wiring) _then;

  @override
  $Res call({
    Object? instances = freezed,
    Object? wires = freezed,
  }) {
    return _then(_value.copyWith(
      instances: instances == freezed
          ? _value.instances
          : instances // ignore: cast_nullable_to_non_nullable
              as List<WiringInstance>,
      wires: wires == freezed
          ? _value.wires
          : wires // ignore: cast_nullable_to_non_nullable
              as List<WiringWire>,
    ));
  }
}

/// @nodoc
abstract class _$$_WiringCopyWith<$Res> implements $WiringCopyWith<$Res> {
  factory _$$_WiringCopyWith(_$_Wiring value, $Res Function(_$_Wiring) then) =
      __$$_WiringCopyWithImpl<$Res>;
  @override
  $Res call({List<WiringInstance> instances, List<WiringWire> wires});
}

/// @nodoc
class __$$_WiringCopyWithImpl<$Res> extends _$WiringCopyWithImpl<$Res>
    implements _$$_WiringCopyWith<$Res> {
  __$$_WiringCopyWithImpl(_$_Wiring _value, $Res Function(_$_Wiring) _then)
      : super(_value, (v) => _then(v as _$_Wiring));

  @override
  _$_Wiring get _value => super._value as _$_Wiring;

  @override
  $Res call({
    Object? instances = freezed,
    Object? wires = freezed,
  }) {
    return _then(_$_Wiring(
      instances: instances == freezed
          ? _value._instances
          : instances // ignore: cast_nullable_to_non_nullable
              as List<WiringInstance>,
      wires: wires == freezed
          ? _value._wires
          : wires // ignore: cast_nullable_to_non_nullable
              as List<WiringWire>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Wiring implements _Wiring {
  const _$_Wiring(
      {required final List<WiringInstance> instances,
      required final List<WiringWire> wires})
      : _instances = instances,
        _wires = wires;

  factory _$_Wiring.fromJson(Map<String, dynamic> json) =>
      _$$_WiringFromJson(json);

  final List<WiringInstance> _instances;
  @override
  List<WiringInstance> get instances {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_instances);
  }

  final List<WiringWire> _wires;
  @override
  List<WiringWire> get wires {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_wires);
  }

  @override
  String toString() {
    return 'Wiring(instances: $instances, wires: $wires)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Wiring &&
            const DeepCollectionEquality()
                .equals(other._instances, _instances) &&
            const DeepCollectionEquality().equals(other._wires, _wires));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_instances),
      const DeepCollectionEquality().hash(_wires));

  @JsonKey(ignore: true)
  @override
  _$$_WiringCopyWith<_$_Wiring> get copyWith =>
      __$$_WiringCopyWithImpl<_$_Wiring>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_WiringToJson(this);
  }
}

abstract class _Wiring implements Wiring {
  const factory _Wiring(
      {required final List<WiringInstance> instances,
      required final List<WiringWire> wires}) = _$_Wiring;

  factory _Wiring.fromJson(Map<String, dynamic> json) = _$_Wiring.fromJson;

  @override
  List<WiringInstance> get instances => throw _privateConstructorUsedError;
  @override
  List<WiringWire> get wires => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_WiringCopyWith<_$_Wiring> get copyWith =>
      throw _privateConstructorUsedError;
}

WiringInstance _$WiringInstanceFromJson(Map<String, dynamic> json) {
  return _WiringInstance.fromJson(json);
}

/// @nodoc
mixin _$WiringInstance {
  String get instanceId => throw _privateConstructorUsedError;
  String get componentId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WiringInstanceCopyWith<WiringInstance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WiringInstanceCopyWith<$Res> {
  factory $WiringInstanceCopyWith(
          WiringInstance value, $Res Function(WiringInstance) then) =
      _$WiringInstanceCopyWithImpl<$Res>;
  $Res call({String instanceId, String componentId});
}

/// @nodoc
class _$WiringInstanceCopyWithImpl<$Res>
    implements $WiringInstanceCopyWith<$Res> {
  _$WiringInstanceCopyWithImpl(this._value, this._then);

  final WiringInstance _value;
  // ignore: unused_field
  final $Res Function(WiringInstance) _then;

  @override
  $Res call({
    Object? instanceId = freezed,
    Object? componentId = freezed,
  }) {
    return _then(_value.copyWith(
      instanceId: instanceId == freezed
          ? _value.instanceId
          : instanceId // ignore: cast_nullable_to_non_nullable
              as String,
      componentId: componentId == freezed
          ? _value.componentId
          : componentId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_WiringInstanceCopyWith<$Res>
    implements $WiringInstanceCopyWith<$Res> {
  factory _$$_WiringInstanceCopyWith(
          _$_WiringInstance value, $Res Function(_$_WiringInstance) then) =
      __$$_WiringInstanceCopyWithImpl<$Res>;
  @override
  $Res call({String instanceId, String componentId});
}

/// @nodoc
class __$$_WiringInstanceCopyWithImpl<$Res>
    extends _$WiringInstanceCopyWithImpl<$Res>
    implements _$$_WiringInstanceCopyWith<$Res> {
  __$$_WiringInstanceCopyWithImpl(
      _$_WiringInstance _value, $Res Function(_$_WiringInstance) _then)
      : super(_value, (v) => _then(v as _$_WiringInstance));

  @override
  _$_WiringInstance get _value => super._value as _$_WiringInstance;

  @override
  $Res call({
    Object? instanceId = freezed,
    Object? componentId = freezed,
  }) {
    return _then(_$_WiringInstance(
      instanceId: instanceId == freezed
          ? _value.instanceId
          : instanceId // ignore: cast_nullable_to_non_nullable
              as String,
      componentId: componentId == freezed
          ? _value.componentId
          : componentId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_WiringInstance implements _WiringInstance {
  const _$_WiringInstance(
      {required this.instanceId, required this.componentId});

  factory _$_WiringInstance.fromJson(Map<String, dynamic> json) =>
      _$$_WiringInstanceFromJson(json);

  @override
  final String instanceId;
  @override
  final String componentId;

  @override
  String toString() {
    return 'WiringInstance(instanceId: $instanceId, componentId: $componentId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_WiringInstance &&
            const DeepCollectionEquality()
                .equals(other.instanceId, instanceId) &&
            const DeepCollectionEquality()
                .equals(other.componentId, componentId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(instanceId),
      const DeepCollectionEquality().hash(componentId));

  @JsonKey(ignore: true)
  @override
  _$$_WiringInstanceCopyWith<_$_WiringInstance> get copyWith =>
      __$$_WiringInstanceCopyWithImpl<_$_WiringInstance>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_WiringInstanceToJson(this);
  }
}

abstract class _WiringInstance implements WiringInstance {
  const factory _WiringInstance(
      {required final String instanceId,
      required final String componentId}) = _$_WiringInstance;

  factory _WiringInstance.fromJson(Map<String, dynamic> json) =
      _$_WiringInstance.fromJson;

  @override
  String get instanceId => throw _privateConstructorUsedError;
  @override
  String get componentId => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_WiringInstanceCopyWith<_$_WiringInstance> get copyWith =>
      throw _privateConstructorUsedError;
}

WiringWire _$WiringWireFromJson(Map<String, dynamic> json) {
  return _WiringWire.fromJson(json);
}

/// @nodoc
mixin _$WiringWire {
  String get wireId => throw _privateConstructorUsedError;
  String get output => throw _privateConstructorUsedError;
  String get input => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WiringWireCopyWith<WiringWire> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WiringWireCopyWith<$Res> {
  factory $WiringWireCopyWith(
          WiringWire value, $Res Function(WiringWire) then) =
      _$WiringWireCopyWithImpl<$Res>;
  $Res call({String wireId, String output, String input});
}

/// @nodoc
class _$WiringWireCopyWithImpl<$Res> implements $WiringWireCopyWith<$Res> {
  _$WiringWireCopyWithImpl(this._value, this._then);

  final WiringWire _value;
  // ignore: unused_field
  final $Res Function(WiringWire) _then;

  @override
  $Res call({
    Object? wireId = freezed,
    Object? output = freezed,
    Object? input = freezed,
  }) {
    return _then(_value.copyWith(
      wireId: wireId == freezed
          ? _value.wireId
          : wireId // ignore: cast_nullable_to_non_nullable
              as String,
      output: output == freezed
          ? _value.output
          : output // ignore: cast_nullable_to_non_nullable
              as String,
      input: input == freezed
          ? _value.input
          : input // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_WiringWireCopyWith<$Res>
    implements $WiringWireCopyWith<$Res> {
  factory _$$_WiringWireCopyWith(
          _$_WiringWire value, $Res Function(_$_WiringWire) then) =
      __$$_WiringWireCopyWithImpl<$Res>;
  @override
  $Res call({String wireId, String output, String input});
}

/// @nodoc
class __$$_WiringWireCopyWithImpl<$Res> extends _$WiringWireCopyWithImpl<$Res>
    implements _$$_WiringWireCopyWith<$Res> {
  __$$_WiringWireCopyWithImpl(
      _$_WiringWire _value, $Res Function(_$_WiringWire) _then)
      : super(_value, (v) => _then(v as _$_WiringWire));

  @override
  _$_WiringWire get _value => super._value as _$_WiringWire;

  @override
  $Res call({
    Object? wireId = freezed,
    Object? output = freezed,
    Object? input = freezed,
  }) {
    return _then(_$_WiringWire(
      wireId: wireId == freezed
          ? _value.wireId
          : wireId // ignore: cast_nullable_to_non_nullable
              as String,
      output: output == freezed
          ? _value.output
          : output // ignore: cast_nullable_to_non_nullable
              as String,
      input: input == freezed
          ? _value.input
          : input // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_WiringWire implements _WiringWire {
  const _$_WiringWire(
      {required this.wireId, required this.output, required this.input});

  factory _$_WiringWire.fromJson(Map<String, dynamic> json) =>
      _$$_WiringWireFromJson(json);

  @override
  final String wireId;
  @override
  final String output;
  @override
  final String input;

  @override
  String toString() {
    return 'WiringWire(wireId: $wireId, output: $output, input: $input)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_WiringWire &&
            const DeepCollectionEquality().equals(other.wireId, wireId) &&
            const DeepCollectionEquality().equals(other.output, output) &&
            const DeepCollectionEquality().equals(other.input, input));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(wireId),
      const DeepCollectionEquality().hash(output),
      const DeepCollectionEquality().hash(input));

  @JsonKey(ignore: true)
  @override
  _$$_WiringWireCopyWith<_$_WiringWire> get copyWith =>
      __$$_WiringWireCopyWithImpl<_$_WiringWire>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_WiringWireToJson(this);
  }
}

abstract class _WiringWire implements WiringWire {
  const factory _WiringWire(
      {required final String wireId,
      required final String output,
      required final String input}) = _$_WiringWire;

  factory _WiringWire.fromJson(Map<String, dynamic> json) =
      _$_WiringWire.fromJson;

  @override
  String get wireId => throw _privateConstructorUsedError;
  @override
  String get output => throw _privateConstructorUsedError;
  @override
  String get input => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_WiringWireCopyWith<_$_WiringWire> get copyWith =>
      throw _privateConstructorUsedError;
}
