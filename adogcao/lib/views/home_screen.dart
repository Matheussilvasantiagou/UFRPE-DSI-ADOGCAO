import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adogcao/controllers/filterAnimalController.dart';
import 'package:adogcao/controllers/login_controller.dart';
import 'package:adogcao/session/UserSession.dart';
import 'package:adogcao/views/edit_user_screen.dart';
import 'package:adogcao/views/view_profile_screen.dart';
import 'package:adogcao/views/login_screen.dart';
import 'package:adogcao/views/pets_proximos_screen.dart';
import 'package:adogcao/views/filter_screen.dart';
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
    // Inicializar o stream com uma lista vazia
    _streamController.add(<Animal>[]);
    fetchUserDetails();
    // Carregar pets após buscar detalhes do usuário
    _loadPets();
  }

  Future<void> _loadPets() async {
    try {
      await filterPets(pets);
    } catch (e) {
      print('Erro ao carregar pets: $e');
      // Em caso de erro, adicionar lista vazia ao stream
      _streamController.add(<Animal>[]);
    }
  }

  Future<void> fetchUserDetails() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          var userData = userDoc.data() as Map<String, dynamic>;
          setState(() {
            isVolunteer = userData['isVolunteer'] ?? false;
            userName = userData['name'] ?? 'Usuário';
            isLoading = false;
          });
        } else {
          setState(() {
            isVolunteer = false;
            userName = 'Usuário';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isVolunteer = false;
          userName = 'Usuário';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Erro ao buscar detalhes do usuário: $e');
      setState(() {
        isVolunteer = false;
        userName = 'Usuário';
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

  Future<void> filterByCategory(String category) async {
    try {
      List<Animal> filteredPets = await _filterAnimalController.getFilteredAnimalsByCategory(category);
      pets = filteredPets;
      _streamController.add(filteredPets);
    } catch (e) {
      print('Erro ao filtrar por categoria: $e');
      _streamController.add(<Animal>[]);
    }
  }

  Future<void> filterPets(List<Animal> pets) async {
    try {
      List<Animal> filteredPets = await _filterAnimalController.getFilteredAnimals(
          abrigo, idade, peso, nome);
      this.pets = filteredPets;
      _streamController.add(filteredPets);
    } catch (e) {
      print('Erro ao filtrar pets: $e');
      _streamController.add(<Animal>[]);
    }
  }

  Future<void> applyFilters(String? abrigo, String? idade, String? peso) async {
    this.abrigo = abrigo ?? '';
    this.idade = idade ?? '';
    this.peso = peso ?? '';
    await filterPets(pets);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Olá, $userName',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.person, color: Colors.white),
            onSelected: (value) {
              switch (value) {
                case 'view_profile':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ViewProfileScreen(),
                    ),
                  );
                  break;
                case 'edit_profile':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditUserScreen(),
                    ),
                  );
                  break;
                case 'logout':
                  _confirmLogout();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'view_profile',
                child: Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 8),
                    Text('Ver perfil'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'edit_profile',
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Text('Editar perfil'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Sair'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
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
          StreamBuilder<List<Animal>>(
            stream: _streamController.stream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Ocorreu um erro ao carregar os animais.'),
                );
              }

              if (!snapshot.hasData) {
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
                                // Verifica se a categoria selecionada é a mesma que já está selecionada
                                if (selectedCategory ==
                                    categories[index]['type']) {
                                  // Se sim, desmarca o filtro
                                  selectedCategory = '';
                                  // Carrega todos os pets
                                  filterPets(pets);
                                } else {
                                  // Se não, seleciona a nova categoria
                                  selectedCategory = categories[index]['type'];
                                  filterByCategory(selectedCategory);
                                }
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.all(8.0),
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: selectedCategory ==
                                        categories[index]['type']
                                    ? Colors.blueAccent
                                    : Colors
                                        .white, // Fundo branco para categorias não selecionadas
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
                                    height: 30,
                                    width: 30,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    categories[index]['label'],
                                    style: TextStyle(
                                      color: selectedCategory ==
                                              categories[index]['type']
                                          ? Colors.white
                                          : Colors
                                              .black, // Texto preto para categorias não selecionadas
                                      fontSize: 12,
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
