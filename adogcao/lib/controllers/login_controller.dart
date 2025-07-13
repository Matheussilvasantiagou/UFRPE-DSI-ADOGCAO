import 'package:firebase_auth/firebase_auth.dart';
import 'package:adogcao/session/UserSession.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginController {
  bool agreeToTerms = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void toggleAgreeToTerms(bool value) {
    agreeToTerms = value;
  }

  Future<UserCredential?> loginUser({
    required String email, 
    required String password,
    required bool keepLoggedIn,
  }) async {
    try {
      CollectionReference users = _firestore.collection('users');
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

       var querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('uid', isEqualTo: userCredential.user?.uid)
      .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first.data();
        
        // Usar o novo método saveUserData com a opção de manter conectado
        await UserSession.instance.saveUserData(
          userId: userData['uid'],
          userEmail: userCredential.user?.email ?? '',
          userName: userData['name'],
          userPhone: userData['phoneNumber'],
          isVolunteer: userData['isVolunteer'],
          keepLoggedIn: keepLoggedIn,
        );
      }
      
      return userCredential;
    } catch (e) {
      throw "Usuário e/ou senha inválidos"; // Propaga o erro para ser tratado na tela de login
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      UserSession.instance.logout();
    } catch (e) {
      print(e.toString());
    }
  }
}
