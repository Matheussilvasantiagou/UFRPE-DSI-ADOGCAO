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

  Future<UserCredential?> loginUser({required String email, required String password}) async {
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
        UserSession.instance.userId = userData['uid'];
        UserSession.instance.isVolunteer = userData['isVolunteer'];
        UserSession.instance.userName = userData['name'];
        UserSession.instance.userPhone = userData['phoneNumber'];

      }
      UserSession.instance.userEmail = userCredential.user?.email;
      
    
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
