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
  final String userId;
  double? distance;

  // Novos campos de endereço
  final String? cep;
  final String? rua;
  final String? numero;
  final String? complemento;
  final String? bairro;
  final String? cidade;
  final String? estado;

  Animal({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.location,
    required this.description,
    required this.age,
    required this.weight,
    required this.animalType,
    required this.userId,
    this.cep,
    this.rua,
    this.numero,
    this.complemento,
    this.bairro,
    this.cidade,
    this.estado,
  });

  factory Animal.fromDocument(DocumentSnapshot doc) {
    return Animal(
      id: doc.id,
      name: doc['name'],
      location: doc['shelterId'],
      imageUrl: doc['imageUrl'],
      description: doc['description'],
      age: doc['age'],
      weight: doc['weight'],
      animalType: doc['animalType'],
      userId: doc['userId'],
      cep: doc['cep'],
      rua: doc['rua'],
      numero: doc['numero'],
      complemento: doc['complemento'],
      bairro: doc['bairro'],
      cidade: doc['cidade'],
      estado: doc['estado'],
    );
  }
}
