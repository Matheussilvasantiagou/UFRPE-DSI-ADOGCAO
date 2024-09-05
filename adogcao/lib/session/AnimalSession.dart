class AnimalSession {
  static final AnimalSession _instance = AnimalSession._internal();

  AnimalSession._internal();

  static AnimalSession get instance => _instance;

  String? animalId;
  String? animalName;
  int? animalAge;
  double? animalWeight;
  String? animalImagePath;
  String? animalType;

  void clearSession() {
    animalId = null;
    animalName = null;
    animalAge = null;
    animalWeight = null;
    animalImagePath = null;
    animalType = null;
  }
}
