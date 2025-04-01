// 공지사항 데이터베이스 파일 
class Notice {
  final int id;
  final String content;
  final String createdAt;

  const Notice({
    required this.id,
    required this.content,
    required this.createdAt,
  });
}

class NoticesDB {
  static const List<Notice> notices = [
    Notice(
      id: 3,
      content: "asdfaaaaaaaaaaaaaaaaaaasdfaaaaaaaaaaaaaaaaaaasdfaaaaaaaaaaaaaaaaaaasdfaaaaaaaaaaaaaaaaaaasdfaaaaaaaaaaaaaaaaaaasdfaaaaaaaaaaaaaaaaaaasdfaaaaaaaaaaaaaaaaaaasdfaaaaaaaaaaaaaaaaaaasdfaaaaaaaaaaaaaaaaaaasdfaaaaaaaaaaaaaaaaaaasdfaaaaaaaaaaaaaaaaaaasdfaaaaaaaaaaaaaaaaaaasdfaaaaaaaaaaaaaaaaaaasdfaaaaaaaaaaaaaaaaaaasdfaaaaaaaaaaaaaaaaaaasdfaaaaaaaaaaaaaaaaaaasdfaaaaaaaaaaaaaaaaaaasdfaaaaaaaaaaaaaaaaaaasdfaaaaaaaaaaaaaaaaaa",
      createdAt: "2025.03.25",
    ),
  ];

  static const int lastId = 3;

  // 싱글톤 패턴
  static final NoticesDB _instance = NoticesDB._internal();
  
  factory NoticesDB() {
    return _instance;
  }

  NoticesDB._internal();

  // 공지사항 목록 가져오기
  List<Notice> getNotices() {
    return notices;
  }

  // 특정 ID의 공지사항 가져오기
  Notice? getNoticeById(int id) {
    try {
      return notices.firstWhere((notice) => notice.id == id);
    } catch (e) {
      return null;
    }
  }
} 