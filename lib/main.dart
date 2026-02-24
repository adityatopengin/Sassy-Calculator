import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/calculator_screen.dart';

void main() {
  // Ensure the app binds to the device properly before locking orientation
  WidgetsFlutterBinding.ensureInitialized();
  
  // Lock the app to portrait mode for consistent physics and sensors
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const SassyCalculatorApp());
  });
}

class SassyCalculatorApp extends StatelessWidget {
  const SassyCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sassy Glass Calculator',
      debugShowCheckedModeBanner: false,
      // We use a dark theme to make the neon/liquid glass effects pop
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const CalculatorScreen(),
    );
  }
}

