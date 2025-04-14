import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  final int initialMinutes;
  final Function(int) onNavigation;
  final bool isTimerEnded;

  const MapPage({
    super.key,
    required this.initialMinutes,
    required this.onNavigation,
    required this.isTimerEnded,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _showTimerEndedAlert();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MapPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isTimerEnded && !oldWidget.isTimerEnded) {
      _showTimerEndedAlert();
    }
  }

  void _showTimerEndedAlert() {
    if (widget.isTimerEnded) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF333333),
            title: const Text(
              '시간 종료',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              '시간이 종료되었습니다.\n근처 관계자를 찾아주세요.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  '확인',
                  style: TextStyle(
                    color: Color(0xFF4CAF50),
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF333333),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              // 첫 번째 지도
              Center(
                child: Image.asset(
                  'assets/images/map.png',
                  fit: BoxFit.contain,
                ),
              ),
              // 두 번째 지도
              Center(
                child: Image.asset(
                  'assets/images/map2.png',
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          // 페이지 인디케이터
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == 0 ? const Color(0xFF4CAF50) : Colors.white.withOpacity(0.5),
                  ),
                ),
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == 1 ? const Color(0xFF4CAF50) : Colors.white.withOpacity(0.5),
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