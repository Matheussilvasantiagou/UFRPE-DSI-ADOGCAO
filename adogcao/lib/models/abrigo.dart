import 'package:cloud_firestore/cloud_firestore.dart';

class Abrigo
{
  final String nome;
  final String email;
  final String endereco;
  final String telefone;
  final double lat;
  final double lng;
  final String? volunteerId;
  final Timestamp createdAt;
  String? id;

  Abrigo({
    required this.nome,
    required this.email,
    required this.endereco,
    required this.telefone,
    required this.lat,
    required this.lng,
    required this.volunteerId,
    required this.createdAt,
    this.id,
  });
}



