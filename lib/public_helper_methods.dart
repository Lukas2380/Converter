import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

String formatDecimalValue(double value) {
  String formattedValue = value.toString();
  if (formattedValue.contains('.')) {
    while (formattedValue.endsWith('0')) {
      formattedValue = formattedValue.substring(0, formattedValue.length - 1);
    }
    if (formattedValue.endsWith('.')) {
      formattedValue = formattedValue.substring(0, formattedValue.length - 1);
    }
  }
  if (formattedValue.contains('.')) {
    formattedValue = double.parse(formattedValue).toStringAsFixed(4);
  }
  return formattedValue;
}

Future<void> saveConversionToFirestore({
  required double inputValue,
  required String inputUnit,
  required double outputValue,
  required String outputUnit,
  required String conversionType,
}) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('conversions').add({
      'userId': user?.uid,
      'inputValue': formatDecimalValue(inputValue),
      'inputUnit': inputUnit,
      'outputValue': formatDecimalValue(outputValue),
      'outputUnit': outputUnit,
      'conversionType': conversionType,
      'timestamp': Timestamp.now(),
    });
  } catch (e) {
    // Handle error
  }
}

Future<void> deleteConversionFromFirestore(String conversionId) async {
  try {
    await FirebaseFirestore.instance
        .collection('conversions')
        .doc(conversionId)
        .delete();
  } catch (e) {
    // Handle error
  }
}

Color getCardColor(String unit) {
  switch (unit) {
    case 'Temperature':
      return Colors.blue; // Set the color for temperature conversion
    case 'Speed':
      return Colors.green; // Set the color for speed conversion
    case 'Time':
      return Colors.orange; // Set the color for time conversion
    case 'Weight':
      return Colors.red; // Set the color for weight conversion
    case 'Volume':
      return Colors.purple; // Set the color for volume conversion
    case 'Currency':
      return Colors.cyan; // Set the color for currency conversion
    default:
      return Colors.white; // Set a default color if needed
  }
}

Color getTextColor(String unit) {
  switch (unit) {
    case 'Temperature':
      return Colors.white; // Set the text color for temperature conversion
    case 'Speed':
      return Colors.white; // Set the text color for speed conversion
    case 'Time':
      return Colors.black; // Set the text color for time conversion
    case 'Weight':
      return Colors.white; // Set the text color for weight conversion
    case 'Volume':
      return Colors.white; // Set the text color for volume conversion
    case 'Currency':
      return Colors.black; // Set the text color for currency conversion
    default:
      return Colors.black; // Set a default text color if needed
  }
}
