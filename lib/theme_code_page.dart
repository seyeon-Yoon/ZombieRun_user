import 'package:flutter/material.dart';
import 'timer_page.dart';

class ThemeCodePage extends StatefulWidget {
  const ThemeCodePage({super.key});

  @override
  State<ThemeCodePage> createState() => _ThemeCodePageState();
}

class _ThemeCodePageState extends State<ThemeCodePage> {
  String _code = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('핫 리로드가 완료되었습니다.'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _addNumber(String number) {
    if (_code.length < 4) {
      setState(() {
        _code += number;
      });
      
      // 4자리가 모두 입력되면 타이머 페이지로 이동
      if (_code.length == 4) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TimerPage()),
        );
      }
    }
  }

  void _removeNumber() {
    if (_code.isNotEmpty) {
      setState(() {
        _code = _code.substring(0, _code.length - 1);
      });
    }
  }

  Widget _buildNumberButton(String number) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: number == '←' ? _removeNumber : () => _addNumber(number),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: const CircleBorder(),
          minimumSize: const Size(72, 72),
          padding: const EdgeInsets.all(20),
          side: const BorderSide(color: Colors.white, width: 1),
        ),
        child: number == '←'
            ? const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              )
            : Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF333333),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '테마 코드 입력',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '4자리 코드를 입력해주세요',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white),
                    color: index < _code.length ? Colors.white : Colors.transparent,
                  ),
                );
              }),
            ),
            const SizedBox(height: 50),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildNumberButton('1'),
                    _buildNumberButton('2'),
                    _buildNumberButton('3'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildNumberButton('4'),
                    _buildNumberButton('5'),
                    _buildNumberButton('6'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildNumberButton('7'),
                    _buildNumberButton('8'),
                    _buildNumberButton('9'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildNumberButton('←'),
                    _buildNumberButton('0'),
                    Container(
                      margin: const EdgeInsets.all(8),
                      child: const SizedBox(
                        width: 72,
                        height: 72,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 