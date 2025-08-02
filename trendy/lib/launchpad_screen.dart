import 'package:flutter/material.dart';

class LaunchpadScreen extends StatelessWidget {
  const LaunchpadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Launchpad'),
      ),
      body: const Center(
        child: Text('Launchpad Screen'),
      ),
    );
  }
}
