import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';
import 'widgets/common_navigation_bar.dart';
import 'memo_page.dart';
import 'map_page.dart';
import 'screens/hint_screen.dart';
import 'main_container.dart';

class TimerPage extends StatefulWidget {
  final int initialMinutes;
  final Function(int) onNavigation;
  final int remainingSeconds;
  final bool isRunning;
  final DateTime? startTime;
  final Function(int, bool, DateTime?) onTimerUpdate;
  final bool isTimerEnded;

  const TimerPage({
    super.key,
    required this.initialMinutes,
    required this.onNavigation,
    required this.remainingSeconds,
    required this.isRunning,
    required this.startTime,
    required this.onTimerUpdate,
    required this.isTimerEnded,
  });

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  late int _remainingSeconds;
  late bool _isRunning;
  late DateTime? _startTime;
  Timer? _timer;
  double _progress = 1.0;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.remainingSeconds;
    _isRunning = widget.isRunning;
    _startTime = widget.startTime;
    _progress = _remainingSeconds / (widget.initialMinutes * 60);
    
    if (_isRunning && _startTime != null) {
      _startTimer();
    }
    _showTimerEndedAlert();
  }

  @override
  void didUpdateWidget(TimerPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.remainingSeconds != widget.remainingSeconds ||
        oldWidget.isRunning != widget.isRunning ||
        oldWidget.startTime != widget.startTime) {
      setState(() {
        _remainingSeconds = widget.remainingSeconds;
        _isRunning = widget.isRunning;
        _startTime = widget.startTime;
        _progress = _remainingSeconds / (widget.initialMinutes * 60);
      });
    }
    if (widget.isTimerEnded && !oldWidget.isTimerEnded) {
      _showTimerEndedAlert();
    }
  }

  void _startTimer() {
    if (!_isRunning) {
      setState(() {
        _isRunning = true;
        _startTime = DateTime.now();
      });
      widget.onTimerUpdate(_remainingSeconds, _isRunning, _startTime);
      
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
            _progress = _remainingSeconds / (widget.initialMinutes * 60);
            widget.onTimerUpdate(_remainingSeconds, _isRunning, _startTime);
          } else {
            _timer?.cancel();
            _isRunning = false;
            _startTime = null;
            widget.onTimerUpdate(_remainingSeconds, _isRunning, _startTime);
            
            if (context.mounted) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: const Color(0xFF333333),
                    title: const Text(
                      '시간 종료',
                      style: TextStyle(color: Colors.white),
                    ),
                    content: const Text(
                      '근처 관계자를 찾아주세요',
                      style: TextStyle(color: Colors.white),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          '확인',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          }
        });
      });
    }
  }

  void _pauseTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() {
        _isRunning = false;
      });
      widget.onTimerUpdate(_remainingSeconds, _isRunning, _startTime);
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = widget.initialMinutes * 60;
      _isRunning = false;
      _startTime = null;
      _progress = 1.0;
    });
    widget.onTimerUpdate(_remainingSeconds, _isRunning, _startTime);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _handleNavigation(int index) {
    if (index == 1) return; // 현재 타이머 페이지이므로 이동하지 않음
    
    widget.onNavigation(index);
  }

  Color _getTimerColor() {
    final totalSeconds = widget.initialMinutes * 60;
    final halfTime = totalSeconds ~/ 2;
    final tenMinutes = 10 * 60; // 10분을 초로 변환

    if (_remainingSeconds <= tenMinutes) {
      return Colors.red;
    } else if (_remainingSeconds <= halfTime) {
      return Colors.yellow;
    } else {
      return Colors.green;
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
          // 상단 우측 정지 버튼
          Positioned(
            top: 40,
            right: 20,
            child: TextButton(
              onPressed: _isRunning ? _pauseTimer : null,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                side: const BorderSide(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                '정지',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          // 중앙 타이머 영역
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // 회색 배경 원
                    Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey[700]!,
                          width: 10,
                        ),
                      ),
                    ),
                    // 진행도 표시 원호
                    CustomPaint(
                      size: const Size(300, 300),
                      painter: TimerPainter(
                        progress: _progress,
                        color: _getTimerColor(),
                        strokeWidth: 10,
                      ),
                    ),
                    // 타이머 텍스트
                    Text(
                      _formatTime(_remainingSeconds),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // 시작/힌트 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _isRunning ? null : _startTimer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        '시작',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HintScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        '힌트',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 원형 프로그레스 바를 그리는 커스텀 페인터
class TimerPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  TimerPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // 시작 각도 (12시 방향)
      2 * math.pi * progress, // 진행도에 따른 각도
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(TimerPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
} 