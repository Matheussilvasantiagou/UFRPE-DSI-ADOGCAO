import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
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
                      image: DecorationImage(
                        image: NetworkImage(widget.animal.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
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
                                        color: Colors.grey[
                                            400], // Texto em cinza mais claro
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
                                // Botão de entrar em contato
                                GestureDetector(
                                  onTap: () {
                                    if (widget.isVolunteer) {
                                      _confirmAdoption(context);
                                    } else {
                                      // Lógica para entrar em contato
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Entrar em contato com o abrigo."),
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 180,
                                    decoration: BoxDecoration(
                                      color: widget.isVolunteer
                                          ? Colors.green
                                          : const Color(
                                              0xFF007EA7), // Verde para voluntário e azul para contato
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget.isVolunteer
                                            ? 'Animal Adotado'
                                            : 'Entrar em contato',
                                        style: const TextStyle(
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
              // Exclui o animal da base de dados
              await FirebaseFirestore.instance
                  .collection(
                      'pets') // Certifique-se de que o nome da coleção está correto
                  .doc(widget.animal.name) // Usa o docId correto do animal
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
