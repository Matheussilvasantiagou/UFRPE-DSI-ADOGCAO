import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adogcao/session/UserSession.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditUserController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  bool isVolunteer = false;

  Future<void> editUser({
    required String name,
    required String phoneNumber,
    required bool isVolunteer,
    required String imageUrl,
  }) async {
    try {
      await editUserToFirestore(
        name,
        phoneNumber,
        isVolunteer,
        imageUrl,
      );

      // Atualizar os dados na sessão
      UserSession.instance.userName = name;
      UserSession.instance.userPhone = phoneNumber;
      UserSession.instance.isVolunteer = isVolunteer;
      UserSession.instance.userImageUrl = imageUrl;

      // Se o usuário escolheu "manter conectado", atualizar os dados salvos localmente
      await _updateLocalData(name, phoneNumber, isVolunteer, imageUrl);

    } catch (e) {
      throw Exception("Erro ao registrar alterações do usuário");
    }
  }

  Future<void> editUserToFirestore(
    String name,
    String phoneNumber,
    bool isVolunteer,
    String imageUrl,
  ) async {
    CollectionReference users = _firestore.collection('users');

    try {
      await users.doc(UserSession.instance.userId).set({
        'name': name,
        'email': UserSession.instance.userEmail,
        'phoneNumber': phoneNumber,
        'isVolunteer': isVolunteer,
        'uid': UserSession.instance.userId,
        'imageUrl': imageUrl,
      });
    } catch (e) {
      throw Exception("Erro ao editar usuário");
    }
  }

  Future<void> _updateLocalData(String name, String phoneNumber, bool isVolunteer, String imageUrl) async {
    try {
      // Verificar se há dados salvos localmente (usuário escolheu "manter conectado")
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      
      if (isLoggedIn) {
        // Atualizar os dados salvos localmente
        await prefs.setString('userName', name);
        await prefs.setString('userPhone', phoneNumber);
        await prefs.setBool('isVolunteer', isVolunteer);
        await prefs.setString('userImageUrl', imageUrl);
      }
    } catch (e) {
      // Se houver erro ao atualizar dados locais, apenas logar o erro
      // mas não falhar a operação principal
      print('Erro ao atualizar dados locais: $e');
    }
  }

  void toggleVolunteer(bool value) {
    isVolunteer = value;
  }
}
