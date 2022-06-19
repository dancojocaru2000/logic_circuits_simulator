import 'package:flutter/material.dart';
import 'package:logic_circuits_simulator/utils/iterable_extension.dart';

class TruthTableHeaderText extends StatelessWidget {
  final String text;
  final BoxBorder? border;

  const TruthTableHeaderText(this.text, {super.key, this.border});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: border,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
    );
  }
}

class TruthTableTrue extends StatelessWidget {
  final BoxBorder? border;
  final void Function()? onTap;

  const TruthTableTrue({super.key, this.border, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: border,
      ),
      child: InkWell(
        onTap: onTap,
        child: Text(
          'T',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Colors.green,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

class TruthTableFalse extends StatelessWidget {
  final BoxBorder? border;
  final void Function()? onTap;

  const TruthTableFalse({super.key, this.border, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: border,
      ),
      child: InkWell(
        onTap: onTap,
        child: Text(
          'F',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Colors.red,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

class TruthTableEditor extends StatelessWidget {
  static const marginBorder = BorderSide(
    color: Colors.black,
    width: 2,
  );
  static const innerBorder = BorderSide(
    color: Colors.black45,
    width: 1,
  );

  final List<String> inputs;
  final List<String> outputs;
  final List<String> truthTable;

  final void Function(int, String)? onUpdateTable;

  const TruthTableEditor({Key? key, required this.inputs, required this.outputs, required this.truthTable, required this.onUpdateTable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultColumnWidth: const IntrinsicColumnWidth(),
      border: TableBorder.symmetric(outside: const BorderSide(width: 2)),
      children: List.generate(
        truthTable.length + 1, 
        (index) {
          if (index == 0) {
            return TableRow(
              children: inputs
                .indexedMap<Widget>(
                  (index, e) => TruthTableHeaderText(
                    e,
                    border: Border(
                      bottom: marginBorder,
                      right: index == inputs.length - 1 
                        ? marginBorder 
                        : innerBorder,
                    ),
                  )
                )
                .followedBy(
                  outputs
                  .indexedMap(
                    (index, e) => TruthTableHeaderText(
                      e, 
                      border: Border(
                        bottom: const BorderSide(width: 2),
                        right: index == outputs.length - 1
                          ? BorderSide.none
                          : innerBorder,
                      ),
                    )
                  )
                )
                .toList(),
            );
          }
          final inputBinary = (index - 1).toRadixString(2).padLeft(inputs.length, '0');
          final outputBinary = truthTable[index - 1];

          Widget runeToWidget({required int rune, void Function()? onTap, BoxBorder? border}) {
            return int.parse(String.fromCharCode(rune)) != 0 
              ? TruthTableTrue(
                border: border,
                onTap: onTap,
              ) 
              : TruthTableFalse(
                border: border,
                onTap: onTap,
              );
          }

          return TableRow(
            children: inputBinary.runes.indexedMap(
                (i, r) => runeToWidget(
                  rune: r, 
                  border: i == inputBinary.runes.length - 1 
                    ? const Border(right: marginBorder) 
                    : const Border(right: innerBorder),
                )
              )
              .followedBy(outputBinary.runes.indexedMap(
                (i, r) => runeToWidget(
                  rune: r,
                  border: i == outputBinary.runes.length - 1 
                    ? null 
                    : const Border(right: innerBorder),
                  onTap: onUpdateTable == null ? null : () {
                    onUpdateTable!(index - 1, outputBinary.replaceRange(i, i+1, (outputBinary[i] == "1") ? "0" : "1"));
                  },
                ),
              ))
              .toList(),
          );
        },
      ),
    );
  }
}
