import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/animal.dart';

class FilterAnimalController {
  Future<List<Animal>> getFilteredAnimals(
      String abrigo, String idade, String peso, String nome) async {
    Query query = FirebaseFirestore.instance.collection('pets');

    if (abrigo.isNotEmpty) {
      query = query.where('shelterId', isEqualTo: abrigo);
    }
    if (idade.isNotEmpty) {
      query = query.where('age', isEqualTo: idade);
    }
    if (peso.isNotEmpty) {
      query = query.where('weight', isEqualTo: peso);
    }
    if (nome.isNotEmpty) {
      query = query.where('name', isEqualTo: nome);
    }

    QuerySnapshot querySnapshot = await query.get();
    return querySnapshot.docs.map((doc) => Animal.fromDocument(doc)).toList();
  }

  // Função específica para filtrar apenas por categoria (tipo de animal)
  Future<List<Animal>> getFilteredAnimalsByCategory(String category) async {
    Query query = FirebaseFirestore.instance.collection('pets');

    if (category.isNotEmpty) {
      query = query.where('animalType', isEqualTo: category);
    }

    QuerySnapshot querySnapshot = await query.get();
    return querySnapshot.docs.map((doc) => Animal.fromDocument(doc)).toList();
  }

  // Função para buscar todas as opções de abrigos
  Future<List<String>> getShelters() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('pets').get();
    return querySnapshot.docs
        .map((doc) => doc['shelterId'] as String)
        .toSet()
        .toList();
  }

  // Função para buscar todas as opções de idades dos animais
  Future<List<String>> getAges() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('pets').get();
    return querySnapshot.docs
        .map((doc) => doc['age'] as String)
        .toSet()
        .toList(); // Elimina duplicatas com .toSet()
  }

  // Função para buscar todas as opções de pesos dos animais
  Future<List<String>> getWeights() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('pets').get();
    return querySnapshot.docs
        .map((doc) => doc['weight'] as String)
        .toSet()
        .toList(); // Elimina duplicatas com .toSet()
  }
}
