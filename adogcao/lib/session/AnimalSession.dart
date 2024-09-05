class AnimalSession {
  static final AnimalSession _instance = AnimalSession._internal();

  AnimalSession._internal();

  static AnimalSession get instance => _instance;

  String? userId;
  String? animalName;
  String? animalAge;
  String? animalWeight;
  String? animalImagePath;
  String? animalType;

  void clearSession() {
    userId = null;
    animalName = null;
    animalAge = null;
    animalWeight = null;
    animalImagePath = null;
    animalType = null;
  }
}
