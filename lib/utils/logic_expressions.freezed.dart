// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'logic_expressions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$LogicExpression {
  LogicOperator get operator => throw _privateConstructorUsedError;
  List<dynamic> get arguments => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LogicExpressionCopyWith<LogicExpression> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LogicExpressionCopyWith<$Res> {
  factory $LogicExpressionCopyWith(
          LogicExpression value, $Res Function(LogicExpression) then) =
      _$LogicExpressionCopyWithImpl<$Res>;
  $Res call({LogicOperator operator, List<dynamic> arguments});
}

/// @nodoc
class _$LogicExpressionCopyWithImpl<$Res>
    implements $LogicExpressionCopyWith<$Res> {
  _$LogicExpressionCopyWithImpl(this._value, this._then);

  final LogicExpression _value;
  // ignore: unused_field
  final $Res Function(LogicExpression) _then;

  @override
  $Res call({
    Object? operator = freezed,
    Object? arguments = freezed,
  }) {
    return _then(_value.copyWith(
      operator: operator == freezed
          ? _value.operator
          : operator // ignore: cast_nullable_to_non_nullable
              as LogicOperator,
      arguments: arguments == freezed
          ? _value.arguments
          : arguments // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
    ));
  }
}

/// @nodoc
abstract class _$$_LogicExpressionCopyWith<$Res>
    implements $LogicExpressionCopyWith<$Res> {
  factory _$$_LogicExpressionCopyWith(
          _$_LogicExpression value, $Res Function(_$_LogicExpression) then) =
      __$$_LogicExpressionCopyWithImpl<$Res>;
  @override
  $Res call({LogicOperator operator, List<dynamic> arguments});
}

/// @nodoc
class __$$_LogicExpressionCopyWithImpl<$Res>
    extends _$LogicExpressionCopyWithImpl<$Res>
    implements _$$_LogicExpressionCopyWith<$Res> {
  __$$_LogicExpressionCopyWithImpl(
      _$_LogicExpression _value, $Res Function(_$_LogicExpression) _then)
      : super(_value, (v) => _then(v as _$_LogicExpression));

  @override
  _$_LogicExpression get _value => super._value as _$_LogicExpression;

  @override
  $Res call({
    Object? operator = freezed,
    Object? arguments = freezed,
  }) {
    return _then(_$_LogicExpression(
      operator: operator == freezed
          ? _value.operator
          : operator // ignore: cast_nullable_to_non_nullable
              as LogicOperator,
      arguments: arguments == freezed
          ? _value._arguments
          : arguments // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
    ));
  }
}

/// @nodoc

class _$_LogicExpression extends _LogicExpression {
  const _$_LogicExpression(
      {required this.operator, required final List<dynamic> arguments})
      : _arguments = arguments,
        super._();

  @override
  final LogicOperator operator;
  final List<dynamic> _arguments;
  @override
  List<dynamic> get arguments {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_arguments);
  }

  @override
  String toString() {
    return 'LogicExpression(operator: $operator, arguments: $arguments)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LogicExpression &&
            const DeepCollectionEquality().equals(other.operator, operator) &&
            const DeepCollectionEquality()
                .equals(other._arguments, _arguments));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(operator),
      const DeepCollectionEquality().hash(_arguments));

  @JsonKey(ignore: true)
  @override
  _$$_LogicExpressionCopyWith<_$_LogicExpression> get copyWith =>
      __$$_LogicExpressionCopyWithImpl<_$_LogicExpression>(this, _$identity);
}

abstract class _LogicExpression extends LogicExpression {
  const factory _LogicExpression(
      {required final LogicOperator operator,
      required final List<dynamic> arguments}) = _$_LogicExpression;
  const _LogicExpression._() : super._();

  @override
  LogicOperator get operator => throw _privateConstructorUsedError;
  @override
  List<dynamic> get arguments => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_LogicExpressionCopyWith<_$_LogicExpression> get copyWith =>
      throw _privateConstructorUsedError;
}
