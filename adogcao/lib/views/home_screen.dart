import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/session/UserSession.dart';
import '../models/animal.dart';
import '../controllers/favorite_controller.dart';
import '../widgets/animal_card.dart';
import 'favorite_animals_screen.dart';
import 'cadastrar_abrigo_screen.dart'; // Import da tela de cadastro de abrigo

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FavoriteController _favoriteController = FavoriteController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isVolunteer = false;
  bool isLoading = true;
  String userName = ''; // Variável para armazenar o nome do usuário

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        isVolunteer = userDoc['isVolunteer'] ?? false;
        userName = userDoc['name'] ?? 'Usuário'; // Obtendo o nome do usuário
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
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
                  Color.fromARGB(255, 0, 13, 32).withAlpha(200)
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(16.0),
                  padding: EdgeInsets.all(16.0),
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://p2.trrsf.com/image/fget/cf/774/0/images.terra.com/2024/03/29/1527502278-golden-retriever.jpg'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.5),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Encontre o animal mais próximo de você ${UserSession.instance.isVolunteer}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    AnimalCard(
                      animal: Animal(
                        name: 'Max',
                        location: 'Abrigo Abreu e Lima',
                        imageUrl:
                            'https://purina.com.br/sites/default/files/styles/webp/public/2023-05/protecao-animal-dia-internacional-dos-direitos-dos-animais.jpg.webp?itok=xWyTy5LD',
                      ),
                      isFavorite: _favoriteController.isFavorite(Animal(
                        name: 'Max',
                        location: 'Abrigo Abreu e Lima',
                        imageUrl:
                            'https://purina.com.br/sites/default/files/styles/webp/public/2023-05/protecao-animal-dia-internacional-dos-direitos-dos-animais.jpg.webp?itok=xWyTy5LD',
                      )),
                      toggleFavorite: _favoriteController.toggleFavorite,
                    ),
                    // Adicione outros AnimalCard aqui
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            if (isVolunteer)
              IconButton(
                icon: Icon(Icons.menu, color: Colors.white),
                onPressed: () => _scaffoldKey.currentState!.openDrawer(),
              ),
            IconButton(
              icon: Icon(Icons.filter_list, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/filter');
              },
            ),
            if (!isVolunteer)
              IconButton(
                icon: Icon(Icons.favorite, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FavoriteAnimalsScreen(
                        favoriteAnimals: _favoriteController.favoriteAnimals,
                      ),
                    ),
                  );
                },
              ),
            IconButton(
              icon: Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
      drawer: isVolunteer
          ? Drawer(
              child: Container(
                color: Color.fromARGB(255, 0, 13, 32),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade900,
                      ),
                      child: Text(
                        'Olá, $userName', // Exibe o nome do usuário logado
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                    ),
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade900,
                      ),
                      child: Text(
                        'Perfil: ${UserSession.instance.isVolunteer?'Voluntário':'Adotante'}', // Exibe o nome do usuário logado
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                    ),
                    ListTile(
                      leading: Icon(Icons.pets, color: Colors.white),
                      title: Text('Meus pets', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.pushNamed(context, '/meusPets');
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.add_circle_outline, color: Colors.white),
                      title: Text('Cadastrar pet',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.pushNamed(context, '/cadastrarPet');
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.home, color: Colors.white),
                      title: Text('Meus abrigos',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.pushNamed(context, '/meusAbrigos');
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.add_business, color: Colors.white),
                      title: Text('Cadastrar abrigo',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CadastrarAbrigoScreen(), // Navega para a tela de cadastro de abrigo
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
