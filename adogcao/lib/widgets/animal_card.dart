import 'package:flutter/material.dart';
import '../models/animal.dart';
import '../views/animal_details_screen.dart';

class AnimalCard extends StatelessWidget {
  final Animal animal;
  final bool isFavorite;
  final Function toggleFavorite;

  AnimalCard(
      {required this.animal,
      required this.isFavorite,
      required this.toggleFavorite});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnimalDetailsScreen(
              animal: animal,
              isFavorite: isFavorite,
              toggleFavorite: toggleFavorite,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.grey.shade800,
        margin: EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                animal.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    animal.name,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        animal.location,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                      ),
                      onPressed: () {
                        toggleFavorite(animal);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
