import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:converter/pages/converters/temperature_converter_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../public_helper_methods.dart';
import 'converters/currency_converter_page.dart';
import 'converters/speed_converter_page.dart';
import 'converters/time_converrter_page.dart';
import 'converters/volume_converter_page.dart';
import 'converters/weight_converter_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      // Handle sign-out error
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final conversionsRef = FirebaseFirestore.instance
        .collection('conversions')
        .where('userId', isEqualTo: user?.uid)
        .orderBy('timestamp', descending: true);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8), // Set the desired padding value
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ConversionButton(
                  icon: Icons.ac_unit,
                  label: 'Temperature',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TemperatureConverterPage(),
                      ),
                    );
                  },
                  color: Colors.blue, // Set the color for temperature button
                ),
                ConversionButton(
                  icon: Icons.speed,
                  label: 'Speed',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SpeedConverterPage(),
                      ),
                    );
                  },
                  color: Colors.green, // Set the color for speed button
                ),
                ConversionButton(
                  icon: Icons.timer,
                  label: 'Time',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TimeConverterPage(),
                      ),
                    );
                  },
                  color: Colors.orange, // Set the color for time button
                ),
                ConversionButton(
                  icon: Icons.fitness_center,
                  label: 'Weight',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WeightConverterPage(),
                      ),
                    );
                  },
                  color: Colors.red, // Set the color for weight button
                ),
                ConversionButton(
                  icon: Icons.opacity,
                  label: 'Volume',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VolumeConverterPage(),
                      ),
                    );
                  },
                  color: Colors.purpleAccent, // Set the color for volume button
                ),
                ConversionButton(
                  icon: Icons.money,
                  label: 'Currency',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CurrencyConverterPage(),
                      ),
                    );
                  },
                  color: Colors.cyan, // Set the color for currency button
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Recent Conversions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 30, 5, 5),
              child: StreamBuilder<QuerySnapshot>(
                stream: conversionsRef.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Error loading Recent conversions');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  final conversions = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: conversions.length,
                    itemBuilder: (context, index) {
                      final conversion = conversions[index];
                      final inputValue = conversion['inputValue'];
                      final inputUnit =
                          conversion['inputUnit'].toString().split('.').last;
                      final outputValue = conversion['outputValue'];
                      final outputUnit =
                          conversion['outputUnit'].toString().split('.').last;
                      final timestamp = conversion['timestamp']?.toDate();
                      final conversionType =
                          conversion['conversionType'].toString();
                      Color? color; // Define color variable

                      // Assign color based on the conversion type
                      switch (conversionType) {
                        case 'TemperatureUnit':
                          color = Colors.blue;
                          break;
                        case 'SpeedUnit':
                          color = Colors.green;
                          break;
                        case 'TimeUnit':
                          color = Colors.brown;
                          break;
                        case 'WeightUnit':
                          color = Colors.red;
                          break;
                        case 'VolumeUnit':
                          color = Colors.purpleAccent;
                          break;
                        case 'CurrencyUnit':
                          color = Colors.teal;
                          break;
                      }

                      return Dismissible(
                          key: Key(conversion.id),
                          direction: DismissDirection.horizontal,
                          background: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          onDismissed: (direction) {
                            deleteConversionFromFirestore(conversion.id);
                          },
                          child: Card(
                            elevation: 2,
                            color: getCardColor(
                                conversionType), // Set the background color based on conversion type
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 20, 10, 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '$inputValue $inputUnit',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: getTextColor(
                                              inputUnit), // Set the text color based on conversion type
                                        ),
                                      ),
                                      const Text(
                                        '=',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        '$outputValue $outputUnit',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: getTextColor(
                                              outputUnit), // Set the text color based on conversion type
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 30),
                                  Text(
                                    'Time: ${timestamp.toString().replaceRange(19, null, '')}',
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'Swipe to remove',
                                        style: TextStyle(
                                          color: Colors.black45,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ));
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ConversionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const ConversionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color, // Set the background color for the button
          borderRadius:
              BorderRadius.circular(8), // Adjust the border radius as desired
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}
