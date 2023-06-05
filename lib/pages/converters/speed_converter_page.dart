import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../public_helper_methods.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

enum SpeedUnit {
  MilesPerHour,
  KilometersPerHour,
  MetersPerSecond,
}

class SpeedConverterPage extends StatefulWidget {
  const SpeedConverterPage({Key? key}) : super(key: key);

  @override
  _SpeedConverterPageState createState() => _SpeedConverterPageState();
}

class _SpeedConverterPageState extends State<SpeedConverterPage> {
  double _inputValue = 0;
  SpeedUnit _inputUnit = SpeedUnit.MilesPerHour;
  SpeedUnit _outputUnit = SpeedUnit.KilometersPerHour;
  double _outputValue = 0;
  String _unitSymbol = '';

  Future<void> _convertSpeed() async {
    double result;
    String inputUnitSymbol = '';
    String outputUnitSymbol = '';

    if (_inputUnit == SpeedUnit.MilesPerHour &&
        _outputUnit == SpeedUnit.KilometersPerHour) {
      result = _inputValue * 1.60934;
      inputUnitSymbol = 'mph';
      outputUnitSymbol = 'km/h';
    } else if (_inputUnit == SpeedUnit.MilesPerHour &&
        _outputUnit == SpeedUnit.MetersPerSecond) {
      result = _inputValue * 0.44704;
      inputUnitSymbol = 'mph';
      outputUnitSymbol = 'm/s';
    } else if (_inputUnit == SpeedUnit.KilometersPerHour &&
        _outputUnit == SpeedUnit.MilesPerHour) {
      result = _inputValue * 0.621371;
      inputUnitSymbol = 'km/h';
      outputUnitSymbol = 'mph';
    } else if (_inputUnit == SpeedUnit.KilometersPerHour &&
        _outputUnit == SpeedUnit.MetersPerSecond) {
      result = _inputValue * 0.277778;
      inputUnitSymbol = 'km/h';
      outputUnitSymbol = 'm/s';
    } else if (_inputUnit == SpeedUnit.MetersPerSecond &&
        _outputUnit == SpeedUnit.MilesPerHour) {
      result = _inputValue * 2.23694;
      inputUnitSymbol = 'm/s';
      outputUnitSymbol = 'mph';
    } else if (_inputUnit == SpeedUnit.MetersPerSecond &&
        _outputUnit == SpeedUnit.KilometersPerHour) {
      result = _inputValue * 3.6;
      inputUnitSymbol = 'm/s';
      outputUnitSymbol = 'km/h';
    } else {
      result = _inputValue;
      inputUnitSymbol = '';
      outputUnitSymbol = '';
    }

    setState(() {
      _outputValue = result;
      _unitSymbol = outputUnitSymbol;
    });

    await saveConversionToFirestore(
      inputValue: _inputValue,
      inputUnit: inputUnitSymbol,
      outputValue: _outputValue,
      outputUnit: outputUnitSymbol,
      conversionType: 'Speed',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Speed Conversion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Convert Speed',
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
                  child: DropdownButtonFormField<SpeedUnit>(
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
                    items: SpeedUnit.values.map((unit) {
                      return DropdownMenuItem<SpeedUnit>(
                        value: unit,
                        child: Text(unit.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<SpeedUnit>(
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
                    items: SpeedUnit.values.map((unit) {
                      return DropdownMenuItem<SpeedUnit>(
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
              onPressed: _convertSpeed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                minimumSize: const Size.fromHeight(50),
              ),
              child:
                  const Text('Convert', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 32),
            Text(
              'Result: $_outputValue $_unitSymbol',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
