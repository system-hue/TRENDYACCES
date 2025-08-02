import 'dart:ui';
import 'package:flutter/material.dart';

class DiscoverGrid extends StatefulWidget {
  const DiscoverGrid({super.key});

  @override
  State<DiscoverGrid> createState() => _DiscoverGridState();
}

class _DiscoverGridState extends State<DiscoverGrid> {
  final List<bool> _isHovering = List.generate(20, (index) => false);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: 20,
      itemBuilder: (context, index) {
        return MouseRegion(
          onEnter: (_) => _onHover(index, true),
          onExit: (_) => _onHover(index, false),
          child: Card(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  'https://picsum.photos/200/300?random=$index',
                  fit: BoxFit.cover,
                ),
                if (_isHovering[index])
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      color: Colors.black.withAlpha(77),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.favorite, color: Colors.white),
                            SizedBox(width: 8),
                            Text('1.2k', style: TextStyle(color: Colors.white)),
                            SizedBox(width: 16),
                            Icon(Icons.comment, color: Colors.white),
                            SizedBox(width: 8),
                            Text('345', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onHover(int index, bool isHovering) {
    setState(() {
      _isHovering[index] = isHovering;
    });
  }
}
