import 'package:cloud_firestore/cloud_firestore.dart';

class Animal {
  final String name;
  final String imageUrl;
  final String location;
  final String description;
  final String age;
  final String weight;
  final String animalType;
  double? distance;

  Animal({
    required this.name,
    required this.imageUrl,
    required this.location,
    required this.description,
    required this.age,
    required this.weight,
    required this.animalType,
  });

  factory Animal.fromDocument(DocumentSnapshot doc) {
    return Animal(
      name: doc['name'],
      location: doc['shelterId'],
      imageUrl: doc['imageUrl'],
      description: doc['description'],
      age: doc['age'],
      weight: doc['weight'],
      animalType: doc['animalType'],
    );
  }
  
}
