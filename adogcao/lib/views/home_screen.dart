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

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
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
  
  // Animações
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> categories = [
    {'icon': 'lib/images/dog.png', 'label': 'Cachorro', 'type': 'Cachorro', 'color': Color(0xFF4F46E5)},
    {'icon': 'lib/images/cat.png', 'label': 'Gato', 'type': 'Gato', 'color': Color(0xFF7C3AED)},
    {'icon': 'lib/images/parrot.png', 'label': 'Pássaro', 'type': 'Pássaro', 'color': Color(0xFF059669)},
    {'icon': 'lib/images/rabbit.png', 'label': 'Coelho', 'type': 'Coelho', 'color': Color(0xFFDC2626)},
    {'icon': 'lib/images/horse.png', 'label': 'Cavalo', 'type': 'Cavalo', 'color': Color(0xFFD97706)},
  ];

  @override
  void initState() {
    super.initState();
    
    // Inicializar animações
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    // Inicializar o stream com uma lista vazia
    _streamController.add(<Animal>[]);
    fetchUserDetails();
    // Carregar pets após buscar detalhes do usuário
    _loadPets();
    
    // Iniciar animações
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text("Confirmar saída"),
          content: const Text("Você tem certeza que deseja sair?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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
      return Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF10B981)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.pets,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Carregando...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            'Olá, $userName',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.person, color: Colors.white, size: 28),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
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
                      Icon(Icons.person, color: Color(0xFF3B82F6)),
                      SizedBox(width: 12),
                      Text('Ver perfil'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'edit_profile',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Color(0xFF10B981)),
                      SizedBox(width: 12),
                      Text('Editar perfil'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Color(0xFFEF4444)),
                      SizedBox(width: 12),
                      Text('Sair'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
        child: StreamBuilder<List<Animal>>(
          stream: _streamController.stream,
          builder: (context, snapshot) {
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

            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF3B82F6),
                ),
              );
            }

            pets = snapshot.data!;

            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 100),
                      
                      // Hero Card - Encontre o animal mais próximo
                      _buildHeroCard(),
                      
                      const SizedBox(height: 24),
                      
                      // Categorias
                      _buildCategoriesSection(),
                      
                      const SizedBox(height: 24),
                      
                      // Campo de busca
                      _buildSearchField(),
                      
                      const SizedBox(height: 24),
                      
                      // Grid de animais
                      _buildAnimalsGrid(),
                      
                      const SizedBox(height: 100), // Espaço para o bottom navigation
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.9),
              Colors.black.withOpacity(0.7),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              if (isVolunteer)
                _buildBottomBarButton(
                  icon: Icons.menu,
                  onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                ),
              _buildBottomBarButton(
                icon: Icons.filter_list,
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
                _buildBottomBarButton(
                  icon: Icons.favorite,
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
      ),
      drawer: isVolunteer
          ? Drawer(
              child: Container(
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
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF10B981)],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.pets,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 16),
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
                    _buildDrawerItem(
                      icon: Icons.pets,
                      title: 'Meus pets',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PetsScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.add_circle_outline,
                      title: 'Cadastrar pet',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CadastrarPetScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.add_business,
                      title: 'Meus Abrigos',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AbrigosScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.add_business,
                      title: 'Cadastrar abrigo',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CadastrarAbrigoScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.person,
                      title: 'Editar perfil',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditUserScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.logout_rounded,
                      title: 'Sair',
                      onTap: () {
                        _confirmLogout();
                      },
                      isLogout: true,
                    )
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildHeroCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PetsProximosScreen(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Imagem de fundo
              Positioned.fill(
                child: Image.network(
                  'https://images.unsplash.com/photo-1450778869180-41d0601e046e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
                  fit: BoxFit.cover,
                ),
              ),
              // Gradiente sobreposto
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              // Conteúdo
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6).withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Encontre o animal mais próximo de você',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Descubra pets disponíveis na sua região',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Categorias',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategory == category['type'];
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (selectedCategory == category['type']) {
                      selectedCategory = '';
                      filterPets(pets);
                    } else {
                      selectedCategory = category['type'];
                      filterByCategory(selectedCategory);
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              category['color'],
                              category['color'].withOpacity(0.7),
                            ],
                          )
                        : null,
                    color: isSelected ? null : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: isSelected
                        ? Border.all(
                            color: category['color'].withOpacity(0.3),
                            width: 2,
                          )
                        : null,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: category['color'].withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withOpacity(0.2)
                              : Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.asset(
                          category['icon'],
                          height: 24,
                          width: 24,
                          color: isSelected ? Colors.white : Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category['label'],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(
            Icons.search,
            color: Colors.white.withOpacity(0.7),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: 'Pesquisar animal...',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onChanged: (value) {
                setState(() {
                  nome = _searchController.text;
                  filterPets(pets);
                });
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                Icons.tune,
                color: Colors.white.withOpacity(0.8),
                size: 20,
              ),
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
          ),
        ],
      ),
    );
  }

  Widget _buildAnimalsGrid() {
    if (pets.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(
              Icons.pets_outlined,
              color: Colors.white.withOpacity(0.5),
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum animal encontrado',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tente ajustar os filtros ou categorias',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: pets.length,
      itemBuilder: (context, index) {
        return AnimalCard(
          animal: pets[index],
          isFavorite: _favoriteController.isFavorite(pets[index]),
          toggleFavorite: _favoriteController.toggleFavorite,
          isVolunteer: isVolunteer,
        );
      },
    );
  }

  Widget _buildBottomBarButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 24),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isLogout
            ? Colors.red.withOpacity(0.1)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout ? Colors.red[300] : Colors.white70,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isLogout ? Colors.red[300] : Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
