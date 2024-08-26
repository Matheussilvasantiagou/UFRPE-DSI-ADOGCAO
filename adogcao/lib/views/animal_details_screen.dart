import 'package:flutter/material.dart';
import '../models/animal.dart';

class AnimalDetailsScreen extends StatefulWidget {
  final Animal animal;
  final bool isFavorite;
  final Function toggleFavorite;

  AnimalDetailsScreen({
    required this.animal,
    required this.isFavorite,
    required this.toggleFavorite,
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
                            infoTag('Macho', Colors.red),
                            infoTag('2 Anos', Colors.orange),
                            infoTag('7kg', Colors.purple),
                          ],
                        ),
                        SizedBox(height: 50),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(
                                'https://www.zarla.com/images/zarla-mia-casa-1x1-2400x2400-20231101-wgghx7rchckw9v4wqgqh.png?crop=1:1,smart&width=250&dpr=2',
                              ),
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Abrigo Abreu e Lima',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  'Informações do abrigo',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 50),
                        Text(
                          'Lorem ipsum dolor sit amet. Et maiores quia ut architecto debitis in dolores dicta id rerum maiores sit recusandae distinctio aut corporis debitis.',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 50),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // Ação ao clicar no botão de contato
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(
                                horizontal: 140,
                                vertical: 35,
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
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
}
