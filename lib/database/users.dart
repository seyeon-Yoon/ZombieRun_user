// 사용자 데이터베이스 파일
class User {
  final String id;
  final String password;
  final String name;

  const User({
    required this.id,
    required this.password,
    required this.name,
  });
}

class UsersDB {
  static const List<User> users = [
    User(
      id: "admin",
      password: "1234",
      name: "관리자",
    ),
    User(
      id: "user1",
      password: "5678",
      name: "사용자1",
    ),
    User(
      id: "user2",
      password: "9012",
      name: "사용자2",
    ),
  ];

  // 싱글톤 패턴
  static final UsersDB _instance = UsersDB._internal();
  
  factory UsersDB() {
    return _instance;
  }

  UsersDB._internal();

  // 로그인 검증
  bool validateUser(String id, String password) {
    try {
      final user = users.firstWhere((user) => user.id == id);
      return user.password == password;
    } catch (e) {
      return false;
    }
  }

  // ID로 사용자 찾기
  User? getUserById(String id) {
    try {
      return users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }
} 