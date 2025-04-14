import 'package:flutter/material.dart';
import '../database/themes.dart';

class HintScreen extends StatefulWidget {
  const HintScreen({Key? key}) : super(key: key);

  @override
  State<HintScreen> createState() => _HintScreenState();
}

class _HintScreenState extends State<HintScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  
  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _showHintDialog(String code) {
    final hint = ThemesDB().getHintByCode(code);
    // 입력 필드 초기화
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
    
    if (hint != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                color: const Color(0xFF333333),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'HINT CODE : ${hint.code}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        hint.content,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('잘못된 힌트 코드입니다.'),
          duration: Duration(seconds: 2),
        ),
      );
      // 입력 필드 초기화
      for (var controller in _controllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          padding: EdgeInsets.zero,
          icon: const Text(
            '<',
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            'HINT',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '힌트 코드를 입력해주세요',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              return Container(
                width: 52,
                height: 52,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                alignment: Alignment.center,
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    height: 1,
                  ),
                  readOnly: true,
                  showCursor: false,
                  decoration: InputDecoration(
                    counterText: "",
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white38),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.length == 1 && index < 3) {
                      _focusNodes[index + 1].requestFocus();
                    }
                    // 4자리 코드가 모두 입력되면 힌트 팝업 표시
                    if (index == 3 && value.length == 1) {
                      String code = _controllers.map((c) => c.text).join();
                      _showHintDialog(code);
                    }
                  },
                ),
              );
            }),
          ),
          const Expanded(child: SizedBox()),
          SizedBox(
            width: 420,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int i = 1; i <= 3; i++)
                        _buildNumberButton(i.toString()),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int i = 4; i <= 6; i++)
                        _buildNumberButton(i.toString()),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int i = 7; i <= 9; i++)
                        _buildNumberButton(i.toString()),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(width: 90),
                      _buildNumberButton('0'),
                      SizedBox(
                        width: 90,
                        height: 90,
                        child: IconButton(
                          icon: const Icon(
                            Icons.backspace_outlined,
                            color: Colors.white,
                            size: 32,
                          ),
                          onPressed: () {
                            for (int i = _controllers.length - 1; i >= 0; i--) {
                              if (_controllers[i].text.isNotEmpty) {
                                _controllers[i].clear();
                                if (i > 0) {
                                  _focusNodes[i - 1].requestFocus();
                                }
                                break;
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return SizedBox(
      width: 90,
      height: 90,
      child: TextButton(
        onPressed: () {
          for (int i = 0; i < _controllers.length; i++) {
            if (_controllers[i].text.isEmpty) {
              _controllers[i].text = number;
              if (i < _controllers.length - 1) {
                _focusNodes[i + 1].requestFocus();
              } else if (i == 3) {
                // 마지막 숫자를 입력했을 때 힌트 팝업 표시
                String code = _controllers.map((c) => c.text).join();
                _showHintDialog(code);
              }
              break;
            }
          }
        },
        child: Text(
          number,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
          ),
        ),
      ),
    );
  }
} 