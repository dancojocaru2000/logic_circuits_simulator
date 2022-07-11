import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class VisualComponent extends HookWidget {
  final String name;
  final List<String> inputs;
  final List<String> outputs;
  final Map<String, Color?> inputColors;
  final Map<String, Color?> outputColors;
  final bool isNextToSimulate;
  final void Function(String)? onInputHovered;
  final void Function(String)? onInputUnhovered;
  final void Function(String)? onOutputHovered;
  final void Function(String)? onOutputUnhovered;

  VisualComponent({
      super.key,
      required this.name,
      required this.inputs,
      required this.outputs,
      Map<String, Color?>? inputColors,
      Map<String, Color?>? outputColors,
      this.isNextToSimulate = false,
      this.onInputHovered,
      this.onInputUnhovered,
      this.onOutputHovered,
      this.onOutputUnhovered,
    }) 
    : inputColors = inputColors ?? {}
    , outputColors = outputColors ?? {}
    , assert((onInputHovered == null) == (onInputUnhovered == null))
    , assert((onOutputHovered == null) == (onOutputUnhovered == null));

  @override
  Widget build(BuildContext context) {
    final nextToSimulateFlashingAnimation = useAnimationController(
      duration: const Duration(milliseconds: 500),
      initialValue: 0.0,
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    useEffect(() {
      if (isNextToSimulate) {
        nextToSimulateFlashingAnimation.repeat(
          reverse: true,
        );
      }
      else {
        nextToSimulateFlashingAnimation.reset();
      }

      return null;
    }, [isNextToSimulate]);
    final nextToSimAnimProgress = useAnimation(nextToSimulateFlashingAnimation);

    final hovered = useState(false);

    useEffect(() {
      if (onInputHovered != null || onOutputHovered != null) {
        hovered.value = false;
      }

      return null;
    }, [onInputHovered, onOutputHovered]);

    final inputsWidth = inputs.map((input) => IOLabel.getNeededWidth(context, input)).fold<double>(0, (previousValue, element) => max(previousValue, element));
    final outputsWidth = outputs.map((output) => IOLabel.getNeededWidth(context, output)).fold<double>(0, (previousValue, element) => max(previousValue, element));

    return MouseRegion(
      onEnter: onInputHovered == null && onOutputHovered == null ? (event) => hovered.value = true : null,
      onExit: onInputUnhovered == null && onOutputUnhovered== null ? (event) => hovered.value = false : null, 
      child: Row(
        children: [
          Column(
            children: [
              for (final input in inputs) Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: IOLabel(
                    label: input,
                    input: true,
                    lineColor: hovered.value 
                      ? Theme.of(context).colorScheme.primary 
                      : inputColors[input] ?? Colors.black,
                    width: inputsWidth,
                    onHovered: onInputHovered == null ? null : () => onInputHovered!(input),
                    onUnhovered: onInputUnhovered == null ? null : () => onInputUnhovered!(input),
                    flashing: onInputHovered != null,
                  ),
              ),
            ],
          ),
          Container(
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.lerp(
                  hovered.value ? Theme.of(context).colorScheme.primary : Colors.black,
                  Colors.blue,
                  nextToSimAnimProgress,
                )!,
              ),
            ),
            child: Center(
              child: Text(
                name,
                softWrap: true,
              ),
            ),
          ),
          Column(
            children: [
              for (final output in outputs) Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: IOLabel(
                    label: output,
                    input: false,
                    lineColor: hovered.value 
                      ? Theme.of(context).colorScheme.primary 
                      : outputColors[output] ?? Colors.black,
                    width: outputsWidth,
                    onHovered: onOutputHovered == null ? null : () => onOutputHovered!(output),
                    onUnhovered: onOutputUnhovered == null ? null : () => onOutputUnhovered!(output),
                    flashing: onOutputHovered != null,
                  ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static double getNeededWidth(BuildContext context, List<String> inputs, List<String> outputs, [TextStyle? textStyle]) {
    final inputsWidth = inputs.map((input) => IOLabel.getNeededWidth(context, input, textStyle)).fold<double>(0, (previousValue, element) => max(previousValue, element));
    final outputsWidth = outputs.map((output) => IOLabel.getNeededWidth(context, output, textStyle)).fold<double>(0, (previousValue, element) => max(previousValue, element));
    return inputsWidth + outputsWidth + 100;
  }

  static double getHeightOfIO(BuildContext context, List<String> options, int index, [TextStyle? textStyle]) {
    assert(index <= options.length);
    getHeightOfText(String text) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: (textStyle ?? DefaultTextStyle.of(context).style).merge(
            const TextStyle(
              inherit: true,
              fontFeatures: [
                FontFeature.tabularFigures(),
              ],
            ),
          ),
        ),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout();
      return textPainter.height;
    }
    var result = 0.0;
    for (var i = 0; i < index; i++) {
      result += 5.0 + getHeightOfText(options[i]) + 5.0;
    }
    if (index < options.length) {
      result += 5.0 + getHeightOfText(options[index]);
    }
    return result;
  }
}

class IOComponent extends HookWidget {
  final bool input;
  final String name;
  final double width;
  final double circleDiameter;
  final Color? color;
  final void Function()? onTap;
  final void Function()? onHovered;
  final void Function()? onUnhovered;
  final bool flashing;

  const IOComponent({
    super.key,
    required this.name,
    required this.input,
    this.width = 100,
    this.circleDiameter = 20,
    this.color,
    this.onTap,
    this.onHovered,
    this.onUnhovered,
    this.flashing = false,
  }) : assert((onHovered == null) == (onUnhovered == null));

  @override
  Widget build(BuildContext context) {
    final flashingAnimation = useAnimationController(
      duration: const Duration(milliseconds: 500),
      initialValue: 0.0,
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    useEffect(() {
      if (flashing) {
        flashingAnimation.repeat(
          reverse: true,
        );
      }
      else {
        flashingAnimation.reset();
      }

      return null;
    }, [flashing]);
    final flashingAnimProgress = useAnimation(flashingAnimation);

    final hovered = useState(false);

    useEffect(() {
      if (onHovered != null) {
        hovered.value = false;
      }

      return null;
    }, [onHovered]);

    return MouseRegion(
      onEnter: (event) => onHovered != null ? onHovered!() : hovered.value = true,
      onExit: (event) => onUnhovered != null ? onUnhovered!() : hovered.value = false,
      hitTestBehavior: HitTestBehavior.translucent,
      opaque: false,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Builder(
          builder: (context) {
            final lineColor = hovered.value ? Theme.of(context).colorScheme.primary : color ?? Colors.black;
            final animLineColor = Color.lerp(
              lineColor,
              Colors.blue,
              flashingAnimProgress,
            )!;
      
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (input) Container(
                  width: circleDiameter,
                  height: circleDiameter,
                  decoration: BoxDecoration(
                    border: Border.all(color: animLineColor),
                    shape: BoxShape.circle,
                    color: color,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: circleDiameter - 2),
                  child: IOLabel(
                    label: name,
                    input: !input,
                    lineColor: animLineColor,
                    width: width - circleDiameter,
                  ),
                ),
                if (!input) Container(
                  width: circleDiameter,
                  height: circleDiameter,
                  decoration: BoxDecoration(
                    border: Border.all(color: animLineColor),
                    shape: BoxShape.circle,
                    color: color,
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }

  static double getNeededWidth(BuildContext context, String name, {double circleDiameter = 20, TextStyle? textStyle}) {
    return circleDiameter + IOLabel.getNeededWidth(context, name, textStyle);
  }
}

class IOLabel extends HookWidget {
  final bool input;
  final String label;
  final Color lineColor;
  final double width;
  final void Function()? onHovered;
  final void Function()? onUnhovered;
  final bool flashing;

  const IOLabel({super.key, required this.lineColor, required this.label, required this.input, this.width = 80, this.onHovered, this.onUnhovered, this.flashing = false,})
    : assert((onHovered == null) == (onUnhovered == null));

  @override
  Widget build(BuildContext context) {
    final flashingAnimation = useAnimationController(
      duration: const Duration(milliseconds: 500),
      initialValue: 0.0,
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    useEffect(() {
      if (flashing) {
        flashingAnimation.repeat(
          reverse: true,
        );
      }
      else {
        flashingAnimation.reset();
      }

      return null;
    }, [flashing]);
    final flashingAnimProgress = useAnimation(flashingAnimation);

    final hovered = useState(false);

    return MouseRegion(
      hitTestBehavior: onHovered != null ? HitTestBehavior.translucent : HitTestBehavior.deferToChild,
      onEnter: onHovered == null ? null : (_) {
        hovered.value = true;
        onHovered!();
      },
      onExit: onUnhovered == null ? null : (_) {
        hovered.value = false;
        onUnhovered!();
      },
      child: Container(
        width: width,
        height: 20,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color.lerp(
                lineColor,
                Colors.blue,
                flashingAnimProgress,
              )!,
            ),
          ),
        ),
        child: Align(
          alignment: input ? Alignment.bottomRight : Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              label,
              style: const TextStyle(
                inherit: true,
                fontFeatures: [
                  FontFeature.tabularFigures(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static double getNeededWidth(BuildContext context, String text, [TextStyle? textStyle]) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: (textStyle ?? DefaultTextStyle.of(context).style).merge(
          const TextStyle(
            inherit: true,
            fontFeatures: [
              FontFeature.tabularFigures(),
            ],
          ),
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    return textPainter.width + 10;
  }  
}

class WireWidget extends StatelessWidget {
  final Offset from;
  final Offset to;
  final Color color;

  const WireWidget({
    required this.from,
    required this.to,
    this.color = Colors.black,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _WireCustomPainter(
        color: color, 
        primaryDiagonal: 
          (from.dx < to.dx && from.dy < to.dy) || 
          (from.dx > to.dx && from.dy > to.dy),
      ),
      child: SizedBox(
        height: (to - from).dy.abs(),
        width: (to - from).dx.abs(),
      ),
    );
  }
}

class _WireCustomPainter extends CustomPainter {
  final Color color;
  final bool primaryDiagonal;

  const _WireCustomPainter({required this.color, required this.primaryDiagonal});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color;
    if (primaryDiagonal) {
      canvas.drawLine(
        Offset.zero,
        Offset(size.width, size.height),
        paint,
      );
    }
    else {
      canvas.drawLine(
        Offset(size.width, 0),
        Offset(0, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
