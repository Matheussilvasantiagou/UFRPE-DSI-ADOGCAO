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
      print("Tentando registrar usuário: $email");
      
      // Registra o usuário no Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print("Usuário criado com sucesso: ${userCredential.user?.uid}");

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
        print("Usuário adicionado ao Firestore com sucesso");
      }
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error: ${e.code} - ${e.message}");
      String errorMessage = _getFirebaseAuthErrorMessage(e.code);
      throw Exception(errorMessage);
    } catch (e) {
      print("Erro geral: $e");
      throw Exception("Erro ao registrar usuário: $e");
    }
  }

  String _getFirebaseAuthErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'A senha é muito fraca. Use pelo menos 6 caracteres.';
      case 'email-already-in-use':
        return 'Este email já está sendo usado por outra conta.';
      case 'invalid-email':
        return 'O email fornecido é inválido.';
      case 'operation-not-allowed':
        return 'O registro com email e senha não está habilitado.';
      case 'network-request-failed':
        return 'Erro de conexão. Verifique sua internet.';
      default:
        return 'Erro de autenticação: $code';
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
    } on FirebaseException catch (e) {
      print("Firestore Error: ${e.code} - ${e.message}");
      throw Exception("Erro ao adicionar usuário ao Firestore: ${e.message}");
    } catch (e) {
      print("Erro geral no Firestore: $e");
      throw Exception("Erro ao adicionar usuário ao Firestore: $e");
    }
  }

  void toggleVolunteer(bool value) {
    isVolunteer = value;
  }
}
