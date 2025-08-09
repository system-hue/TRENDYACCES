import 'package:flutter/material.dart';

class OnboardingItem {
  final String title;
  final String description;
  final String imagePath;
  final Color color;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.color,
  });

  static List<OnboardingItem> get items => [
    OnboardingItem(
      title: 'Music Streaming',
      description:
          'Discover and stream millions of songs from your favorite artists',
      imagePath: 'assets/images/music_onboarding.png',
      color: const Color(0xFF9C27B0),
    ),
    OnboardingItem(
      title: 'Live Calls & Chats',
      description:
          'Connect with friends through high-quality video calls and messaging',
      imagePath: 'assets/images/calls_onboarding.png',
      color: const Color(0xFF2196F3),
    ),
    OnboardingItem(
      title: 'Movies & Sports',
      description:
          'Watch trending movies and get live sports updates all in one place',
      imagePath: 'assets/images/movies_onboarding.png',
      color: const Color(0xFFFF9800),
    ),
  ];
}
