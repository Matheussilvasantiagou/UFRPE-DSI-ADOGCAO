import 'package:cloud_firestore/cloud_firestore.dart';

import '../session/AnimalSession.dart';

class EditAnimalController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> editAnimal(Map<String, dynamic> updatedFields) async {
    try {
      if (updatedFields.isNotEmpty) {
        await _firestore
            .collection('animals')
            .doc(AnimalSession.instance.animalId)
            .update(updatedFields);

        // Atualize a sessão com os novos valores, se fornecidos
        if (updatedFields.containsKey('name')) {
          AnimalSession.instance.animalName = updatedFields['name'];
        }
        if (updatedFields.containsKey('age')) {
          AnimalSession.instance.animalAge =
              int.tryParse(updatedFields['age']) ?? 0;
        }
        if (updatedFields.containsKey('weight')) {
          AnimalSession.instance.animalWeight =
              double.tryParse(updatedFields['weight']) ?? 0.0;
        }
      }
    } catch (e) {
      throw Exception("Erro ao editar animal");
    }
  }
}
