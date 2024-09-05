
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AbrigoController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registrarAbrigo({
    required String nome,
    required String email,
    required String endereco,
    required String telefone,
    required double lat,
    required double lng,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('abrigos').add({
          'nome': nome,
          'email': email,
          'endereco': endereco,
          'telefone': telefone,
          'lat': lat,
          'lng': lng,
          'volunteerId': user.uid, // Associando o abrigo ao voluntário
          'createdAt': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        throw Exception("Erro ao registrar abrigo: $e");
      }
    } else {
      throw Exception("Usuário não autenticado");
    }
  }
}
