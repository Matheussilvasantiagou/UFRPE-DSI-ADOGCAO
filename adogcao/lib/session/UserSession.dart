class UserSession {

  static final UserSession _instance = UserSession._internal();

  UserSession._internal();

  static UserSession get instance => _instance;

  String? userId;
  String? userEmail;
  bool isVolunteer = false;
  String? userName;
  String? userPhone;

  void logout() {
    userId = null;
    userEmail = null;
    userName = null;
    isVolunteer = false;
    userPhone = null;
  }
}