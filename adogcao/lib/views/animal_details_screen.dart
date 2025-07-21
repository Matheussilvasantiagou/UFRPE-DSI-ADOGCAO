import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/animal.dart';

class AnimalDetailsScreen extends StatefulWidget {
  final Animal animal;
  final bool isFavorite;
  final Function toggleFavorite;
  final bool isVolunteer;

  const AnimalDetailsScreen({
    super.key,
    required this.animal,
    required this.isFavorite,
    required this.toggleFavorite,
    required this.isVolunteer,
  });

  @override
  _AnimalDetailsScreenState createState() => _AnimalDetailsScreenState();
}

class _AnimalDetailsScreenState extends State<AnimalDetailsScreen> {
  late bool isFavorite;
  bool isOwner = false; // Verifica se o usuário logado é o dono do pet

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
    _checkOwnership();
  }

  Future<void> _checkOwnership() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        isOwner = user.uid == widget.animal.userId; // Compara userId do pet com o uid do usuário logado
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001E3C), // Cor de fundo da tela
      body: Stack(
        children: [
          // Seção superior para a imagem do animal
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: widget.animal.imageUrl.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(widget.animal.imageUrl),
                              fit: BoxFit.cover,
                              onError: (exception, stackTrace) {
                                // Fallback para imagem padrão em caso de erro
                              },
                            )
                          : null,
                      color: widget.animal.imageUrl.isEmpty 
                          ? Colors.grey[800] 
                          : null,
                    ),
                    child: widget.animal.imageUrl.isEmpty
                        ? const Center(
                            child: Icon(
                              Icons.pets,
                              size: 100,
                              color: Colors.white54,
                            ),
                          )
                        : null,
                  ),
                ),
                // Seção inferior para detalhes e botões de ação
                Expanded(
                  flex: 3,
                  child: Container(
                    color: const Color(0xFF1B2735), // Fundo cinza escuro
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Container central com detalhes do animal
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(
                                  0xFF243447), // Cor de fundo do card de detalhes
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.animal.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 21.0,
                                    color:
                                        Colors.grey[100], // Texto em cor clara
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      widget.animal.animalType,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors
                                            .grey[300], // Texto em cinza claro
                                      ),
                                    ),
                                    Text(
                                      '${widget.animal.age} anos',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors
                                            .grey[300], // Texto em cinza claro
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.lightBlueAccent,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      widget.animal.location,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[400], // Texto em cinza mais claro
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Descrição do animal
                          Text(
                            widget.animal.description,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[300], // Texto em cinza claro
                              letterSpacing: 0.7,
                            ),
                          ),
                          const SizedBox(
                              height: 150), // Espaço adicional acima dos botões
                          // Centralizar e mover os botões para cima
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Botão de favorito
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isFavorite = !isFavorite;
                                    });
                                    widget.toggleFavorite(widget.animal);
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: const Color(
                                          0xFF117A8B), // Azul esverdeado
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      isFavorite
                                          ? Icons.favorite_rounded
                                          : Icons.favorite_border_rounded,
                                      color: isFavorite
                                          ? Colors.redAccent
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                    width: 30), // Espaço entre os botões
                                // Botão de "Animal Adotado" (somente se o usuário for o dono)
                                if (isOwner)
                                  GestureDetector(
                                    onTap: () {
                                      _confirmAdoption(context);
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 180,
                                      decoration: BoxDecoration(
                                        color: Colors.green, // Verde para voluntário
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Animal Adotado',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Botões de navegação na parte superior
          Positioned(
            top: 30,
            left: 20,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: 20,
            child: IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Compartilhar detalhes do pet."),
                  ),
                );
              },
              icon: const Icon(
                Icons.ios_share,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmAdoption(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar Adoção"),
        content: const Text("Tem certeza de que este animal foi adotado?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Fecha o diálogo
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              // Exclui o animal da base de dados usando o ID correto
              await FirebaseFirestore.instance
                  .collection('pets')
                  .doc(widget.animal.id) // Usa o ID correto do documento
                  .delete();

              Navigator.of(context).pop(); // Fecha o diálogo
              Navigator.of(context).pop(); // Retorna à tela anterior

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                        Text('Animal foi marcado como adotado e excluído!')),
              );
            },
            child: const Text("Confirmar"),
          ),
        ],
      ),
    );
  }
}
