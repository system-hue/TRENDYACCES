import 'package:flutter/material.dart';

class LiveArenasScreen extends StatelessWidget {
  const LiveArenasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Arenas'),
      ),
      body: const Center(
        child: Text('Live Arenas Screen'),
      ),
    );
  }
}
