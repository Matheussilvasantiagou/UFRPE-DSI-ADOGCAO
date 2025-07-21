import 'package:shared_preferences/shared_preferences.dart';

class UserSession {

  static final UserSession _instance = UserSession._internal();

  UserSession._internal();

  static UserSession get instance => _instance;

  String? userId;
  String? userEmail;
  bool isVolunteer = false;
  String? userName;
  String? userPhone;
  String? userImageUrl;
  bool _isLoggedIn = false;

  // Getters
  bool get isLoggedIn => _isLoggedIn;

  // Inicializar a sessão verificando se há dados salvos
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    
    if (_isLoggedIn) {
      userId = prefs.getString('userId');
      userEmail = prefs.getString('userEmail');
      userName = prefs.getString('userName');
      userPhone = prefs.getString('userPhone');
      isVolunteer = prefs.getBool('isVolunteer') ?? false;
      userImageUrl = prefs.getString('userImageUrl');
    }
  }

  // Salvar dados do usuário com opção de manter conectado
  Future<void> saveUserData({
    required String userId,
    required String userEmail,
    required String userName,
    required String userPhone,
    required bool isVolunteer,
    required bool keepLoggedIn,
    required String userImageUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    this.userId = userId;
    this.userEmail = userEmail;
    this.userName = userName;
    this.userPhone = userPhone;
    this.isVolunteer = isVolunteer;
    this.userImageUrl = userImageUrl;
    this._isLoggedIn = true;

    if (keepLoggedIn) {
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userId', userId);
      await prefs.setString('userEmail', userEmail);
      await prefs.setString('userName', userName);
      await prefs.setString('userPhone', userPhone);
      await prefs.setBool('isVolunteer', isVolunteer);
      await prefs.setString('userImageUrl', userImageUrl);
    }
  }

  // Limpar dados salvos
  Future<void> clearSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userId');
    await prefs.remove('userEmail');
    await prefs.remove('userName');
    await prefs.remove('userPhone');
    await prefs.remove('isVolunteer');
    await prefs.remove('userImageUrl');
  }

  void logout() {
    userId = null;
    userEmail = null;
    userName = null;
    isVolunteer = false;
    userPhone = null;
    userImageUrl = null;
    _isLoggedIn = false;
    clearSavedData();
  }
}