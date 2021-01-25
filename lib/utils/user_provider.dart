class UserProvider {
  int userId;
  int messageDayCount;

  static final UserProvider _instance = UserProvider._internal();

  UserProvider._internal();

  factory UserProvider() {
    return _instance;
  }

  factory UserProvider.init(int userId) {
    _instance.userId = userId;
    return _instance;
  }
}
