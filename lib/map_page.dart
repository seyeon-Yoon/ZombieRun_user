import 'package:flutter/material.dart';
import 'widgets/common_navigation_bar.dart';
import 'memo_page.dart';
import 'timer_page.dart';
import 'main_container.dart';

class MapPage extends StatelessWidget {
  final int initialMinutes;

  const MapPage({
    super.key,
    required this.initialMinutes,
  });

  void _handleNavigation(BuildContext context, int index) {
    if (index == 2) return; // 현재 약도 페이지이므로 이동하지 않음
    
    // MainContainer의 페이지 전환을 사용
    if (context.mounted) {
      final mainContainer = context.findAncestorStateOfType<MainContainerState>();
      if (mainContainer != null) {
        mainContainer.currentIndex = index;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF333333),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '약도 페이지',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      '지도가 들어갈 자리입니다',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 공통 네비게이션 바
          CommonNavigationBar(
            currentIndex: 2,
            onTap: (index) => _handleNavigation(context, index),
            initialMinutes: initialMinutes,
          ),
        ],
      ),
    );
  }
} 