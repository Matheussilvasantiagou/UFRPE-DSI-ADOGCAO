import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adogcao/models/animal.dart';

class FilterAnimalController {
  Future<List<Animal>> getFilteredAnimals(
      String abrigo, String idade, String peso, String nome) async {
    try {
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
      return querySnapshot.docs.map((doc) {
        try {
          return Animal.fromDocument(doc);
        } catch (e) {
          // Se houver erro ao criar o Animal, retorna um Animal com dados padrão
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return Animal(
            id: doc.id,
            name: data['name'] ?? 'Sem nome',
            location: data['shelterId'] ?? 'Local não informado',
            imageUrl: data['imageUrl'] ?? '',
            description: data['description'] ?? 'Sem descrição',
            age: data['age'] ?? 'Idade não informada',
            weight: data['weight'] ?? 'Peso não informado',
            animalType: data['animalType'] ?? 'Tipo não informado',
            userId: data['userId'] ?? '',
          );
        }
      }).toList();
    } catch (e) {
      print('Erro ao filtrar animais: $e');
      return [];
    }
  }

  // Função específica para filtrar apenas por categoria (tipo de animal)
  Future<List<Animal>> getFilteredAnimalsByCategory(String category) async {
    try {
      Query query = FirebaseFirestore.instance.collection('pets');

      if (category.isNotEmpty) {
        query = query.where('animalType', isEqualTo: category);
      }

      QuerySnapshot querySnapshot = await query.get();
      return querySnapshot.docs.map((doc) {
        try {
          return Animal.fromDocument(doc);
        } catch (e) {
          // Se houver erro ao criar o Animal, retorna um Animal com dados padrão
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return Animal(
            id: doc.id,
            name: data['name'] ?? 'Sem nome',
            location: data['shelterId'] ?? 'Local não informado',
            imageUrl: data['imageUrl'] ?? '',
            description: data['description'] ?? 'Sem descrição',
            age: data['age'] ?? 'Idade não informada',
            weight: data['weight'] ?? 'Peso não informado',
            animalType: data['animalType'] ?? 'Tipo não informado',
            userId: data['userId'] ?? '',
          );
        }
      }).toList();
    } catch (e) {
      print('Erro ao filtrar animais por categoria: $e');
      return [];
    }
  }

  // Função para buscar todas as opções de abrigos
  Future<List<String>> getShelters() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('pets').get();
      Set<String> shelters = {};
      
      for (var doc in querySnapshot.docs) {
        try {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          String? shelterId = data['shelterId'];
          if (shelterId != null && shelterId.isNotEmpty) {
            shelters.add(shelterId);
          }
        } catch (e) {
          // Ignora documentos com erro
          continue;
        }
      }
      
      return shelters.toList();
    } catch (e) {
      print('Erro ao buscar abrigos: $e');
      return [];
    }
  }

  // Função para buscar todas as opções de idades dos animais
  Future<List<String>> getAges() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('pets').get();
      Set<String> ages = {};
      
      for (var doc in querySnapshot.docs) {
        try {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          String? age = data['age'];
          if (age != null && age.isNotEmpty) {
            ages.add(age);
          }
        } catch (e) {
          // Ignora documentos com erro
          continue;
        }
      }
      
      return ages.toList();
    } catch (e) {
      print('Erro ao buscar idades: $e');
      return [];
    }
  }

  // Função para buscar todas as opções de pesos dos animais
  Future<List<String>> getWeights() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('pets').get();
      Set<String> weights = {};
      
      for (var doc in querySnapshot.docs) {
        try {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          String? weight = data['weight'];
          if (weight != null && weight.isNotEmpty) {
            weights.add(weight);
          }
        } catch (e) {
          // Ignora documentos com erro
          continue;
        }
      }
      
      return weights.toList();
    } catch (e) {
      print('Erro ao buscar pesos: $e');
      return [];
    }
  }
}
