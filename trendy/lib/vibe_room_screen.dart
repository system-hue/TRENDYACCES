import 'package:flutter/material.dart';

class VibeRoomScreen extends StatelessWidget {
  const VibeRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vibe Room'),
      ),
      body: const Center(
        child: Text('Vibe Room Screen'),
      ),
    );
  }
}
