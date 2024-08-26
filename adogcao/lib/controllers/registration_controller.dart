import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  bool isVolunteer = false;

  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    try {
      // Registra o usuário no Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Obtém o usuário registrado
      User? user = userCredential.user;

      if (user != null) {
        // Adiciona o usuário ao Firestore
        await addUserToFirestore(
          user.uid,
          name,
          email,
          phoneNumber,
          isVolunteer,
        );
      }
    } catch (e) {
      throw Exception("Erro ao registrar usuário: $e");
    }
  }

  Future<void> addUserToFirestore(
    String uid,
    String name,
    String email,
    String phoneNumber,
    bool isVolunteer,
  ) async {
    CollectionReference users = _firestore.collection('users');

    try {
      await users.doc(uid).set({
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'isVolunteer': isVolunteer,
        'createdAt': FieldValue.serverTimestamp(),
        'uid': uid
      });
    } catch (e) {
      throw Exception("Erro ao adicionar usuário ao Firestore: $e");
    }
  }

  void toggleVolunteer(bool value) {
    isVolunteer = value;
  }
}
