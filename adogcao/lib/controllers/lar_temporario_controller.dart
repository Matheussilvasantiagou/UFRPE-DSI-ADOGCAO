import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LarTemporarioController {
  // Verifica se o usuário já possui um lar temporário e retorna o larId
  Future<String?> isUserLarTemporario() async {
    try {
      var userId = FirebaseAuth.instance.currentUser!.uid;
      var result = await FirebaseFirestore.instance
          .collection('lar_temporario')
          .where('uid', isEqualTo: userId)
          .get();

      if (result.docs.isNotEmpty) {
        return result.docs.first.id; // Retorna o larId se o usuário possuir um lar temporário
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao verificar o lar temporário: $e');
    }
  }

  // Cancela (exclui) o lar temporário do usuário
  Future<void> cancelarLarTemporario(String larId) async {
    try {
      await FirebaseFirestore.instance
          .collection('lar_temporario')
          .doc(larId)
          .delete();
    } catch (e) {
      throw Exception('Erro ao cancelar o lar temporário: $e');
    }
  }

  // Obtém a lista de todos os lares temporários cadastrados
  Stream<QuerySnapshot> getLaresTemporarios() {
    try {
      return FirebaseFirestore.instance.collection('lar_temporario').snapshots();
    } catch (e) {
      throw Exception('Erro ao buscar lares temporários: $e');
    }
  }

  // Cadastra um novo lar temporário
  Future<void> cadastrarLarTemporario({
    required String endereco,
    required double latitude,
    required double longitude,
    required List<String> tiposAnimais,
    required int capacidade,
  }) async {
    try {
      var userId = FirebaseAuth.instance.currentUser!.uid;
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      await FirebaseFirestore.instance.collection('lar_temporario').add({
        'uid': userId,
        'nome': userDoc['name'],
        'telefone': userDoc['phoneNumber'],
        'endereco': endereco,
        'latitude': latitude,
        'longitude': longitude,
        'tiposAnimais': tiposAnimais,
        'capacidade': capacidade,
      });
    } catch (e) {
      throw Exception('Erro ao cadastrar o lar temporário: $e');
    }
  }
}
