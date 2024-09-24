import 'package:cloud_firestore/cloud_firestore.dart';

class Animal {
  final String id;
  final String name;
  final String imageUrl;
  final String location;
  final String description;
  final String age;
  final String weight;
  final String animalType;
  final String userId; // Campo para identificar o usuário que cadastrou o animal
  double? distance;

  Animal({
    required this.id, // Adiciona o ID do animal
    required this.name,
    required this.imageUrl,
    required this.location,
    required this.description,
    required this.age,
    required this.weight,
    required this.animalType,
    required this.userId, // Adiciona o campo userId
  });

  factory Animal.fromDocument(DocumentSnapshot doc) {
    return Animal(
      id: doc.id, // Adiciona o ID do documento
      name: doc['name'],
      location: doc['shelterId'],
      imageUrl: doc['imageUrl'],
      description: doc['description'],
      age: doc['age'],
      weight: doc['weight'],
      animalType: doc['animalType'],
      userId: doc['userId'], // Adiciona o userId do documento Firestore
    );
  }
}
