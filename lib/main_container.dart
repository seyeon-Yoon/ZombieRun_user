import 'package:flutter/material.dart';
import 'memo_page.dart';
import 'timer_page.dart';
import 'map_page.dart';

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _currentIndex = 1; // 기본값은 타이머 페이지

  final List<Widget> _pages = [
    const MemoPage(),
    const TimerPage(),
    const MapPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF333333),
      body: Stack(
        children: [
          // 현재 선택된 페이지
          _pages[_currentIndex],
          // 공통 네비게이션 바
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () => setState(() => _currentIndex = 0),
                  icon: Icon(
                    Icons.edit,
                    color: _currentIndex == 0 ? const Color(0xFF4CAF50) : Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _currentIndex = 1),
                  icon: Icon(
                    Icons.timer,
                    color: _currentIndex == 1 ? const Color(0xFF4CAF50) : Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _currentIndex = 2),
                  icon: Icon(
                    Icons.map,
                    color: _currentIndex == 2 ? const Color(0xFF4CAF50) : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 