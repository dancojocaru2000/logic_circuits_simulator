// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'design.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Design _$DesignFromJson(Map<String, dynamic> json) {
  return _Design.fromJson(json);
}

/// @nodoc
mixin _$Design {
  List<DesignComponent> get components => throw _privateConstructorUsedError;
  List<DesignWire> get wires => throw _privateConstructorUsedError;
  List<DesignInput> get inputs => throw _privateConstructorUsedError;
  List<DesignOutput> get outputs => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DesignCopyWith<Design> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DesignCopyWith<$Res> {
  factory $DesignCopyWith(Design value, $Res Function(Design) then) =
      _$DesignCopyWithImpl<$Res>;
  $Res call(
      {List<DesignComponent> components,
      List<DesignWire> wires,
      List<DesignInput> inputs,
      List<DesignOutput> outputs});
}

/// @nodoc
class _$DesignCopyWithImpl<$Res> implements $DesignCopyWith<$Res> {
  _$DesignCopyWithImpl(this._value, this._then);

  final Design _value;
  // ignore: unused_field
  final $Res Function(Design) _then;

  @override
  $Res call({
    Object? components = freezed,
    Object? wires = freezed,
    Object? inputs = freezed,
    Object? outputs = freezed,
  }) {
    return _then(_value.copyWith(
      components: components == freezed
          ? _value.components
          : components // ignore: cast_nullable_to_non_nullable
              as List<DesignComponent>,
      wires: wires == freezed
          ? _value.wires
          : wires // ignore: cast_nullable_to_non_nullable
              as List<DesignWire>,
      inputs: inputs == freezed
          ? _value.inputs
          : inputs // ignore: cast_nullable_to_non_nullable
              as List<DesignInput>,
      outputs: outputs == freezed
          ? _value.outputs
          : outputs // ignore: cast_nullable_to_non_nullable
              as List<DesignOutput>,
    ));
  }
}

/// @nodoc
abstract class _$$_DesignCopyWith<$Res> implements $DesignCopyWith<$Res> {
  factory _$$_DesignCopyWith(_$_Design value, $Res Function(_$_Design) then) =
      __$$_DesignCopyWithImpl<$Res>;
  @override
  $Res call(
      {List<DesignComponent> components,
      List<DesignWire> wires,
      List<DesignInput> inputs,
      List<DesignOutput> outputs});
}

/// @nodoc
class __$$_DesignCopyWithImpl<$Res> extends _$DesignCopyWithImpl<$Res>
    implements _$$_DesignCopyWith<$Res> {
  __$$_DesignCopyWithImpl(_$_Design _value, $Res Function(_$_Design) _then)
      : super(_value, (v) => _then(v as _$_Design));

  @override
  _$_Design get _value => super._value as _$_Design;

  @override
  $Res call({
    Object? components = freezed,
    Object? wires = freezed,
    Object? inputs = freezed,
    Object? outputs = freezed,
  }) {
    return _then(_$_Design(
      components: components == freezed
          ? _value._components
          : components // ignore: cast_nullable_to_non_nullable
              as List<DesignComponent>,
      wires: wires == freezed
          ? _value._wires
          : wires // ignore: cast_nullable_to_non_nullable
              as List<DesignWire>,
      inputs: inputs == freezed
          ? _value._inputs
          : inputs // ignore: cast_nullable_to_non_nullable
              as List<DesignInput>,
      outputs: outputs == freezed
          ? _value._outputs
          : outputs // ignore: cast_nullable_to_non_nullable
              as List<DesignOutput>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Design implements _Design {
  const _$_Design(
      {required final List<DesignComponent> components,
      required final List<DesignWire> wires,
      required final List<DesignInput> inputs,
      required final List<DesignOutput> outputs})
      : _components = components,
        _wires = wires,
        _inputs = inputs,
        _outputs = outputs;

  factory _$_Design.fromJson(Map<String, dynamic> json) =>
      _$$_DesignFromJson(json);

  final List<DesignComponent> _components;
  @override
  List<DesignComponent> get components {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_components);
  }

  final List<DesignWire> _wires;
  @override
  List<DesignWire> get wires {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_wires);
  }

  final List<DesignInput> _inputs;
  @override
  List<DesignInput> get inputs {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_inputs);
  }

  final List<DesignOutput> _outputs;
  @override
  List<DesignOutput> get outputs {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_outputs);
  }

  @override
  String toString() {
    return 'Design(components: $components, wires: $wires, inputs: $inputs, outputs: $outputs)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Design &&
            const DeepCollectionEquality()
                .equals(other._components, _components) &&
            const DeepCollectionEquality().equals(other._wires, _wires) &&
            const DeepCollectionEquality().equals(other._inputs, _inputs) &&
            const DeepCollectionEquality().equals(other._outputs, _outputs));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_components),
      const DeepCollectionEquality().hash(_wires),
      const DeepCollectionEquality().hash(_inputs),
      const DeepCollectionEquality().hash(_outputs));

  @JsonKey(ignore: true)
  @override
  _$$_DesignCopyWith<_$_Design> get copyWith =>
      __$$_DesignCopyWithImpl<_$_Design>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_DesignToJson(this);
  }
}

