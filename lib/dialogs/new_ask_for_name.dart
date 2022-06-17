import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NewAskForNameDialog extends HookWidget {
  final String title;
  final String? labelText;

  const NewAskForNameDialog({required this.title, this.labelText, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tec = useTextEditingController();
    final onPressed = useMemoized(() => () {
      Navigator.of(context).pop(tec.text);
    }, [tec.text]);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: 'Close',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.headline6,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  constraints: const BoxConstraints(minWidth: 300),
                  child: TextField(
                    controller: tec,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: labelText,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.done),
                        onPressed: onPressed,
                      ),
                    ),
                    onSubmitted: (_) => onPressed(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}