import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

class SensorService {
  // Streams to listen to the physical hardware
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;

  // Variables to hold the current movement data
  double tiltX = 0.0;
  double tiltY = 0.0;
  bool isShaking = false;

  // A callback function to tell the UI to redraw the graphics when the device moves
  final Function onUpdate;

  SensorService({required this.onUpdate}) {
    _initSensors();
  }

  void _initSensors() {
    // 1. Listen to Gyroscope for the 3D Liquid Glass tilt effect
    _gyroscopeSubscription = gyroscopeEventStream().listen((GyroscopeEvent event) {
      // Adjusting the multiplier (0.05) controls how "slick" the lighting feels 
      // when you tilt the device in your hands.
      tiltX += event.y * 0.05;
      tiltY += event.x * 0.05;
      
      // Clamp the values so the glass highlight doesn't slide completely off the screen
      tiltX = tiltX.clamp(-1.0, 1.0);
      tiltY = tiltY.clamp(-1.0, 1.0);
      
      onUpdate(); // Tell the UI to redraw
    });

    // 2. Listen to Accelerometer for "Shake to Clear" or "Shatter" physics
    _accelerometerSubscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      // Calculate the total force of the physical movement
      double force = event.x.abs() + event.y.abs() + event.z.abs();
      
      // Standard resting gravity is around 9.8. If force spikes over 20, it's a hard shake.
      if (force > 20.0) {
        isShaking = true;
        onUpdate();
        
        // Reset the shake state quickly so it can trigger again
        Future.delayed(const Duration(milliseconds: 500), () {
          isShaking = false;
          onUpdate();
        });
      }
    });
  }

  // Clean up the sensors when the app closes to save battery
  void dispose() {
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
  }
}

