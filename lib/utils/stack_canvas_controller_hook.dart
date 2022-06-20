import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stack_canvas/stack_canvas.dart';

StackCanvasController useStackCanvasController({
  double zoomChangeUnit = 0.10,
  double moveChangeUnit = 30.00,
  Reference offsetReference = Reference.TopLeft,
  Reference zoomReference = Reference.TopLeft,
}) {
  return use(_StackCanvasControllerHookCreator(
    moveChangeUnit: moveChangeUnit,
    offsetReference: offsetReference,
    zoomChangeUnit: zoomChangeUnit,
    zoomReference: zoomReference,
  ));
}

class _StackCanvasControllerHookCreator extends Hook<StackCanvasController> {
  final double zoomChangeUnit;
  final double moveChangeUnit;
  final Reference offsetReference;
  final Reference zoomReference;

  const _StackCanvasControllerHookCreator({
    this.zoomChangeUnit = 0.10,
    this.moveChangeUnit = 30.00,
    this.offsetReference = Reference.TopLeft,
    this.zoomReference = Reference.TopLeft,
  });

  @override
  HookState<StackCanvasController, Hook<StackCanvasController>> createState() {
    return _StackCanvasControllerHookCreatorState();
  }
}

class _StackCanvasControllerHookCreatorState extends HookState<StackCanvasController, _StackCanvasControllerHookCreator> {
  late StackCanvasController _controller;

  @override
  void initHook() {
    super.initHook();
    _controller = StackCanvasController(
      moveChangeUnit: hook.moveChangeUnit,
      offsetReference: hook.offsetReference,
      zoomChangeUnit: hook.zoomChangeUnit,
      zoomReference: hook.zoomReference,
    );
  }

  @override
  StackCanvasController build(BuildContext context) {
    return _controller;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
