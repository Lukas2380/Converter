import 'package:flutter/material.dart';

import '../../public_helper_methods.dart';
import '../../widgets/result_widget.dart';

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CurrencyConverterPageState createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  double _inputValue = 0;
  String _inputCurrency = 'Euro';
  String _outputCurrency = 'Dollar';
  double _outputValue = 0;

  final Map<String, double> currencyRates = {
    'Euro': 1.0,
    'Dollar': 1.18, // Conversion rate from Euro to Dollar
    'Pound': 0.85, // Conversion rate from Euro to Pound
  };

  void _convertCurrency() async {
    double result = (_inputValue / currencyRates[_inputCurrency]!) *
        currencyRates[_outputCurrency]!;
    setState(() {
      _outputValue = double.parse(result.toStringAsFixed(4));
    });

    await saveConversionToFirestore(
      inputValue: _inputValue,
      inputUnit: _inputCurrency,
      outputValue: _outputValue,
      outputUnit: _outputCurrency,
      conversionType: 'Currency',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text('Currency Conversion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Convert Currency',
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
                  child: DropdownButtonFormField<String>(
                    value: _inputCurrency,
                    decoration: const InputDecoration(
                      labelText: 'From',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _inputCurrency = value!;
                      });
                    },
                    items: currencyRates.keys.map((currency) {
                      return DropdownMenuItem<String>(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                    value: _outputCurrency,
                    decoration: const InputDecoration(
                      labelText: 'To',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _outputCurrency = value!;
                      });
                    },
                    items: currencyRates.keys.map((currency) {
                      return DropdownMenuItem<String>(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _convertCurrency,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                minimumSize: const Size.fromHeight(50),
              ),
              child:
                  const Text('Convert', style: TextStyle(color: Colors.white)),
            ),
            ResultWidget(
              outputValue: _outputValue,
              unitSymbol: _outputCurrency,
            ),
          ],
        ),
      ),
    );
  }
}
