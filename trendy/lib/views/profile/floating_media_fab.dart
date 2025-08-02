import 'package:flutter/material.dart';

class FloatingMediaFab extends StatefulWidget {
  const FloatingMediaFab({super.key});

  @override
  State<FloatingMediaFab> createState() => _FloatingMediaFabState();
}

class _FloatingMediaFabState extends State<FloatingMediaFab> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleFab() {
    if (_animationController.isDismissed) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Transform.scale(
          scale: _animation.value,
          child: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.music_note),
          ),
        ),
        const SizedBox(height: 16),
        Transform.scale(
          scale: _animation.value,
          child: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.movie),
          ),
        ),
        const SizedBox(height: 16),
        Transform.scale(
          scale: _animation.value,
          child: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.sports_soccer),
          ),
        ),
        const SizedBox(height: 16),
        Transform.scale(
          scale: _animation.value,
          child: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.psychology),
          ),
        ),
        const SizedBox(height: 16),
        FloatingActionButton(
          onPressed: _toggleFab,
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _animation,
          ),
        ),
      ],
    );
  }
}
