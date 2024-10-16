import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final int index;

  const Tile({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    // Customize the content of your Tile widget here
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.teal[(index % 9) * 100], // Just an example for color based on index
      child: Center(
        child: Text(
          'Item $index',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
