import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import '../models/animal.dart';
import '../controllers/favorite_controller.dart';
import '../widgets/animal_card.dart';
import 'package:geolocator/geolocator.dart';

class PetsProximosScreen extends StatefulWidget {
  const PetsProximosScreen({super.key});

  @override
  _PetsProximosScreenState createState() => _PetsProximosScreenState();
}

class _PetsProximosScreenState extends State<PetsProximosScreen> {
  final FavoriteController _favoriteController = FavoriteController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isVolunteer = false;
  bool isLoading = false;
  List<Animal> sortedPets = [];
  bool isSorted = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }
  }

  Future<Position?> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Serviço de localização está desativado. Ative a localização do dispositivo.'),
            backgroundColor: Colors.red,
          ),
        );
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Permissão de localização negada.'),
              backgroundColor: Colors.red,
            ),
          );
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permissão de localização negada permanentemente. Libere nas configurações do dispositivo.'),
            backgroundColor: Colors.red,
          ),
        );
        return null;
      }

      return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao obter localização: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }
  }

  double _calculateDistance(double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
    return Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);
  }

  Future<void> _sortPetsByDistance(List<Animal> pets) async {
    setState(() {
      isLoading = true;
    });

    try {
      Position? currentPosition = await _getCurrentLocation();
      if (currentPosition == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      List<Animal> petsWithDistance = [];

      for (Animal pet in pets) {
        try {
          // Buscar o abrigo pelo shelterId
          DocumentSnapshot abrigoDoc = await FirebaseFirestore.instance
              .collection('abrigos')
              .doc(pet.location) // Assumindo que location é o ID do abrigo
              .get();

          if (abrigoDoc.exists) {
            Map<String, dynamic> abrigoData = abrigoDoc.data() as Map<String, dynamic>;
            double? lat = abrigoData['lat']?.toDouble();
            double? lng = abrigoData['lng']?.toDouble();

            if (lat != null && lng != null) {
              pet.distance = _calculateDistance(
                currentPosition.latitude,
                currentPosition.longitude,
                lat,
                lng,
              );
            } else {
              pet.distance = double.infinity;
            }
          } else {
            pet.distance = double.infinity;
          }
        } catch (e) {
          pet.distance = double.infinity;
        }
        petsWithDistance.add(pet);
      }

      petsWithDistance.sort((a, b) => (a.distance ?? double.infinity).compareTo(b.distance ?? double.infinity));

      setState(() {
        sortedPets = petsWithDistance;
        isSorted = true;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao calcular distâncias: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Pets Próximos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0F172A),
                Color(0xFF1E293B),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F172A),
              Color(0xFF1E293B),
              Color(0xFF334155),
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('pets').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red[300],
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Ocorreu um erro ao carregar os animais.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF3B82F6),
                  ),
                );
              }

              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.pets_outlined,
                        color: Colors.white.withOpacity(0.5),
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Nenhum pet encontrado.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              List<Animal> pets = snapshot.data!.docs.map((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                return Animal(
                  id: doc.id,
                  name: data['name'] ?? 'Sem nome',
                  location: data['shelterId'] ?? 'Local não informado',
                  imageUrl: data['imageUrl'] ?? '',
                  description: data['description'] ?? 'Sem descrição',
                  age: data['age'] ?? 'Idade não informada',
                  weight: data['weight'] ?? 'Peso não informado',
                  animalType: data['animalType'] ?? 'Tipo não informado',
                  userId: data['userId'] ?? '',
                );
              }).toList();

              return Column(
                children: [
                  const SizedBox(height: 20),
                  
                  // Botão para ordenar por distância
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : () => _sortPetsByDistance(pets),
                      icon: isLoading 
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.location_on),
                      label: Text(
                        isLoading 
                            ? 'Calculando distâncias...'
                            : isSorted 
                                ? 'Recalcular distâncias'
                                : 'Encontrar animais próximos',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Lista de pets
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: isSorted ? sortedPets.length : pets.length,
                      itemBuilder: (context, index) {
                        Animal animal = isSorted ? sortedPets[index] : pets[index];
                        return AnimalCard(
                          animal: animal,
                          isFavorite: _favoriteController.isFavorite(animal),
                          toggleFavorite: _favoriteController.toggleFavorite,
                          isVolunteer: isVolunteer,
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
