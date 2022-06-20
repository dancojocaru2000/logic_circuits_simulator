import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logic_circuits_simulator/models.dart';
import 'package:logic_circuits_simulator/pages_arguments/design_component.dart';
import 'package:logic_circuits_simulator/state/component.dart';
import 'package:logic_circuits_simulator/utils/provider_hook.dart';
import 'package:logic_circuits_simulator/utils/stack_canvas_controller_hook.dart';
import 'package:stack_canvas/stack_canvas.dart';

class DesignComponentPage extends HookWidget {
  final ComponentEntry component;

  const DesignComponentPage({required this.component, super.key});
  DesignComponentPage.fromArguments(DesignComponentPageArguments args, {super.key})
    : component = args.component;

  static const String routeName = '/project/component/design';

  @override
  Widget build(BuildContext context) {
    final componentState = useProvider<ComponentState>();
    final canvasController = useStackCanvasController();
    final widgets = useState(<CanvasObject<Widget>>[]);
    useEffect(() {
      canvasController.addCanvasObjects(widgets.value);

      return () {
        // Cleanup
        canvasController.clearCanvas();
      };
    }, [widgets]);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Design - ${component.componentName}'),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: StackCanvas(
                    canvasController: canvasController,
                    backgroundColor: Theme.of(context).colorScheme.background,
                  ),
                ),
              ],
            );
          }
          else {
            return Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: StackCanvas(
                    canvasController: canvasController,
                  ),
                ),
              ],
            );
          }
        }
      ),
    );
  }
}
