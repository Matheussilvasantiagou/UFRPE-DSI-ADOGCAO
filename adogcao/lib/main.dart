import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/registration_screen.dart';
import 'views/login_screen.dart';
import 'widgets/pet_avatar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBvdUkpspWIeK_DweVK2UwPaDbKI0ifc0I",
        authDomain: "adogcao-9dd8c.firebaseapp.com",
        projectId: "adogcao-9dd8c",
        storageBucket: "adogcao-9dd8c.appspot.com",
        messagingSenderId: "172314211734",
        appId: "1:172314211734:web:abcd1234efgh5678ijkl90",
        measurementId: "G-XXXXXXXXXX",
      ),
    );
    print("Firebase Initialized");
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
  runApp(AdoptionApp());
}

class AdoptionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: AdoptionScreen(),
        ),
      ),
      routes: {
        '/cadastro': (context) => RegistrationScreen(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}

class AdoptionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
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
        Positioned.fill(
          child: CustomPaint(
            painter: CurvedLinesPainter(),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  PetAvatar(
                      name: 'Leo',
                      imageUrl:
                          'https://p2.trrsf.com/image/fget/cf/774/0/images.terra.com/2024/03/29/1527502278-golden-retriever.jpg'),
                  PetAvatar(
                      name: 'Tom',
                      imageUrl:
                          'https://p2.trrsf.com/image/fget/cf/774/0/images.terra.com/2024/03/29/1527502278-golden-retriever.jpg'),
                ],
              ),
              SizedBox(height: 20),
              PetAvatar(
                  name: 'Lua',
                  imageUrl:
                      'https://p2.trrsf.com/image/fget/cf/774/0/images.terra.com/2024/03/29/1527502278-golden-retriever.jpg'),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  PetAvatar(
                      name: 'Thor',
                      imageUrl:
                          'https://p2.trrsf.com/image/fget/cf/774/0/images.terra.com/2024/03/29/1527502278-golden-retriever.jpg'),
                  PetAvatar(
                      name: 'Mel',
                      imageUrl:
                          'https://p2.trrsf.com/image/fget/cf/774/0/images.terra.com/2024/03/29/1527502278-golden-retriever.jpg'),
                ],
              ),
              SizedBox(height: 50),
              Text(
                'Adote o cachorro perfeito para você!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Explore perfis de cachorros prontos para adoção e use filtros personalizados para encontrar o companheiro ideal. Comece sua jornada de adoção e encontre um amigo para a vida toda!',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/cadastro');
                },
                child: Text('Entrar', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 220, vertical: 35),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CurvedLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    Path path1 = Path();
    path1.moveTo(0, size.height * 0.20);
    path1.quadraticBezierTo(
      size.width / 2,
      size.height * 0.15,
      size.width,
      size.height * 0.20,
    );
    canvas.drawPath(path1, paint);

    Path path2 = Path();
    path2.moveTo(0, size.height * 0.30);
    path2.quadraticBezierTo(
      size.width / 2,
      size.height * 0.25,
      size.width,
      size.height * 0.30,
    );
    canvas.drawPath(path2, paint);

    Path path3 = Path();
    path3.moveTo(0, size.height * 0.40);
    path3.quadraticBezierTo(
      size.width / 2,
      size.height * 0.35,
      size.width,
      size.height * 0.40,
    );
    canvas.drawPath(path3, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
