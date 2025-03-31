import 'package:flutter/material.dart';

class CommonNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CommonNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () => onTap(0),
            icon: Icon(
              Icons.edit,
              color: currentIndex == 0 ? const Color(0xFF4CAF50) : Colors.white,
            ),
          ),
          IconButton(
            onPressed: () => onTap(1),
            icon: Icon(
              Icons.timer,
              color: currentIndex == 1 ? const Color(0xFF4CAF50) : Colors.white,
            ),
          ),
          IconButton(
            onPressed: () => onTap(2),
            icon: Icon(
              Icons.map,
              color: currentIndex == 2 ? const Color(0xFF4CAF50) : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
} 