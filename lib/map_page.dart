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
  @override
  void initState() {
    super.initState();
    _showTimerEndedAlert();
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
      body: Center(
        child: Image.asset(
          'assets/images/map.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
} 