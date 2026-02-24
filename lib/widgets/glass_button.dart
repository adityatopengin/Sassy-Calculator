import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GlassButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color textColor;
  final bool isAccent;

  const GlassButton({
    super.key,
    required this.text,
    required this.onTap,
    this.textColor = Colors.white,
    this.isAccent = false,
  });

  @override
  Widget build(BuildContext context) {
    // GestureDetector catches the tap and allows us to trigger haptic feedback
    return GestureDetector(
      onTap: () {
        // Trigger a light tactile vibration when the button is pressed
        HapticFeedback.lightImpact();
        onTap();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          // The magic blur effect that creates the "frosted glass" look
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              // If it's an accent button (like '='), give it a slight neon tint
              color: isAccent 
                  ? Colors.pinkAccent.withOpacity(0.2) 
                  : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
              // The shiny "bezel" edge of the glass
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

