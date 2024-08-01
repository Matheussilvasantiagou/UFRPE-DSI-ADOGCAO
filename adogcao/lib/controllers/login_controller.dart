import 'package:firebase_auth/firebase_auth.dart';

class LoginController {
  bool agreeToTerms = false;

  void toggleAgreeToTerms(bool value) {
    agreeToTerms = value;
  }

  Future<UserCredential?> loginUser({required String email, required String password}) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      throw "Usuário e/ou senha inválidos"; // Propaga o erro para ser tratado na tela de login
    }
  }
}
