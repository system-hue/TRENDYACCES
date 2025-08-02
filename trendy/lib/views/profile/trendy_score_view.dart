import 'package:flutter/material.dart';

class TrendyScoreView extends StatelessWidget {
  const TrendyScoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star,
            size: 100,
            color: Colors.amber,
          ),
          SizedBox(height: 16),
          Text(
            'Gold',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Your Trendy Score is 8.5',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
