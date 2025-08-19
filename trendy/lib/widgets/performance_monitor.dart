import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trendy/services/performance_service_updated.dart';

class PerformanceMonitor extends StatefulWidget {
  final Widget child;
  final bool showOverlay;

  const PerformanceMonitor({
    super.key,
    required this.child,
    this.showOverlay = kDebugMode,
  });

  @override
  State<PerformanceMonitor> createState() => _PerformanceMonitorState();
}

class _PerformanceMonitorState extends State<PerformanceMonitor> {
  bool _showStats = false;
  Map<String, dynamic> _performanceStats = {};

  @override
  void initState() {
    super.initState();
    if (widget.showOverlay) {
      _updateStats();
    }
  }

  void _updateStats() {
    setState(() {
      _performanceStats = PerformanceService().getPerformanceStats();
    });
    Future.delayed(const Duration(seconds: 2), _updateStats);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showOverlay) return widget.child;

    return Stack(
      children: [
        widget.child,
        if (_showStats)
          Positioned(
            top: 50,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Performance Stats',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  ..._performanceStats.entries.map(
                    (entry) => Text(
                      '${entry.key}: ${entry.value}',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            mini: true,
            onPressed: () {
              setState(() {
                _showStats = !_showStats;
              });
            },
            child: const Icon(Icons.speed),
          ),
        ),
      ],
    );
  }
}
