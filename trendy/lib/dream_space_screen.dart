import 'package:flutter/material.dart';

class DreamSpaceScreen extends StatelessWidget {
  const DreamSpaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DreamSpace'),
      ),
      body: const Center(
        child: Text('DreamSpace Screen'),
      ),
    );
  }
}
