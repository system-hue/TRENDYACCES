import 'package:flutter/material.dart';
import 'dart:math';

class FloatingRadialMenu extends StatefulWidget {
  const FloatingRadialMenu({super.key});

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
      children: [
        // Main FAB
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: _toggleMenu,
            backgroundColor: Colors.deepPurple,
            child: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: _animationController,
            ),
          ),
        ),

        // Radial menu items
        if (_isOpen) ...[
          _buildRadialButton(
            context,
            icon: Icons.sports_basketball,
            label: 'Sports',
            color: Colors.orange,
            angle: 0,
            routeName: '/sports',
          ),
          _buildRadialButton(
            context,
            icon: Icons.movie,
            label: 'Movies',
            color: Colors.red,
            angle: 72,
            routeName: '/movies',
          ),
          _buildRadialButton(
            context,
            icon: Icons.music_note,
            label: 'Music',
            color: Colors.blue,
            angle: 144,
            routeName: '/music',
          ),
          _buildRadialButton(
            context,
            icon: Icons.article,
            label: 'News',
            color: Colors.green,
            angle: 216,
            routeName: '/news',
          ),
          _buildRadialButton(
            context,
            icon: Icons.flag,
            label: 'Goals',
            color: Colors.purple,
            angle: 288,
            routeName: '/goals',
          ),
        ],
      ],
    );
  }

  Widget _buildRadialButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required double angle,
    required String routeName,
  }) {
    final double radius = 100;
    final double x = radius * cos(angle * pi / 180);
    final double y = radius * sin(angle * pi / 180);

    return Positioned(
      bottom: 20 + y,
      right: 20 + x,
      child: Tooltip(
        message: label,
        child: FloatingActionButton(
          mini: true,
          backgroundColor: color,
          onPressed: () => Navigator.of(context).pushNamed(routeName),
          child: Icon(icon, size: 20),
        ),
      ),
    );
  }
}
