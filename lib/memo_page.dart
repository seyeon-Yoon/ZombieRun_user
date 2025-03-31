import 'package:flutter/material.dart';
import 'widgets/common_navigation_bar.dart';
import 'timer_page.dart';
import 'map_page.dart';

class MemoPage extends StatefulWidget {
  const MemoPage({super.key});

  @override
  State<MemoPage> createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  List<List<Offset>> strokes = [];  // 현재 화면에 표시된 획들
  List<Offset> currentStroke = [];  // 현재 그리고 있는 획
  bool isErasing = false;  // 지우개 모드 여부
  List<Offset> eraserPoints = [];  // 지우개로 지운 영역
  List<List<List<Offset>>> undoHistory = [];  // 되돌리기 히스토리 (전체 strokes 상태 저장)
  
  // 작업 히스토리 관리를 위한 변수들
  List<Map<String, dynamic>> history = [];  // 작업 히스토리

  void _onPanStart(DragStartDetails details) {
    setState(() {
      if (!isErasing) {
        currentStroke = [details.localPosition];
      } else {
        eraserPoints = [details.localPosition];
      }
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      if (isErasing) {
        eraserPoints.add(details.localPosition);
        // 지우개 영역과 겹치는 점들을 제거
        final newStrokes = <List<Offset>>[];
        
        for (var stroke in strokes) {
          List<Offset> newStroke = [];
          List<List<Offset>> subStrokes = [[]];
          
          for (int i = 0; i < stroke.length; i++) {
            bool shouldErase = false;
            for (var erasePoint in eraserPoints) {
              if ((stroke[i] - erasePoint).distance < 20.0) {
                shouldErase = true;
                break;
              }
            }
            
            if (!shouldErase) {
              if (subStrokes.last.isEmpty && i > 0 && !newStroke.contains(stroke[i-1])) {
                // 이전 점이 있고 지워지지 않았다면 연결을 위해 추가
                subStrokes.last.add(stroke[i-1]);
              }
              subStrokes.last.add(stroke[i]);
            } else {
              if (subStrokes.last.isNotEmpty) {
                // 현재 부분 획이 끝났으므로 새로운 부분 획 시작
                subStrokes.add([]);
              }
            }
          }
          
          // 유효한 부분 획들 추가 (2개 이상의 점으로 구성된 획만)
          newStrokes.addAll(subStrokes.where((s) => s.length >= 2));
        }
        
        if (strokes.length != newStrokes.length || 
            strokes.any((stroke) => stroke.length != newStrokes.fold<int>(0, (sum, stroke) => sum + stroke.length))) {
          // 변화가 있을 때만 히스토리에 저장
          undoHistory.add(List<List<Offset>>.from(
            strokes.map((stroke) => List<Offset>.from(stroke))
          ));
          strokes = newStrokes;
        }
      } else {
        currentStroke.add(details.localPosition);
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      if (!isErasing && currentStroke.length >= 2) {
        // 현재 상태를 히스토리에 저장
        undoHistory.add(List<List<Offset>>.from(
          strokes.map((stroke) => List<Offset>.from(stroke))
        ));
        
        strokes.add(List<Offset>.from(currentStroke));
        currentStroke = [];
      }
      eraserPoints.clear();
    });
  }

  void _undo() {
    setState(() {
      if (undoHistory.isNotEmpty) {
        strokes = List<List<Offset>>.from(
          undoHistory.removeLast().map((stroke) => List<Offset>.from(stroke))
        );
      }
    });
  }

  void _toggleEraser() {
    setState(() {
      isErasing = !isErasing;
    });
  }

  void _clearAll() {
    setState(() {
      if (strokes.isNotEmpty) {
        // 현재 상태를 히스토리에 저장
        undoHistory.add(List<List<Offset>>.from(
          strokes.map((stroke) => List<Offset>.from(stroke))
        ));
        strokes.clear();
      }
    });
  }

  void _handleNavigation(BuildContext context, int index) {
    if (index == 0) return; // 현재 메모 페이지이므로 이동하지 않음
    
    switch (index) {
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const TimerPage()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const MapPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF333333),
      body: Stack(
        children: [
          // 그리기 영역
          GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            child: CustomPaint(
              painter: DrawingPainter(
                strokes: strokes,
                currentStroke: currentStroke,
                eraserPoints: eraserPoints,
                isErasing: isErasing,
              ),
              child: Container(
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          
          // 오른쪽 아이콘 메뉴
          Positioned(
            right: 20,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isErasing = false;
                        });
                      },
                      icon: Icon(
                        Icons.edit,
                        color: !isErasing ? const Color(0xFF4CAF50) : Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 16),
                    IconButton(
                      onPressed: _toggleEraser,
                      icon: Icon(
                        Icons.cleaning_services,
                        color: isErasing ? const Color(0xFF4CAF50) : Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 16),
                    IconButton(
                      onPressed: _undo,
                      icon: const Icon(
                        Icons.undo,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 초기화 버튼
          Positioned(
            right: 20,
            top: 20,
            child: IconButton(
              onPressed: _clearAll,
              icon: const Icon(
                Icons.delete_forever,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),

          // 공통 네비게이션 바
          CommonNavigationBar(
            currentIndex: 0,
            onTap: (index) => _handleNavigation(context, index),
          ),
        ],
      ),
    );
  }
}

// 그리기를 담당하는 CustomPainter
class DrawingPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<Offset> currentStroke;
  final List<Offset> eraserPoints;
  final bool isErasing;

  DrawingPainter({
    required this.strokes,
    required this.currentStroke,
    required this.eraserPoints,
    required this.isErasing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // 저장된 모든 획 그리기
    for (var stroke in strokes) {
      if (stroke.length < 2) continue;
      
      final path = Path();
      path.moveTo(stroke[0].dx, stroke[0].dy);
      
      for (int i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx, stroke[i].dy);
      }
      
      canvas.drawPath(path, paint);
    }

    // 현재 그리고 있는 획 그리기
    if (!isErasing && currentStroke.isNotEmpty && currentStroke.length >= 2) {
      final path = Path();
      path.moveTo(currentStroke[0].dx, currentStroke[0].dy);
      
      for (int i = 1; i < currentStroke.length; i++) {
        path.lineTo(currentStroke[i].dx, currentStroke[i].dy);
      }
      
      canvas.drawPath(path, paint);
    }

    // 지우개 영역 표시 (반투명한 원)
    if (isErasing && eraserPoints.isNotEmpty) {
      final eraserPaint = Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      // 현재 위치의 원만 그리기
      canvas.drawCircle(eraserPoints.last, 20.0, eraserPaint);
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
    return true;
  }
}

class Memo {
  final String title;
  final String content;
  final DateTime createdAt;

  Memo({
    required this.title,
    required this.content,
    required this.createdAt,
  });
} 