import 'package:flutter/material.dart';
import 'memo_page.dart';
import 'timer_page.dart';
import 'map_page.dart';

class MainContainer extends StatefulWidget {
  final int initialMinutes;
  
  const MainContainer({
    super.key,
    required this.initialMinutes,
  });

  @override
  State<MainContainer> createState() => MainContainerState();
}

class MainContainerState extends State<MainContainer> {
  int _currentIndex = 1; // 기본값은 타이머 페이지

  int get currentIndex => _currentIndex;
  set currentIndex(int value) {
    setState(() {
      _currentIndex = value;
    });
  }

  late final List<Widget> _pages;
  late final TimerPage _timerPage;

  @override
  void initState() {
    super.initState();
    _timerPage = TimerPage(initialMinutes: widget.initialMinutes);
    _pages = [
      MemoPage(initialMinutes: widget.initialMinutes),
      _timerPage,
      MapPage(initialMinutes: widget.initialMinutes),
    ];
  }

  @override
  void didUpdateWidget(MainContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialMinutes != widget.initialMinutes) {
      setState(() {
        _timerPage = TimerPage(initialMinutes: widget.initialMinutes);
        _pages[0] = MemoPage(initialMinutes: widget.initialMinutes);
        _pages[1] = _timerPage;
        _pages[2] = MapPage(initialMinutes: widget.initialMinutes);
      });
    }
  }

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
                  onPressed: () {
                    setState(() {
                      _currentIndex = 0;
                    });
                  },
                  icon: Icon(
                    Icons.edit,
                    color: _currentIndex == 0 ? const Color(0xFF4CAF50) : Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                  },
                  icon: Icon(
                    Icons.timer,
                    color: _currentIndex == 1 ? const Color(0xFF4CAF50) : Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 2;
                    });
                  },
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