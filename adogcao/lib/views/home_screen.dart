import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/controllers/filterAnimalController.dart';
import 'package:flutter_application_1/controllers/login_controller.dart';
import 'package:flutter_application_1/session/UserSession.dart';
import 'package:flutter_application_1/views/edit_user_screen.dart';
import 'package:flutter_application_1/views/login_screen.dart';
import 'package:flutter_application_1/views/pets_proximos_screen.dart';
import 'package:flutter_application_1/views/filter_screen.dart';
import 'package:geocoding/geocoding.dart';
import '../models/animal.dart';
import '../controllers/favorite_controller.dart';
import '../widgets/animal_card.dart';
import 'favorite_animals_screen.dart';
import 'cadastrar_abrigo_screen.dart';
import 'abrigos_screen.dart';
import 'cadastrar_pet_screen.dart';
import 'meus_pets_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'lar_temporario_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FavoriteController _favoriteController = FavoriteController();
  final LoginController _loginController = LoginController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isVolunteer = false;
  bool isLoading = true;
  String userName = '';
  String selectedCategory = '';
  final TextEditingController _searchController = TextEditingController();
  final FilterAnimalController _filterAnimalController =
      FilterAnimalController();
  final StreamController<List<Animal>> _streamController =
      StreamController<List<Animal>>();
  String abrigo = '';
  String idade = '';
  String peso = '';
  String nome = '';
  var pets = <Animal>[];

  final List<Map<String, dynamic>> categories = [
    {'icon': 'lib/images/dog.png', 'label': 'Cachorro', 'type': 'Cachorro'},
    {'icon': 'lib/images/cat.png', 'label': 'Gato', 'type': 'Gato'},
    {'icon': 'lib/images/parrot.png', 'label': 'Pássaro', 'type': 'Pássaro'},
    {'icon': 'lib/images/rabbit.png', 'label': 'Coelho', 'type': 'Coelho'},
    {'icon': 'lib/images/horse.png', 'label': 'Cavalo', 'type': 'Cavalo'},
  ];

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
    filterPets(pets);
  }

  Future<void> fetchUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        isVolunteer = UserSession.instance.isVolunteer ?? false;
        userName = UserSession.instance.userName ?? 'Usuário';
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar saída"),
          content: const Text("Você tem certeza que deseja sair?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Sair"),
              onPressed: () {
                Navigator.of(context).pop();
                _loginController.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<Position> _getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<Location> _getCoordinatesFromAddress(String address) async {
    List<Location> locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      return locations.first;
    } else {
      throw Exception('Endereço não encontrado');
    }
  }

  double _calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    return Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
  }

  Future<List<Animal>> _sortPetsByDistance(List<Animal> pets) async {
    var currentPosition = await _getCurrentLocation();

    for (var pet in pets) {
      Location location = await _getCoordinatesFromAddress("Recife, PE");
      pet.distance = _calculateDistance(currentPosition.latitude,
          currentPosition.longitude, location.latitude, location.longitude);
    }

    pets.sort((a, b) => a.distance!.compareTo(b.distance!));

    setState(() {});

    return pets;
  }

  void filterByCategory(String category) async {
    pets = await _filterAnimalController.getFilteredAnimalsByCategory(category);
    _streamController.add(pets);
  }

  void filterPets(List<Animal> pets) async {
    pets = await _filterAnimalController.getFilteredAnimals(
        abrigo, idade, peso, nome);
    _streamController.add(pets);
  }

  void applyFilters(String? abrigo, String? idade, String? peso) {
    this.abrigo = abrigo ?? '';
    this.idade = idade ?? '';
    this.peso = peso ?? '';
    filterPets(pets);
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
            stream: _streamController.stream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Ocorreu um erro ao carregar os animais.'),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              pets = snapshot.data!;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PetsProximosScreen(),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(16.0),
                        padding: const EdgeInsets.all(16.0),
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: const NetworkImage(
                              'https://p2.trrsf.com/image/fget/cf/774/0/images.terra.com/2024/03/29/1527502278-golden-retriever.jpg',
                            ),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.5),
                              BlendMode.darken,
                            ),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Encontre o animal mais próximo de você',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    // Widget de construção de categorias com fundo branco
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategory = categories[index]['type'];
                                filterByCategory(selectedCategory);
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 4.0, vertical: 8.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                color: selectedCategory ==
                                        categories[index]['type']
                                    ? Colors.blueAccent
                                    : Colors
                                        .white, // Fundo branco para todas as categorias
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(
                                        0.1), // Sombra leve para destacar
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    categories[index]['icon'],
                                    height: 40,
                                    width: 40,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    categories[index]['label'],
                                    style: TextStyle(
                                      color: selectedCategory ==
                                              categories[index]['type']
                                          ? Colors.white
                                          : Colors
                                              .black, // Cor do texto preta para categorias não selecionadas
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    _buildSearchField(),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            if (isVolunteer)
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => _scaffoldKey.currentState!.openDrawer(),
              ),
            IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FilterScreen(
                      onApplyFilters: (nome, tipo, abrigo) {
                        applyFilters(nome, tipo, abrigo);
                      },
                    ),
                  ),
                );
              },
            ),
            if (!isVolunteer)
              IconButton(
                icon: const Icon(Icons.favorite, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FavoriteAnimalsScreen(
                        favoriteAnimals: _favoriteController.favoriteAnimals,
                        isVolunteer: isVolunteer,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
      drawer: isVolunteer
          ? Drawer(
              child: Container(
                color: const Color.fromARGB(255, 0, 13, 32),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 0, 13, 32),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Olá, $userName',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            isVolunteer ? 'Voluntário' : 'Adotante',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.pets, color: Colors.white),
                      title: const Text('Meus pets',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PetsScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.add_circle_outline,
                          color: Colors.white),
                      title: const Text('Cadastrar pet',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CadastrarPetScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.add_business, color: Colors.white),
                      title: const Text('Meus Abrigos',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AbrigosScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.add_business, color: Colors.white),
                      title: const Text('Cadastrar abrigo',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CadastrarAbrigoScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.person, color: Colors.white),
                      title: const Text('Editar perfil',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditUserScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.home, color: Colors.white),
                      title: const Text('Lar Temporário',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LarTemporarioScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.logout_rounded, color: Colors.white),
                      title: const Text('Sair',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        _confirmLogout();
                      },
                    )
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildSearchField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey[500]),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: 'Pesquisar animal',
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16,
                ),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {
                  nome = _searchController.text;
                  filterPets(pets);
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.tune, color: Colors.grey[500]),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FilterScreen(
                    onApplyFilters: (nome, tipo, abrigo) {
                      applyFilters(nome, tipo, abrigo);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
