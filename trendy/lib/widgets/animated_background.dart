import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> {
  Color _getBackgroundColor() {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) {
      // Morning
      return Colors.yellow.shade200;
    } else if (hour >= 12 && hour < 18) {
      // Afternoon
      return Colors.orange.shade200;
    } else {
      // Evening
      return Colors.blue.shade900;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _getBackgroundColor(),
            Colors.black,
          ],
        ),
      ),
    );
  }
}
