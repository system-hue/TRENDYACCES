import 'package:flutter/material.dart';

class InteractiveOrb extends StatefulWidget {
  final double initialX;
  final double initialY;

  const InteractiveOrb({
    super.key,
    required this.initialX,
    required this.initialY,
  });

  @override
  State<InteractiveOrb> createState() => _InteractiveOrbState();
}

class _InteractiveOrbState extends State<InteractiveOrb> {
  late double x;
  late double y;

  @override
  void initState() {
    super.initState();
    x = widget.initialX;
    y = widget.initialY;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: Draggable(
        feedback: Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
        ),
        childWhenDragging: Container(),
        onDragEnd: (details) {
          setState(() {
            x = details.offset.dx;
            y = details.offset.dy;
          });
        },
        child: Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
