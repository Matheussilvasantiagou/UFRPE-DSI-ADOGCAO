
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/models/abrigo.dart';

class AbrigoController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registrarAbrigo(Abrigo abrigo) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('abrigos').add({
          'nome': abrigo.nome,
          'email': abrigo.email,
          'endereco': abrigo.endereco,
          'telefone': abrigo.telefone,
          'lat': abrigo.lat,
          'lng': abrigo.lng,
          'volunteerId': abrigo.volunteerId, // Associando o abrigo ao voluntário
          'createdAt': abrigo.createdAt,
        });
      } catch (e) {
        throw Exception("Erro ao registrar abrigo: $e");
      }
    } else {
      throw Exception("Usuário não autenticado");
    }
  }
}