abstract class _Design implements Design {
  const factory _Design(
      {required final List<DesignComponent> components,
      required final List<DesignWire> wires,
      required final List<DesignInput> inputs,
      required final List<DesignOutput> outputs}) = _$_Design;

  factory _Design.fromJson(Map<String, dynamic> json) = _$_Design.fromJson;

  @override
  List<DesignComponent> get components => throw _privateConstructorUsedError;
  @override
  List<DesignWire> get wires => throw _privateConstructorUsedError;
  @override
  List<DesignInput> get inputs => throw _privateConstructorUsedError;
  @override
  List<DesignOutput> get outputs => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_DesignCopyWith<_$_Design> get copyWith =>
      throw _privateConstructorUsedError;
}

DesignComponent _$DesignComponentFromJson(Map<String, dynamic> json) {
  return _DesignComponent.fromJson(json);
}

/// @nodoc
mixin _$DesignComponent {
  String get instanceId => throw _privateConstructorUsedError;
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DesignComponentCopyWith<DesignComponent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DesignComponentCopyWith<$Res> {
  factory $DesignComponentCopyWith(
          DesignComponent value, $Res Function(DesignComponent) then) =
      _$DesignComponentCopyWithImpl<$Res>;
  $Res call({String instanceId, double x, double y});
}

/// @nodoc
class _$DesignComponentCopyWithImpl<$Res>
    implements $DesignComponentCopyWith<$Res> {
  _$DesignComponentCopyWithImpl(this._value, this._then);

  final DesignComponent _value;
  // ignore: unused_field
  final $Res Function(DesignComponent) _then;

  @override
  $Res call({
    Object? instanceId = freezed,
    Object? x = freezed,
    Object? y = freezed,
  }) {
    return _then(_value.copyWith(
      instanceId: instanceId == freezed
          ? _value.instanceId
          : instanceId // ignore: cast_nullable_to_non_nullable
              as String,
      x: x == freezed
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: y == freezed
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
abstract class _$$_DesignComponentCopyWith<$Res>
    implements $DesignComponentCopyWith<$Res> {
  factory _$$_DesignComponentCopyWith(
          _$_DesignComponent value, $Res Function(_$_DesignComponent) then) =
      __$$_DesignComponentCopyWithImpl<$Res>;
  @override
  $Res call({String instanceId, double x, double y});
}

/// @nodoc
class __$$_DesignComponentCopyWithImpl<$Res>
    extends _$DesignComponentCopyWithImpl<$Res>
    implements _$$_DesignComponentCopyWith<$Res> {
  __$$_DesignComponentCopyWithImpl(
      _$_DesignComponent _value, $Res Function(_$_DesignComponent) _then)
      : super(_value, (v) => _then(v as _$_DesignComponent));

  @override
  _$_DesignComponent get _value => super._value as _$_DesignComponent;

  @override
  $Res call({
    Object? instanceId = freezed,
    Object? x = freezed,
    Object? y = freezed,
  }) {
    return _then(_$_DesignComponent(
      instanceId: instanceId == freezed
          ? _value.instanceId
          : instanceId // ignore: cast_nullable_to_non_nullable
              as String,
      x: x == freezed
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: y == freezed
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_DesignComponent implements _DesignComponent {
  const _$_DesignComponent(
      {required this.instanceId, required this.x, required this.y});

  factory _$_DesignComponent.fromJson(Map<String, dynamic> json) =>
      _$$_DesignComponentFromJson(json);

  @override
  final String instanceId;
  @override
  final double x;
  @override
  final double y;

  @override
  String toString() {
    return 'DesignComponent(instanceId: $instanceId, x: $x, y: $y)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DesignComponent &&
            const DeepCollectionEquality()
                .equals(other.instanceId, instanceId) &&
            const DeepCollectionEquality().equals(other.x, x) &&
            const DeepCollectionEquality().equals(other.y, y));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(instanceId),
      const DeepCollectionEquality().hash(x),
      const DeepCollectionEquality().hash(y));

  @JsonKey(ignore: true)
  @override
  _$$_DesignComponentCopyWith<_$_DesignComponent> get copyWith =>
      __$$_DesignComponentCopyWithImpl<_$_DesignComponent>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_DesignComponentToJson(this);
  }
}

abstract class _DesignComponent implements DesignComponent {
  const factory _DesignComponent(
      {required final String instanceId,
      required final double x,
      required final double y}) = _$_DesignComponent;

  factory _DesignComponent.fromJson(Map<String, dynamic> json) =
      _$_DesignComponent.fromJson;

  @override
  String get instanceId => throw _privateConstructorUsedError;
  @override
  double get x => throw _privateConstructorUsedError;
  @override
  double get y => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_DesignComponentCopyWith<_$_DesignComponent> get copyWith =>
      throw _privateConstructorUsedError;
}

DesignWire _$DesignWireFromJson(Map<String, dynamic> json) {
  return _DesignWire.fromJson(json);
}

/// @nodoc
mixin _$DesignWire {
  String get wireId => throw _privateConstructorUsedError;
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DesignWireCopyWith<DesignWire> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DesignWireCopyWith<$Res> {
  factory $DesignWireCopyWith(
          DesignWire value, $Res Function(DesignWire) then) =
      _$DesignWireCopyWithImpl<$Res>;
  $Res call({String wireId, double x, double y});
}

/// @nodoc
class _$DesignWireCopyWithImpl<$Res> implements $DesignWireCopyWith<$Res> {
  _$DesignWireCopyWithImpl(this._value, this._then);

  final DesignWire _value;
  // ignore: unused_field
  final $Res Function(DesignWire) _then;

  @override
  $Res call({
    Object? wireId = freezed,
    Object? x = freezed,
    Object? y = freezed,
  }) {
    return _then(_value.copyWith(
      wireId: wireId == freezed
          ? _value.wireId
          : wireId // ignore: cast_nullable_to_non_nullable
              as String,
      x: x == freezed
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: y == freezed
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
abstract class _$$_DesignWireCopyWith<$Res>
    implements $DesignWireCopyWith<$Res> {
  factory _$$_DesignWireCopyWith(
          _$_DesignWire value, $Res Function(_$_DesignWire) then) =
      __$$_DesignWireCopyWithImpl<$Res>;
  @override
  $Res call({String wireId, double x, double y});
}

/// @nodoc
class __$$_DesignWireCopyWithImpl<$Res> extends _$DesignWireCopyWithImpl<$Res>
    implements _$$_DesignWireCopyWith<$Res> {
  __$$_DesignWireCopyWithImpl(
      _$_DesignWire _value, $Res Function(_$_DesignWire) _then)
      : super(_value, (v) => _then(v as _$_DesignWire));

  @override
  _$_DesignWire get _value => super._value as _$_DesignWire;

  @override
  $Res call({
    Object? wireId = freezed,
    Object? x = freezed,
    Object? y = freezed,
  }) {
    return _then(_$_DesignWire(
      wireId: wireId == freezed
          ? _value.wireId
          : wireId // ignore: cast_nullable_to_non_nullable
              as String,
      x: x == freezed
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: y == freezed
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_DesignWire implements _DesignWire {
  const _$_DesignWire({required this.wireId, required this.x, required this.y});

  factory _$_DesignWire.fromJson(Map<String, dynamic> json) =>
      _$$_DesignWireFromJson(json);

  @override
  final String wireId;
  @override
  final double x;
  @override
  final double y;

  @override
  String toString() {
    return 'DesignWire(wireId: $wireId, x: $x, y: $y)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DesignWire &&
            const DeepCollectionEquality().equals(other.wireId, wireId) &&
            const DeepCollectionEquality().equals(other.x, x) &&
            const DeepCollectionEquality().equals(other.y, y));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(wireId),
      const DeepCollectionEquality().hash(x),
      const DeepCollectionEquality().hash(y));

  @JsonKey(ignore: true)
  @override
  _$$_DesignWireCopyWith<_$_DesignWire> get copyWith =>
      __$$_DesignWireCopyWithImpl<_$_DesignWire>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_DesignWireToJson(this);
  }
}

abstract class _DesignWire implements DesignWire {
  const factory _DesignWire(
      {required final String wireId,
      required final double x,
      required final double y}) = _$_DesignWire;

  factory _DesignWire.fromJson(Map<String, dynamic> json) =
      _$_DesignWire.fromJson;

  @override
  String get wireId => throw _privateConstructorUsedError;
  @override
  double get x => throw _privateConstructorUsedError;
  @override
  double get y => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_DesignWireCopyWith<_$_DesignWire> get copyWith =>
      throw _privateConstructorUsedError;
}

DesignInput _$DesignInputFromJson(Map<String, dynamic> json) {
  return _DesignInput.fromJson(json);
}

/// @nodoc
mixin _$DesignInput {
  String get name => throw _privateConstructorUsedError;
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DesignInputCopyWith<DesignInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DesignInputCopyWith<$Res> {
  factory $DesignInputCopyWith(
          DesignInput value, $Res Function(DesignInput) then) =
      _$DesignInputCopyWithImpl<$Res>;
  $Res call({String name, double x, double y});
}

/// @nodoc
class _$DesignInputCopyWithImpl<$Res> implements $DesignInputCopyWith<$Res> {
  _$DesignInputCopyWithImpl(this._value, this._then);

  final DesignInput _value;
  // ignore: unused_field
  final $Res Function(DesignInput) _then;

  @override
  $Res call({
    Object? name = freezed,
    Object? x = freezed,
    Object? y = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      x: x == freezed
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: y == freezed
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
abstract class _$$_DesignInputCopyWith<$Res>
    implements $DesignInputCopyWith<$Res> {
  factory _$$_DesignInputCopyWith(
          _$_DesignInput value, $Res Function(_$_DesignInput) then) =
      __$$_DesignInputCopyWithImpl<$Res>;
  @override
  $Res call({String name, double x, double y});
}

/// @nodoc
class __$$_DesignInputCopyWithImpl<$Res> extends _$DesignInputCopyWithImpl<$Res>
    implements _$$_DesignInputCopyWith<$Res> {
  __$$_DesignInputCopyWithImpl(
      _$_DesignInput _value, $Res Function(_$_DesignInput) _then)
      : super(_value, (v) => _then(v as _$_DesignInput));

  @override
  _$_DesignInput get _value => super._value as _$_DesignInput;

  @override
  $Res call({
    Object? name = freezed,
    Object? x = freezed,
    Object? y = freezed,
  }) {
    return _then(_$_DesignInput(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      x: x == freezed
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: y == freezed
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_DesignInput implements _DesignInput {
  const _$_DesignInput({required this.name, required this.x, required this.y});

  factory _$_DesignInput.fromJson(Map<String, dynamic> json) =>
      _$$_DesignInputFromJson(json);

  @override
  final String name;
  @override
  final double x;
  @override
  final double y;

  @override
  String toString() {
    return 'DesignInput(name: $name, x: $x, y: $y)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DesignInput &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.x, x) &&
            const DeepCollectionEquality().equals(other.y, y));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(x),
      const DeepCollectionEquality().hash(y));

  @JsonKey(ignore: true)
  @override
  _$$_DesignInputCopyWith<_$_DesignInput> get copyWith =>
      __$$_DesignInputCopyWithImpl<_$_DesignInput>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_DesignInputToJson(this);
  }
}

abstract class _DesignInput implements DesignInput {
  const factory _DesignInput(
      {required final String name,
      required final double x,
      required final double y}) = _$_DesignInput;

  factory _DesignInput.fromJson(Map<String, dynamic> json) =
      _$_DesignInput.fromJson;

  @override
  String get name => throw _privateConstructorUsedError;
  @override
  double get x => throw _privateConstructorUsedError;
  @override
  double get y => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_DesignInputCopyWith<_$_DesignInput> get copyWith =>
      throw _privateConstructorUsedError;
}

DesignOutput _$DesignOutputFromJson(Map<String, dynamic> json) {
  return _DesignOutput.fromJson(json);
}

/// @nodoc
mixin _$DesignOutput {
  String get name => throw _privateConstructorUsedError;
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DesignOutputCopyWith<DesignOutput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DesignOutputCopyWith<$Res> {
  factory $DesignOutputCopyWith(
          DesignOutput value, $Res Function(DesignOutput) then) =
      _$DesignOutputCopyWithImpl<$Res>;
  $Res call({String name, double x, double y});
}

/// @nodoc
class _$DesignOutputCopyWithImpl<$Res> implements $DesignOutputCopyWith<$Res> {
  _$DesignOutputCopyWithImpl(this._value, this._then);

  final DesignOutput _value;
  // ignore: unused_field
  final $Res Function(DesignOutput) _then;

  @override
  $Res call({
    Object? name = freezed,
    Object? x = freezed,
    Object? y = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      x: x == freezed
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: y == freezed
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
abstract class _$$_DesignOutputCopyWith<$Res>
    implements $DesignOutputCopyWith<$Res> {
  factory _$$_DesignOutputCopyWith(
          _$_DesignOutput value, $Res Function(_$_DesignOutput) then) =
      __$$_DesignOutputCopyWithImpl<$Res>;
  @override
  $Res call({String name, double x, double y});
}

/// @nodoc
class __$$_DesignOutputCopyWithImpl<$Res>
    extends _$DesignOutputCopyWithImpl<$Res>
    implements _$$_DesignOutputCopyWith<$Res> {
  __$$_DesignOutputCopyWithImpl(
      _$_DesignOutput _value, $Res Function(_$_DesignOutput) _then)
      : super(_value, (v) => _then(v as _$_DesignOutput));

  @override
  _$_DesignOutput get _value => super._value as _$_DesignOutput;

  @override
  $Res call({
    Object? name = freezed,
    Object? x = freezed,
    Object? y = freezed,
  }) {
    return _then(_$_DesignOutput(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      x: x == freezed
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: y == freezed
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_DesignOutput implements _DesignOutput {
  const _$_DesignOutput({required this.name, required this.x, required this.y});

  factory _$_DesignOutput.fromJson(Map<String, dynamic> json) =>
      _$$_DesignOutputFromJson(json);

  @override
  final String name;
  @override
  final double x;
  @override
  final double y;

  @override
  String toString() {
    return 'DesignOutput(name: $name, x: $x, y: $y)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DesignOutput &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.x, x) &&
            const DeepCollectionEquality().equals(other.y, y));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(x),
      const DeepCollectionEquality().hash(y));

  @JsonKey(ignore: true)
  @override
  _$$_DesignOutputCopyWith<_$_DesignOutput> get copyWith =>
      __$$_DesignOutputCopyWithImpl<_$_DesignOutput>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_DesignOutputToJson(this);
  }
}

abstract class _DesignOutput implements DesignOutput {
  const factory _DesignOutput(
      {required final String name,
      required final double x,
      required final double y}) = _$_DesignOutput;

  factory _DesignOutput.fromJson(Map<String, dynamic> json) =
      _$_DesignOutput.fromJson;

  @override
  String get name => throw _privateConstructorUsedError;
  @override
  double get x => throw _privateConstructorUsedError;
  @override
  double get y => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_DesignOutputCopyWith<_$_DesignOutput> get copyWith =>
      throw _privateConstructorUsedError;
}
