import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logic_circuits_simulator/models.dart';

part 'design_component.freezed.dart';

@freezed
class DesignComponentPageArguments with _$DesignComponentPageArguments {
  const factory DesignComponentPageArguments({
    required ComponentEntry component,
  }) = _DesignComponentPageArguments;
}
