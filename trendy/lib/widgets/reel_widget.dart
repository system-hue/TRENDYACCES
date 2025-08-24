import 'package:flutter/material.dart';

class ReelWidget extends StatelessWidget {
  final int reelId;
  final String thumbnailUrl;
  final int views;

  const ReelWidget({
    Key? key,
    required this.reelId,
    required this.thumbnailUrl,
    required this.views,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(thumbnailUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${views ~/ 1000}K views',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
