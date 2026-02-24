import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/math_engine.dart';
import '../services/attitude_service.dart';
import '../services/sensor_service.dart';
import '../widgets/glass_button.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _equation = "";
  String _result = "0";
  
  // Bring in our custom logic brains
  final MathEngine _mathEngine = MathEngine();
  final AttitudeService _attitudeService = AttitudeService();
  late SensorService _sensorService;

  @override
  void initState() {
    super.initState();
    // Initialize sensors and tell the screen to redraw when the device moves
    _sensorService = SensorService(onUpdate: _handleSensorUpdate);
  }

  void _handleSensorUpdate() {
    // If the accelerometer detects a hard shake, clear the screen!
    if (_sensorService.isShaking && _equation.isNotEmpty) {
      HapticFeedback.heavyImpact(); // Big vibration
      _clearAll();
    } else {
      // Otherwise, just redraw the screen so the background gradient shifts
      setState(() {});
    }
  }

  @override
  void dispose() {
    _sensorService.dispose();
    super.dispose();
  }

  void _clearAll() {
    setState(() {
      _equation = "";
      _result = "0";
    });
  }

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _clearAll();
      } else if (buttonText == "=") {
        // 1. Check if the app wants to be sassy instead of doing math
        String? sass = _attitudeService.tryGetSass();
        if (sass != null) {
          _result = sass; // Show the funny quote
          _equation = ""; // Clear the equation
          HapticFeedback.vibrate(); // Long vibration for attitude
        } else {
          // 2. No sass? Calculate normally.
          _result = _mathEngine.calculate(_equation);
          _equation = _result; // Move result up to equation for continuous math
        }
      } else {
        // Standard number or operator press
        _equation += buttonText;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use the gyroscope tilt to slightly shift the background colors
    double bgAlignmentX = _sensorService.tiltX;
    double bgAlignmentY = _sensorService.tiltY;

    return Scaffold(
      body: Stack(
        children: [
          // 1. The Dynamic Liquid Background
          AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(bgAlignmentX, bgAlignmentY),
                radius: 1.5,
                colors: const [
                  Color(0xFF2A0845), // Deep Purple
                  Color(0xFF6441A5), // Bright Violet
                  Color(0xFF000000), // Black edges
                ],
              ),
            ),
          ),
          
          // 2. The Calculator Foreground
          SafeArea(
            child: Column(
              children: [
                // Display Area
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    alignment: Alignment.bottomRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _equation,
                          style: TextStyle(fontSize: 24, color: Colors.white.withOpacity(0.7)),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _result,
                          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Keypad Area
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: GridView.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.1,
                      children: [
                        "C", "÷", "×", "⌫",
                        "7", "8", "9", "-",
                        "4", "5", "6", "+",
                        "1", "2", "3", "=",
                        "%", "0", ".",
                      ].map((text) {
                        return GlassButton(
                          text: text,
                          isAccent: text == "=" || text == "C",
                          textColor: (text == "÷" || text == "×" || text == "-" || text == "+") 
                              ? Colors.pinkAccent 
                              : Colors.white,
                          onTap: () => _buttonPressed(text == "⌫" ? "BACK" : text),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

