import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/controllers/favorite_controller.dart';
import 'package:flutter_application_1/views/edit_user_screen.dart';
import 'package:flutter_application_1/views/login_screen.dart';
import 'package:flutter_application_1/views/pets_proximos_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_application_1/controllers/filterAnimalController.dart';
import 'package:flutter_application_1/controllers/login_controller.dart';
import 'package:flutter_application_1/session/UserSession.dart';
import 'package:flutter_application_1/views/favorite_animals_screen.dart';
import 'package:flutter_application_1/widgets/animal_card.dart';
import 'filter_screen.dart';
import '../models/animal.dart';
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
  final TextEditingController _abrigoFilterController = TextEditingController();
  final TextEditingController _nomeFilterController = TextEditingController();
  final TextEditingController _tipoFilterController = TextEditingController();
  final FilterAnimalController _filterAnimalController =
      FilterAnimalController();
  final StreamController<List<Animal>> _streamController =
      StreamController<List<Animal>>();
  String nome = '';
  String tipo = '';
  String abrigo = '';
  double? peso;
  var pets = <Animal>[];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
    fetchInitialPets(); // Carrega automaticamente os animais sem filtro
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

  Future<void> fetchInitialPets() async {
    pets = await _filterAnimalController.getFilteredAnimals('', '', '');
    _streamController.add(pets);
  }

  // Função para buscar animais pelo nome, tipo e abrigo
  void filterPets(List<Animal> pets) async {
    pets = await _filterAnimalController.getFilteredAnimals(nome, tipo, abrigo);
    _streamController.add(pets);
  }

  // Função específica para buscar animais pela categoria (tipo de animal)
  void filterPetsByCategory(String category) async {
    pets = await _filterAnimalController.getFilteredAnimalsByCategory(category);
    _streamController.add(pets);
  }

  void applyFilters(String? selectedShelter, double? weight) {
    setState(() {
      abrigo = selectedShelter ?? '';
      peso = weight;
    });
    filterPets(pets);

  void filterPets(List<Animal> pets) async {
    pets = await _filterAnimalController.getFilteredAnimals(nome, tipo, abrigo);
    _streamController.add(pets);
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
                  const Color.fromARGB(255, 0, 13, 32).withAlpha(200),
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

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Nenhum pet encontrado.'));
              }

              pets = snapshot.data!;
              // pets = _sortPetsByDistance(pets);

              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Banner Superior
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PetsProximosScreen(),
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
                                'https://p2.trrsf.com/image/fget/cf/774/0/images.terra.com/2024/03/29/1527502278-golden-retriever.jpg'),
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
                    // Campo de Pesquisa e Botão de Filtro
                    Container(
                      margin: const EdgeInsets.all(16.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10.0,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) {
                                setState(() {
                                  nome = value;
                                });
                                filterPets(pets);
                              },
                              decoration: const InputDecoration(
                                hintText: 'Pesquise o animal pelo nome',
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.search),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.filter_list),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                builder: (context) {
                                  return FractionallySizedBox(
                                    heightFactor:
                                        0.7, // Tamanho da tela de filtro
                                    child: FilterScreen(
                                      onApplyFilters: (String? selectedShelter,
                                          int? selectedAge,
                                          double? selectedWeight) {
                                        // Quando os filtros são aplicados, atualizamos os parâmetros
                                        setState(() {
                                          abrigo = selectedShelter ??
                                              ''; // Abrigo selecionado, ou vazio se nulo
                                          if (selectedAge != null) {
                                            nome = selectedAge
                                                .toString(); // Aqui nome é usado como idade para filtro
                                          } else {
                                            nome = '';
                                          }
                                          peso =
                                              selectedWeight; // Peso selecionado
                                        });

                                        filterPets(
                                            pets); // Aplicar os filtros nos pets
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    // Categorias
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          categoryButton(
                              context, 'Cachorro', 'lib/images/dog.png'),
                          categoryButton(context, 'Gato', 'lib/images/cat.png'),
                          categoryButton(
                              context, 'Pássaro', 'lib/images/parrot.png'),
                          categoryButton(
                              context, 'Coelho', 'lib/images/rabbit.png'),
                          categoryButton(
                              context, 'Cavalo', 'lib/images/horse.png'),
                        ],
                      ),
                          )),
                        )),
                    ExpansionTile(
                      title: Text('Filtros'),
                      textColor: Colors.white,
                      collapsedIconColor: Colors.white,
                      collapsedTextColor: Colors.white,
                      iconColor: Colors.white,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _nomeFilterController,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(labelText: 'Nome'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _tipoFilterController,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(labelText: 'Tipo'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _abrigoFilterController,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(labelText: 'Abrigo'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              // Lógica para filtrar os resultados
                              print(
                                  'Nome: $nome, Tipo: $tipo, Abrigo: $abrigo');
                              abrigo = _abrigoFilterController.text;
                              tipo = _tipoFilterController.text;
                              nome = _nomeFilterController.text;
                              filterPets(pets);
                              setState(() {});
                            },
                            child: Text('Aplicar Filtros'),
                          ),
                        ),
                      ],
                    ),
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
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => _scaffoldKey.currentState!.openDrawer(),
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
      drawer: Drawer(
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
                    const Text(
                      'Adotante',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
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
              ListTile(
                leading: const Icon(Icons.person, color: Colors.white),
                title: const Text('Editar perfil',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditUserScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout_rounded, color: Colors.white),
                title:
                    const Text('Sair', style: TextStyle(color: Colors.white)),
                onTap: () {
                  _confirmLogout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para criar botões de categoria com ícones
  Widget categoryButton(
      BuildContext context, String category, String imagePath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          tipo = category.toLowerCase(); // Definindo a categoria selecionada
        });
        filterPetsByCategory(category
            .toLowerCase()); // Aplicando o filtro com base na categoria selecionada
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 5.0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Image.asset(
              imagePath,
              width: 40,
              height: 40,
            ),
            const SizedBox(height: 5),
            Text(
              category,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
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
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
