import 'package:cloud_firestore/cloud_firestore.dart';

class Abrigo {
  final String nome;
  final String email;
  final String cep;
  final String rua;
  final String numero;
  final String? complemento;
  final String bairro;
  final String cidade;
  final String estado;
  final String telefone;
  final double lat;
  final double lng;
  final String? volunteerId;
  final Timestamp createdAt;
  String? id;

  Abrigo({
    required this.nome,
    required this.email,
    required this.cep,
    required this.rua,
    required this.numero,
    this.complemento,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.telefone,
    required this.lat,
    required this.lng,
    required this.volunteerId,
    required this.createdAt,
    this.id,
  });
}



