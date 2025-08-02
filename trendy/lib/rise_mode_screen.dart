import 'package:flutter/material.dart';

class RiseModeScreen extends StatelessWidget {
  const RiseModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rise Mode'),
      ),
      body: const Center(
        child: Text('Rise Mode Screen'),
      ),
    );
  }
}
