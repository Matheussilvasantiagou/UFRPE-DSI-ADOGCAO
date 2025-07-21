import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CadastrarPetController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para buscar os abrigos do usuário logado
  Future<List<String>> getShelters() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Consulta ao Firestore filtrando pelo volunteerId que corresponde ao ID do usuário logado
      QuerySnapshot snapshot = await _firestore
          .collection('abrigos')
          .where('volunteerId', isEqualTo: user.uid)
          .get();

      // Retorna uma lista com os nomes dos abrigos associados ao usuário logado
      return snapshot.docs.map((doc) => doc['nome'].toString()).toList();
    } else {
      return [];
    }
  }

  // Método para cadastrar um novo pet
  Future<void> registerPet({
    required String name,
    required String age,
    required String weight,
    required String animalType,
    required String shelterId,
    String? description,
    String? imageUrl, 
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _firestore.collection('pets').add({
        'name': name,
        'age': age,
        'weight': weight,
        'animalType': animalType,
        'shelterId': shelterId,
        'description': description ?? '',
        'imageUrl': imageUrl,
        'userId': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
      }).then((docRef) {
        // Adiciona o ID do documento gerado ao pet
        _firestore.collection('pets').doc(docRef.id).update({
          'id': docRef.id,
        });
      });
    }
  }
}
