import 'package:flutter/material.dart';

class StoryWidget extends StatelessWidget {
  final String title;

  const StoryWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(title, style: TextStyle(fontSize: 16)),
    );
  }
}
