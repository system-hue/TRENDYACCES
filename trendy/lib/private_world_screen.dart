import 'package:flutter/material.dart';

class PrivateWorldScreen extends StatelessWidget {
  const PrivateWorldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Private World'),
      ),
      body: const Center(
        child: Text('Private World Screen'),
      ),
    );
  }
}
