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
  // String userName = '';

  // @override
  // void initState() {
  //   super.initState();
  // }

  Future<Position> _getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<Location> _getCoordinatesFromAddress(String address) async {
    List<Location> locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      return locations.first;
    } else {
      throw Exception('Endereço não encontrado');
    }
  }

  double _calculateDistance(double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
    return Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);
  }

void _sortPetsByDistance(List<Animal> pets) async {

  var currentPosition =  await _getCurrentLocation();

  for (var pet in pets) {

    var querySnapshot = await FirebaseFirestore.instance
         .collection('abrigos')
         .where('nome', isEqualTo: pet.location)
         .get();

     if (querySnapshot.docs.isNotEmpty) {
       var abrigoData = querySnapshot.docs.first.data();
       var lat = abrigoData['lat'];
       var lng = abrigoData['lng'];
      
      if(lat != null && lng != null)
      {
        pet.distance = _calculateDistance(
          currentPosition.latitude,
          currentPosition.longitude,
          abrigoData['lat'],
          abrigoData['lng'],
        );
      }else{
        pet.distance = 10000000000000;
      }

    }
 
  }

  setState(() {
    pets.sort((a, b) => a.distance!.compareTo(b.distance!));
  });

  print(pets[0].name);

}

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black,
                  const Color.fromARGB(255, 0, 13, 32).withAlpha(200)
                ],
              ),
            ),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('pets').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Ocorreu um erro ao carregar os animais.'),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('Nenhum pet encontrado.'));
              }

              var pets = snapshot.data!.docs.map((doc) {
                return Animal(
                  id: doc.id,
                  name: doc['name'],
                  location: doc['shelterId'], // ou outra propriedade que represente o local
                  imageUrl: doc['imageUrl'],
                  description: doc['description'],
                  age: doc['age'],
                  weight: doc['weight'],
                  animalType: doc['animalType'],
                  userId: doc['userId'], 
                );
              }).toList();

              return SingleChildScrollView(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: (){
                        _sortPetsByDistance(pets);
                      },
                    style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                    ),
                    child: Text('Encontrar animais próximos',style: TextStyle(color: Colors.white))
                  ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: pets.length,
                      itemBuilder: (context, index) {
                        return AnimalCard(
                          animal: pets[index],
                          isFavorite:
                              _favoriteController.isFavorite(pets[index]),
                          toggleFavorite: _favoriteController.toggleFavorite,
                          isVolunteer: isVolunteer,
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
