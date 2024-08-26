import 'package:flutter/material.dart';
import '../models/animal.dart';

class FavoriteController extends ChangeNotifier {
  List<Animal> favoriteAnimals = [];

  void toggleFavorite(Animal animal) {
    if (favoriteAnimals.contains(animal)) {
      favoriteAnimals.remove(animal);
    } else {
      favoriteAnimals.add(animal);
    }
    notifyListeners();
  }

  bool isFavorite(Animal animal) {
    return favoriteAnimals.contains(animal);
  }
}
