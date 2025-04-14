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
      themeName: "그 날, 사라진 우리",
      themeCode: "0806",
      escapeTimeMinutes: "30",
      availableHints: "5",
      monitoringPlaces: "7",
      mapFile: "경로",
      hints: [
        Hint(
          code: "0309",
          progress: 1,
          content: "다이어리의 찢어진 부분과 맞는 페이지를 찾아라",
          answer: "정답1",
        ),
        Hint(
          code: "0507",
          progress: 2,
          content: "달력에 적힌 실험날짜와 자물쇠 번호는 무슨 의미가 있을까?",
          answer: "정답2",
        ),
        Hint(
          code: "0310",
          progress: 3,
          content: "대자보 속 미니게임과 발행일자는 무슨 의미가 있을까?",
          answer: "정답3",
        ),
        Hint(
          code: "0209",
          progress: 5,
          content: "사슴뿔 심볼에는 몇 개의 끝 부분이 있지?",
          answer: "정답3",
        ),
        Hint(
          code: "0210",
          progress: 6,
          content: "좌석 배치와 칠판 속 표가 유사해보이지 않니?",
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