import 'package:flutter/material.dart';
import 'package:trendy/views/discover/discover_grid.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final List<String> _filters = ['Music', 'Movies', 'Football', 'Fashion'];
  final List<String> _selectedFilters = [];
  final List<String> _liveCategories = ['#UCL', '#TaylorSwift', '#MCU', '#MetGala'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextField(
          decoration: InputDecoration(
            hintText: 'Search...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
      body: Column(
        children: [
          Wrap(
            spacing: 8.0,
            children: _filters.map((filter) {
              return FilterChip(
                label: Text(filter),
                selected: _selectedFilters.contains(filter),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedFilters.add(filter);
                    } else {
                      _selectedFilters.remove(filter);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _liveCategories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Chip(
                    label: Text(_liveCategories[index]),
                  ),
                );
              },
            ),
          ),
          const Expanded(
            child: DiscoverGrid(),
          ),
        ],
      ),
    );
  }
}
