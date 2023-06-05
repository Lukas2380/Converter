import 'package:flutter/material.dart';
import '../../public_helper_methods.dart';
import '../../widgets/result_widget.dart';

enum WeightUnit {
  grams,
  kilograms,
  pounds,
  ounces,
  stones,
}

class WeightConverterPage extends StatefulWidget {
  const WeightConverterPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WeightConverterPageState createState() => _WeightConverterPageState();
}

class _WeightConverterPageState extends State<WeightConverterPage> {
  double _inputValue = 0;
  WeightUnit _inputUnit = WeightUnit.grams;
  WeightUnit _outputUnit = WeightUnit.kilograms;
  double _outputValue = 0;
  String _unitSymbol = '';

  Future<void> _convertWeight() async {
    double result;
    String unitSymbol = 'kg'; // Default unit symbol for Kilograms

    if (_inputUnit == WeightUnit.grams && _outputUnit == WeightUnit.kilograms) {
      result = _inputValue / 1000;
      unitSymbol = 'kg';
    } else if (_inputUnit == WeightUnit.grams &&
        _outputUnit == WeightUnit.pounds) {
      result = _inputValue * 0.00220462;
      unitSymbol = 'lb';
    } else if (_inputUnit == WeightUnit.grams &&
        _outputUnit == WeightUnit.ounces) {
      result = _inputValue * 0.035274;
      unitSymbol = 'oz';
    } else if (_inputUnit == WeightUnit.grams &&
        _outputUnit == WeightUnit.stones) {
      result = _inputValue * 0.000157473;
      unitSymbol = 'st';
    } else if (_inputUnit == WeightUnit.kilograms &&
        _outputUnit == WeightUnit.grams) {
      result = _inputValue * 1000;
      unitSymbol = 'g';
    } else if (_inputUnit == WeightUnit.kilograms &&
        _outputUnit == WeightUnit.pounds) {
      result = _inputValue * 2.20462;
      unitSymbol = 'lb';
    } else if (_inputUnit == WeightUnit.kilograms &&
        _outputUnit == WeightUnit.ounces) {
      result = _inputValue * 35.274;
      unitSymbol = 'oz';
    } else if (_inputUnit == WeightUnit.kilograms &&
        _outputUnit == WeightUnit.stones) {
      result = _inputValue * 0.157473;
      unitSymbol = 'st';
    } else if (_inputUnit == WeightUnit.pounds &&
        _outputUnit == WeightUnit.grams) {
      result = _inputValue * 453.592;
      unitSymbol = 'g';
    } else if (_inputUnit == WeightUnit.pounds &&
        _outputUnit == WeightUnit.kilograms) {
      result = _inputValue * 0.453592;
      unitSymbol = 'kg';
    } else if (_inputUnit == WeightUnit.pounds &&
        _outputUnit == WeightUnit.ounces) {
      result = _inputValue * 16;
      unitSymbol = 'oz';
    } else if (_inputUnit == WeightUnit.pounds &&
        _outputUnit == WeightUnit.stones) {
      result = _inputValue * 0.0714286;
      unitSymbol = 'st';
    } else if (_inputUnit == WeightUnit.ounces &&
        _outputUnit == WeightUnit.grams) {
      result = _inputValue * 28.3495;
      unitSymbol = 'g';
    } else if (_inputUnit == WeightUnit.ounces &&
        _outputUnit == WeightUnit.kilograms) {
      result = _inputValue * 0.0283495;
      unitSymbol = 'kg';
    } else if (_inputUnit == WeightUnit.ounces &&
        _outputUnit == WeightUnit.pounds) {
      result = _inputValue * 0.0625;
      unitSymbol = 'lb';
    } else if (_inputUnit == WeightUnit.ounces &&
        _outputUnit == WeightUnit.stones) {
      result = _inputValue * 0.00446429;
      unitSymbol = 'st';
    } else if (_inputUnit == WeightUnit.stones &&
        _outputUnit == WeightUnit.grams) {
      result = _inputValue * 6350.29;
      unitSymbol = 'g';
    } else if (_inputUnit == WeightUnit.stones &&
        _outputUnit == WeightUnit.kilograms) {
      result = _inputValue * 6.35029;
      unitSymbol = 'kg';
    } else if (_inputUnit == WeightUnit.stones &&
        _outputUnit == WeightUnit.pounds) {
      result = _inputValue * 14;
      unitSymbol = 'lb';
    } else if (_inputUnit == WeightUnit.stones &&
        _outputUnit == WeightUnit.ounces) {
      result = _inputValue * 224;
      unitSymbol = 'oz';
    } else {
      result =
          _inputValue; // Conversion between the same unit, return the input value
    }

    setState(() {
      _outputValue = result;
      _unitSymbol = unitSymbol;
    });

    await saveConversionToFirestore(
      inputValue: _inputValue,
      inputUnit: _inputUnit.toString(),
      outputValue: _outputValue,
      outputUnit: _outputUnit.toString(),
      conversionType: 'Weight',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Weight Conversion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Convert Weight',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Value',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _inputValue = double.tryParse(value) ?? 0;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<WeightUnit>(
                    value: _inputUnit,
                    decoration: const InputDecoration(
                      labelText: 'From',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _inputUnit = value!;
                      });
                    },
                    items: WeightUnit.values.map((unit) {
                      return DropdownMenuItem<WeightUnit>(
                        value: unit,
                        child: Text(unit.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<WeightUnit>(
                    value: _outputUnit,
                    decoration: const InputDecoration(
                      labelText: 'To',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _outputUnit = value!;
                      });
                    },
                    items: WeightUnit.values.map((unit) {
                      return DropdownMenuItem<WeightUnit>(
                        value: unit,
                        child: Text(unit.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _convertWeight,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                minimumSize: const Size.fromHeight(50),
              ),
              child:
                  const Text('Convert', style: TextStyle(color: Colors.white)),
            ),
            ResultWidget(
              outputValue: _outputValue,
              unitSymbol: _unitSymbol,
            ),
          ],
        ),
      ),
    );
  }
}
