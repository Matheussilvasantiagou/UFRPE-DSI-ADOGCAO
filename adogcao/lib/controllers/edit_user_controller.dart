import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adogcao/session/UserSession.dart';

class EditUserController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  bool isVolunteer = false;

  Future<void> editUser({
    required String name,
    required String phoneNumber,
    required bool isVolunteer
  }) async {
    try {

        await editUserToFirestore(
          name,
          phoneNumber,
          isVolunteer,
        );

    } catch (e) {
      throw Exception("Erro ao registrar alterações do usuário");
    }
  }

  Future<void> editUserToFirestore(
    String name,
    String phoneNumber,
    bool isVolunteer,
  ) async {
    CollectionReference users = _firestore.collection('users');

    try {
      await users.doc(UserSession.instance.userId).set({
        'name': name,
        'email': UserSession.instance.userEmail,
        'phoneNumber': phoneNumber,
        'isVolunteer': isVolunteer,
        'uid': UserSession.instance.userId
      });
      UserSession.instance.userName = name;
      UserSession.instance.userPhone = phoneNumber;
      UserSession.instance.isVolunteer = isVolunteer;
    } catch (e) {
      throw Exception("Erro ao editar usuário");
    }
  }

  void toggleVolunteer(bool value) {
    isVolunteer = value;
  }
}
