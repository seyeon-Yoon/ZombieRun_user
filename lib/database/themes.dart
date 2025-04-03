// 테마 데이터베이스 파일
class Hint {
  final String code;
  final int progress;
  final String content;
  final String answer;

  const Hint({
    required this.code,
    required this.progress,
    required this.content,
    required this.answer,
  });
}

class Theme {
  final String themeName;
  final String themeCode;
  final String escapeTimeMinutes;
  final String availableHints;
  final String monitoringPlaces;
  final String? mapFile;
  final List<Hint> hints;
  final List<String>? places;

  const Theme({
    required this.themeName,
    required this.themeCode,
    required this.escapeTimeMinutes,
    required this.availableHints,
    required this.monitoringPlaces,
    this.mapFile,
    required this.hints,
    this.places,
  });
}

class ThemesDB {
  static const List<Theme> themes = [
    Theme(
      themeName: "테마1",
      themeCode: "1234",
      escapeTimeMinutes: "1",
      availableHints: "5",
      monitoringPlaces: "4",
      mapFile: "경로",
      hints: [
        Hint(
          code: "4812",
          progress: 1,
          content: "5번 문제를 풀고 난 단어 2를 곱해서 입력하시오.\n5번 문제를 풀고 난 단어 2를 곱해서 입력하시오.\n5번 문제를 풀고 난 단어 2를 곱해서 입력하시오.",
          answer: "정답1",
        ),
        Hint(
          code: "1234",
          progress: 2,
          content: "두 번째 힌트 내용입니다.",
          answer: "정답2",
        ),
        Hint(
          code: "5678",
          progress: 3,
          content: "세 번째 힌트 내용입니다.",
          answer: "정답3",
        ),
      ],
      places: [],
    ),
  ];

  // 싱글톤 패턴
  static final ThemesDB _instance = ThemesDB._internal();
  
  factory ThemesDB() {
    return _instance;
  }

  ThemesDB._internal();

  // 현재 테마 가져오기 (첫 번째 테마)
  Theme getCurrentTheme() {
    return themes[0];
  }

  // 테마 코드로 테마 찾기
  Theme? getThemeByCode(String code) {
    try {
      return themes.firstWhere((theme) => theme.themeCode == code);
    } catch (e) {
      return null;
    }
  }

  // 힌트 코드로 힌트 찾기
  Hint? getHintByCode(String code) {
    for (final theme in themes) {
      try {
        return theme.hints.firstWhere((hint) => hint.code == code);
      } catch (e) {
        continue;
      }
    }
    return null;
  }
} 