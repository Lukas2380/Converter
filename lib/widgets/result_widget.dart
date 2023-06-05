import 'package:flutter/material.dart';

class ResultWidget extends StatelessWidget {
  final double outputValue;
  final String unitSymbol;

  const ResultWidget({
    super.key,
    required this.outputValue,
    required this.unitSymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 32),
        const Text(
          'Result',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 50),
        Text(
          '$outputValue $unitSymbol',
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
