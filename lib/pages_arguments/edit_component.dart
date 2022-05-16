import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logic_circuits_simulator/models/project.dart';

part 'edit_component.freezed.dart';

@freezed
class EditComponentPageArguments with _$EditComponentPageArguments {
  const factory EditComponentPageArguments({
    required ComponentEntry component,
    @Default(false)
    bool newComponent,
  }) = _EditComponentPageArguments;
}
