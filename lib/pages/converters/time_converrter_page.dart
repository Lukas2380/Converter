import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../public_helper_methods.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

enum TimeUnit {
  Seconds,
  Minutes,
  Hours,
}

class TimeConverterPage extends StatefulWidget {
  const TimeConverterPage({Key? key}) : super(key: key);

  @override
  _TimeConverterPageState createState() => _TimeConverterPageState();
}

class _TimeConverterPageState extends State<TimeConverterPage> {
  double _inputValue = 0;
  TimeUnit _inputUnit = TimeUnit.Seconds;
  TimeUnit _outputUnit = TimeUnit.Minutes;
  double _outputValue = 0;
  String _unitSymbol = '';

  Future<void> _convertTime() async {
    double result;
    String unitSymbol = 'min'; // Default unit symbol for Minutes

    if (_inputUnit == TimeUnit.Seconds && _outputUnit == TimeUnit.Minutes) {
      result = _inputValue / 60;
      unitSymbol = 'min';
    } else if (_inputUnit == TimeUnit.Seconds &&
        _outputUnit == TimeUnit.Hours) {
      result = _inputValue / 3600;
      unitSymbol = 'hr';
    } else if (_inputUnit == TimeUnit.Minutes &&
        _outputUnit == TimeUnit.Seconds) {
      result = _inputValue * 60;
      unitSymbol = 's';
    } else if (_inputUnit == TimeUnit.Minutes &&
        _outputUnit == TimeUnit.Hours) {
      result = _inputValue / 60;
      unitSymbol = 'hr';
    } else if (_inputUnit == TimeUnit.Hours &&
        _outputUnit == TimeUnit.Seconds) {
      result = _inputValue * 3600;
      unitSymbol = 's';
    } else if (_inputUnit == TimeUnit.Hours &&
        _outputUnit == TimeUnit.Minutes) {
      result = _inputValue * 60;
      unitSymbol = 'min';
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
      conversionType: 'Time',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Time Conversion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Convert Time',
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
                  child: DropdownButtonFormField<TimeUnit>(
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
                    items: TimeUnit.values.map((unit) {
                      return DropdownMenuItem<TimeUnit>(
                        value: unit,
                        child: Text(unit.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<TimeUnit>(
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
                    items: TimeUnit.values.map((unit) {
                      return DropdownMenuItem<TimeUnit>(
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
              onPressed: _convertTime,
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
