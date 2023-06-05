import 'package:flutter/material.dart';

import '../../public_helper_methods.dart';
import '../../widgets/result_widget.dart';

enum TemperatureUnit {
  celsius,
  fahrenheit,
  kelvin,
}

class TemperatureConverterPage extends StatefulWidget {
  const TemperatureConverterPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TemperatureConverterPageState createState() =>
      _TemperatureConverterPageState();
}

class _TemperatureConverterPageState extends State<TemperatureConverterPage> {
  double _inputValue = 0;
  TemperatureUnit _inputUnit = TemperatureUnit.celsius;
  TemperatureUnit _outputUnit = TemperatureUnit.fahrenheit;
  double _outputValue = 0;
  String _unitSymbol = '';

  Future<void> _convertTemperature() async {
    double result;
    String unitSymbol = '°F'; // Default unit symbol for Fahrenheit

    if (_inputUnit == TemperatureUnit.celsius &&
        _outputUnit == TemperatureUnit.fahrenheit) {
      result = (_inputValue * 9 / 5) + 32;
      unitSymbol = '°F';
    } else if (_inputUnit == TemperatureUnit.celsius &&
        _outputUnit == TemperatureUnit.kelvin) {
      result = _inputValue + 273.15;
      unitSymbol = 'K';
    } else if (_inputUnit == TemperatureUnit.fahrenheit &&
        _outputUnit == TemperatureUnit.celsius) {
      result = (_inputValue - 32) * 5 / 9;
      unitSymbol = '°C';
    } else if (_inputUnit == TemperatureUnit.fahrenheit &&
        _outputUnit == TemperatureUnit.kelvin) {
      result = (_inputValue + 459.67) * 5 / 9;
      unitSymbol = 'K';
    } else if (_inputUnit == TemperatureUnit.kelvin &&
        _outputUnit == TemperatureUnit.celsius) {
      result = _inputValue - 273.15;
      unitSymbol = '°C';
    } else if (_inputUnit == TemperatureUnit.kelvin &&
        _outputUnit == TemperatureUnit.fahrenheit) {
      result = (_inputValue * 9 / 5) - 459.67;
      unitSymbol = '°F';
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
      conversionType: 'Temperature',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Temperature Conversion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Convert Temperature',
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
                  child: DropdownButtonFormField<TemperatureUnit>(
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
                    items: TemperatureUnit.values.map((unit) {
                      return DropdownMenuItem<TemperatureUnit>(
                        value: unit,
                        child: Text(unit.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<TemperatureUnit>(
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
                    items: TemperatureUnit.values.map((unit) {
                      return DropdownMenuItem<TemperatureUnit>(
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
              onPressed: _convertTemperature,
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
