import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/animal.dart';

class AnimalDetailsScreen extends StatefulWidget {
  final Animal animal;
  final bool isFavorite;
  final Function toggleFavorite;
  final bool isVolunteer; // Adicionei essa variável

  AnimalDetailsScreen({
    required this.animal,
    required this.isFavorite,
    required this.toggleFavorite,
    required this.isVolunteer, // Recebendo essa variável
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
      backgroundColor: Color.fromARGB(255, 0, 13, 32).withAlpha(200),
      body: Column(
        children: [
          Stack(
            children: [
              Image.network(
                widget.animal.imageUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 40,
                left: 16,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.animal.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (!widget
                                .isVolunteer) // Exibe o botão de favoritar apenas se não for voluntário
                              IconButton(
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isFavorite = !isFavorite;
                                  });
                                  widget.toggleFavorite(widget.animal);
                                },
                              ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 4),
                            Text(
                              widget.animal.location,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            infoTag(widget.animal.animalType, Colors.red),
                            infoTag('${widget.animal.age} Anos', Colors.orange),
                            infoTag('${widget.animal.weight}kg', Colors.purple),
                          ],
                        ),
                        SizedBox(height: 50),
                        Text(
                          widget.animal.description,
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 250),
                        Center(
                          child: Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Ação ao clicar no botão de contato
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 24,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Text(
                                  'Entrar em contato',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () => _confirmAdoption(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 24,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Text(
                                  'Animal adotado',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget infoTag(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  void _confirmAdoption(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirmar Adoção"),
        content: Text("Tem certeza de que este animal foi adotado?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Fecha o diálogo
            child: Text("Cancelar"),
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
                SnackBar(
                    content:
                        Text('Animal foi marcado como adotado e excluído!')),
              );
            },
            child: Text("Confirmar"),
          ),
        ],
      ),
    );
  }
}
