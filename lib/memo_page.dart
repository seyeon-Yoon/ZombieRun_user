import 'package:flutter/material.dart';
import 'widgets/common_navigation_bar.dart';
import 'models/drawing_point.dart';
import 'timer_page.dart';
import 'map_page.dart';

class MemoPage extends StatefulWidget {
  const MemoPage({super.key});

  @override
  State<MemoPage> createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  List<List<DrawingPoint>> strokes = [];
  List<DrawingPoint> currentStroke = [];
  List<DrawingPoint> eraserPoints = [];
  List<List<DrawingPoint>> undoHistory = [];
  bool isEraserMode = false;

  void _handleNavigation(int index) {
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

  void _onPanStart(DragStartDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset localPosition = renderBox.globalToLocal(details.globalPosition);
    
    if (isEraserMode) {
      eraserPoints.add(DrawingPoint(
        offset: localPosition,
        paint: Paint()
          ..color = Colors.white
          ..strokeWidth = 20
          ..strokeCap = StrokeCap.round,
      ));
    } else {
      currentStroke = [
        DrawingPoint(
          offset: localPosition,
          paint: Paint()
            ..color = Colors.black
            ..strokeWidth = 2
            ..strokeCap = StrokeCap.round,
        ),
      ];
    }
    setState(() {});
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset localPosition = renderBox.globalToLocal(details.globalPosition);
    
    if (isEraserMode) {
      eraserPoints.add(DrawingPoint(
        offset: localPosition,
        paint: Paint()
          ..color = Colors.white
          ..strokeWidth = 20
          ..strokeCap = StrokeCap.round,
      ));
    } else {
      currentStroke.add(DrawingPoint(
        offset: localPosition,
        paint: Paint()
          ..color = Colors.black
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round,
      ));
    }
    setState(() {});
  }

  void _onPanEnd(DragEndDetails details) {
    if (!isEraserMode && currentStroke.isNotEmpty) {
      strokes.add(List.from(currentStroke));
      currentStroke = [];
    }
    setState(() {});
  }

  void _onPanCancel() {
    if (!isEraserMode) {
      currentStroke = [];
    }
    setState(() {});
  }

  void _undo() {
    if (strokes.isNotEmpty) {
      undoHistory.add(strokes.removeLast());
      currentStroke = [];
      setState(() {});
    }
  }

  void _toggleEraser() {
    setState(() {
      isEraserMode = !isEraserMode;
      if (!isEraserMode) {
        eraserPoints = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 메모 영역
          GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            onPanCancel: _onPanCancel,
            child: CustomPaint(
              painter: DrawingPainter(
                strokes: strokes,
                currentStroke: currentStroke,
                eraserPoints: eraserPoints,
              ),
              child: Container(),
            ),
          ),
          // 네비게이션 바
          CommonNavigationBar(
            currentIndex: 0,
            onTap: _handleNavigation,
          ),
          // 컨트롤 버튼들
          Positioned(
            top: 40,
            right: 20,
            child: Row(
              children: [
                // 지우개 버튼
                IconButton(
                  onPressed: _toggleEraser,
                  icon: Icon(
                    Icons.edit,
                    color: isEraserMode ? Colors.red : Colors.black,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 10),
                // 되돌리기 버튼
                IconButton(
                  onPressed: _undo,
                  icon: const Icon(
                    Icons.undo,
                    color: Colors.black,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 10),
                // 전체 지우기 버튼
                IconButton(
                  onPressed: () {
                    setState(() {
                      strokes = [];
                      currentStroke = [];
                      eraserPoints = [];
                      undoHistory = [];
                    });
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 28,
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

class DrawingPainter extends CustomPainter {
  final List<List<DrawingPoint>> strokes;
  final List<DrawingPoint> currentStroke;
  final List<DrawingPoint> eraserPoints;

  DrawingPainter({
    required this.strokes,
    required this.currentStroke,
    required this.eraserPoints,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 기존 스트로크 그리기
    for (final stroke in strokes) {
      for (int i = 0; i < stroke.length - 1; i++) {
        canvas.drawLine(
          stroke[i].offset,
          stroke[i + 1].offset,
          stroke[i].paint,
        );
      }
    }

    // 현재 스트로크 그리기
    for (int i = 0; i < currentStroke.length - 1; i++) {
      canvas.drawLine(
        currentStroke[i].offset,
        currentStroke[i + 1].offset,
        currentStroke[i].paint,
      );
    }

    // 지우개 포인트 그리기
    for (final point in eraserPoints) {
      canvas.drawCircle(point.offset, 10, point.paint);
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
    return oldDelegate.strokes != strokes ||
        oldDelegate.currentStroke != currentStroke ||
        oldDelegate.eraserPoints != eraserPoints;
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