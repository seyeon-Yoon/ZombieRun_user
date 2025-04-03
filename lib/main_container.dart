import 'package:flutter/material.dart';
import 'dart:async';
import 'memo_page.dart';
import 'timer_page.dart';
import 'map_page.dart';
import 'widgets/common_navigation_bar.dart';

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
  int _remainingSeconds = 0;
  bool _isRunning = false;
  DateTime? _startTime;
  Timer? _timer;
  bool _isTimerEnded = false;

  int get currentIndex => _currentIndex;
  set currentIndex(int value) {
    setState(() {
      _currentIndex = value;
    });
  }

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.initialMinutes * 60;
    _updatePages();
  }

  void _updatePages() {
    _pages = [
      MemoPage(
        initialMinutes: widget.initialMinutes,
        onNavigation: _handleNavigation,
        isTimerEnded: _isTimerEnded,
      ),
      TimerPage(
        initialMinutes: widget.initialMinutes,
        onNavigation: _handleNavigation,
        remainingSeconds: _remainingSeconds,
        isRunning: _isRunning,
        startTime: _startTime,
        onTimerUpdate: _updateTimerState,
        isTimerEnded: _isTimerEnded,
      ),
      MapPage(
        initialMinutes: widget.initialMinutes,
        onNavigation: _handleNavigation,
        isTimerEnded: _isTimerEnded,
      ),
    ];
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTimerState(int remainingSeconds, bool isRunning, DateTime? startTime) {
    setState(() {
      _remainingSeconds = remainingSeconds;
      _isRunning = isRunning;
      _startTime = startTime;
      
      if (isRunning) {
        _timer?.cancel();
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (_remainingSeconds > 0) {
            setState(() {
              _remainingSeconds--;
              _updatePages();
            });
          } else {
            _timer?.cancel();
            _isRunning = false;
            _isTimerEnded = true;
            _updatePages();
            _showTimerEndedAlert();
          }
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  void _showTimerEndedAlert() {
    if (_isTimerEnded) {
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
                  setState(() {
                    _isTimerEnded = false;
                    _updatePages();
                  });
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

  void _handleNavigation(int index) {
    if (index == _currentIndex) return;
    
    setState(() {
      _currentIndex = index;
      _updatePages();
    });
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
            child: CommonNavigationBar(
              currentIndex: _currentIndex,
              onTap: _handleNavigation,
              initialMinutes: widget.initialMinutes,
            ),
          ),
        ],
      ),
    );
  }
} 