import 'package:cloud_firestore/cloud_firestore.dart';


class EditAnimalController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> editAnimal(
      String docId, String name, String age, String weight, String imageUrl) async {
    try {
      // Verifica se o docId foi fornecido
      if (docId.isEmpty) {
        throw Exception('Document ID não encontrado.');
      }

      // Atualiza o documento do animal usando o docId
      await _firestore.collection('pets').doc(docId).update({
        'name': name,
        'age': age,
        'weight': weight,
        'imageUrl': imageUrl,
      });
    } catch (e) {
      print('Erro ao salvar dados: ${e.toString()}');
      throw Exception("Erro ao editar animal: ${e.toString()}");
    }
  }
}
