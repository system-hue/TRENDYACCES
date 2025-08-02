import 'package:flutter/material.dart';
import 'package:countup/countup.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem('Followers', 10200),
        _buildStatItem('Following', 543),
        _buildStatItem('Likes', 1200000),
      ],
    );
  }

  Widget _buildStatItem(String label, double value) {
    return Column(
      children: [
        Countup(
          begin: 0,
          end: value,
          duration: const Duration(seconds: 3),
          separator: ',',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
