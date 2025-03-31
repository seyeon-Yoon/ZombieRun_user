import 'package:flutter/material.dart';
import 'dart:math' as math;

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  bool _isRunning = false;
  double _progress = 0.5; // 프로그레스 바의 진행도 (0.0 ~ 1.0)

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
              onPressed: () {
                // TODO: 정지 기능 구현
              },
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
                        color: Colors.green,
                        strokeWidth: 10,
                      ),
                    ),
                    // 타이머 텍스트
                    const Text(
                      '0:00:00',
                      style: TextStyle(
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
                      onPressed: () {
                        setState(() {
                          _isRunning = !_isRunning;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        _isRunning ? '일시정지' : '시작',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: 힌트 기능 구현
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
          // 하단 버튼들
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    // TODO: 메모 기능 구현
                  },
                  icon: const Icon(Icons.edit, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {
                    // TODO: 카메라 기능 구현
                  },
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {
                    // TODO: 지도 기능 구현
                  },
                  icon: const Icon(Icons.map, color: Colors.white),
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