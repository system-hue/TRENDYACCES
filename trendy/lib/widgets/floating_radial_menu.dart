import 'package:flutter/material.dart';
import 'dart:math';

class FloatingRadialMenu extends StatefulWidget {
  final VoidCallback onMusicTap;
  final VoidCallback onMoviesTap;
  final VoidCallback onFootballTap;

  const FloatingRadialMenu({
    super.key,
    required this.onMusicTap,
    required this.onMoviesTap,
    required this.onFootballTap,
  });

  @override
  State<FloatingRadialMenu> createState() => _FloatingRadialMenuState();
}

class _FloatingRadialMenuState extends State<FloatingRadialMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Radial menu items
        ..._buildRadialMenuItems(),
        
        // Main FAB
        FloatingActionButton(
          onPressed: _toggleMenu,
          backgroundColor: Colors.deepPurple,
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _animationController,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildRadialMenuItems() {
    if (!_isOpen) return [];

    const double radius = 120;
    final List<Widget> items = [];

    final List<Map<String, dynamic>> menuItems = [
      {
        'icon': Icons.music_note,
        'label': 'Music',
        'color': Colors.blue,
        'angle': 0,
        'onTap': widget.onMusicTap,
      },
      {
        'icon': Icons.movie,
        'label': 'Movies',
        'color': Colors.red,
        'angle': 120,
        'onTap': widget.onMoviesTap,
      },
      {
        'icon': Icons.sports_soccer,
        'label': 'Football',
        'color': Colors.green,
        'angle': 240,
        'onTap': widget.onFootballTap,
      },
    ];

    for (int i = 0; i < menuItems.length; i++) {
      final double angle = menuItems[i]['angle'] * pi / 180;
      final double x = radius * cos(angle);
      final double y = radius * sin(angle);

      items.add(
        Positioned(
          bottom: 16 + y,
          right: 16 + x,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _animationController,
              curve: Interval(i * 0.1, 1.0, curve: Curves.elasticOut),
            ),
            child: FloatingActionButton(
              mini: true,
              backgroundColor: menuItems[i]['color'],
              onPressed: menuItems[i]['onTap'],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(menuItems[i]['icon'], size: 24),
                  Text(
                    menuItems[i]['label'],
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return items;
  }
}
