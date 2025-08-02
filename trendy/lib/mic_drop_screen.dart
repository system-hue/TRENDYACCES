import 'package:flutter/material.dart';

class MicDropScreen extends StatelessWidget {
  const MicDropScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MicDrop'),
      ),
      body: const Center(
        child: Text('MicDrop Screen'),
      ),
    );
  }
}
