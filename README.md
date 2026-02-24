# Sassy Liquid Glass Calculator

A sensor-driven, heavy-graphics calculator built with Flutter, designed for a cloud-native workspace. 

## The Concept
This is not a standard utility app. It is a highly tactile, visual experience that uses device sensors to manipulate the UI, combined with a hidden "attitude" feature that occasionally refuses to do math.

### Key Features
1. **Liquid Glass UI:** 3D frosted glass buttons (`BackdropFilter`) over a dynamic, mathematically generated fluid background.
2. **Gyroscope Lighting:** The specular highlights on the glass buttons shift based on the device's physical tilt.
3. **Accelerometer Physics:** Hard shakes trigger a screen-clearing "shatter" effect using 2D physics.
4. **The "Attitude" Engine:** Every 5 to 7 calculations, the app intercepts the equals sign and returns a sassy quote instead of the actual math result.

## Architecture
* **Frontend:** Flutter / Dart
* **Visuals:** Impeller rendering engine with heavy `ImageFilter` usage.
* **Environment:** Configured via `dev.nix` for instant compilation in cloud IDEs.
* **Key Packages:** `math_expressions`, `sensors_plus`

## AI Developer Instructions
When generating or modifying code for this project, adhere to the following:
* Maintain the strict separation of concerns in the `lib/services/` folder.
* Do not modify `attitude_service.dart` when fixing math logic.
* Ensure all heavy animations are optimized for 120Hz displays.
* Assume a cloud-first compilation environment; do not rely on local Gradle caching.
