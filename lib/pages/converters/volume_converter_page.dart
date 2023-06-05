import 'package:flutter/material.dart';
import '../../public_helper_methods.dart';
import '../../widgets/result_widget.dart';

enum VolumeUnit {
  milliliters,
  liters,
  cubicCentimeters,
  cubicMeters,
  cubicInches,
  cubicFeet,
}

class VolumeConverterPage extends StatefulWidget {
  const VolumeConverterPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VolumeConverterPageState createState() => _VolumeConverterPageState();
}

class _VolumeConverterPageState extends State<VolumeConverterPage> {
  double _inputValue = 0;
  VolumeUnit _inputUnit = VolumeUnit.milliliters;
  VolumeUnit _outputUnit = VolumeUnit.liters;
  double _outputValue = 0;
  String _unitSymbol = '';

  Future<void> _convertVolume() async {
    double result;
    String unitSymbol = 'L'; // Default unit symbol for Liters

    if (_inputUnit == VolumeUnit.milliliters &&
        _outputUnit == VolumeUnit.liters) {
      result = _inputValue / 1000;
      unitSymbol = 'L';
    } else if (_inputUnit == VolumeUnit.milliliters &&
        _outputUnit == VolumeUnit.cubicCentimeters) {
      result = _inputValue;
      unitSymbol = 'cm³';
    } else if (_inputUnit == VolumeUnit.milliliters &&
        _outputUnit == VolumeUnit.cubicMeters) {
      result = _inputValue / 1000000;
      unitSymbol = 'm³';
    } else if (_inputUnit == VolumeUnit.liters &&
        _outputUnit == VolumeUnit.milliliters) {
      result = _inputValue * 1000;
      unitSymbol = 'mL';
    } else if (_inputUnit == VolumeUnit.liters &&
        _outputUnit == VolumeUnit.cubicCentimeters) {
      result = _inputValue * 1000;
      unitSymbol = 'cm³';
    } else if (_inputUnit == VolumeUnit.liters &&
        _outputUnit == VolumeUnit.cubicMeters) {
      result = _inputValue / 1000;
      unitSymbol = 'm³';
    } else if (_inputUnit == VolumeUnit.cubicCentimeters &&
        _outputUnit == VolumeUnit.milliliters) {
      result = _inputValue;
      unitSymbol = 'mL';
    } else if (_inputUnit == VolumeUnit.cubicCentimeters &&
        _outputUnit == VolumeUnit.liters) {
      result = _inputValue / 1000;
      unitSymbol = 'L';
    } else if (_inputUnit == VolumeUnit.cubicCentimeters &&
        _outputUnit == VolumeUnit.cubicMeters) {
      result = _inputValue / 1000000;
      unitSymbol = 'm³';
    } else if (_inputUnit == VolumeUnit.cubicMeters &&
        _outputUnit == VolumeUnit.milliliters) {
      result = _inputValue * 1000000;
      unitSymbol = 'mL';
    } else if (_inputUnit == VolumeUnit.cubicMeters &&
        _outputUnit == VolumeUnit.liters) {
      result = _inputValue * 1000;
      unitSymbol = 'L';
    } else if (_inputUnit == VolumeUnit.cubicMeters &&
        _outputUnit == VolumeUnit.cubicCentimeters) {
      result = _inputValue * 1000000;
      unitSymbol = 'cm³';
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
      conversionType: 'Volume',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        title: const Text('Volume Conversion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Convert Volume',
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
                  child: DropdownButtonFormField<VolumeUnit>(
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
                    items: VolumeUnit.values.map((unit) {
                      return DropdownMenuItem<VolumeUnit>(
                        value: unit,
                        child: Text(unit.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<VolumeUnit>(
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
                    items: VolumeUnit.values.map((unit) {
                      return DropdownMenuItem<VolumeUnit>(
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
              onPressed: _convertVolume,
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
