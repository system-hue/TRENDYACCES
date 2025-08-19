import 'package:flutter/material.dart';
import 'dart:math';

class HubFloatingMenu extends StatefulWidget {
  const HubFloatingMenu({super.key});

  @override
  State<HubFloatingMenu> createState() => _HubFloatingMenuState();
}

class _HubFloatingMenuState extends State<HubFloatingMenu>
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
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        fit: StackFit.loose,
        alignment: Alignment.bottomRight,
        children: [
          ..._buildRadialMenuItems(),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: _toggleMenu,
              backgroundColor: const Color(0xFF6C5CE7),
              child: AnimatedIcon(
                icon: AnimatedIcons.menu_close,
                progress: _animationController,
              ),
            ),
          ),
        ],
      ),
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
        'color': const Color(0xFF6C5CE7),
        'angle': 0,
        'route': '/music',
      },
      {
        'icon': Icons.movie,
        'label': 'Movies',
        'color': const Color(0xFF00D1B2),
        'angle': 72,
        'route': '/movies',
      },
      {
        'icon': Icons.sports_soccer,
        'label': 'Football',
        'color': const Color(0xFF22C55E),
        'angle': 144,
        'route': '/football',
      },
    ];

    for (int i = 0; i < menuItems.length; i++) {
      final double angle = menuItems[i]['angle'] * pi / 180;
      final double x = radius * cos(angle);
      final double y = radius * sin(angle);

      items.add(
        Positioned(
          bottom: 20 + y,
          right: 20 + x,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _animationController,
              curve: Interval(i * 0.1, 1.0, curve: Curves.elasticOut),
            ),
            child: FloatingActionButton(
              mini: true,
              backgroundColor: menuItems[i]['color'],
              onPressed: () {
                Navigator.of(context).pushNamed(menuItems[i]['route']);
                _toggleMenu();
              },
              child: Icon(menuItems[i]['icon'], size: 24),
            ),
          ),
        ),
      );
    }

    return items;
  }
}
