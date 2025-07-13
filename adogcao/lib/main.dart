import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'views/registration_screen.dart';
import 'views/login_screen.dart';
import 'views/home_screen.dart';
import 'widgets/pet_avatar.dart';
import 'session/UserSession.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCnrIaWPLaTizXxJfcKveVoQJYi-FY3yq4",
        authDomain: "adogcao-1b54a.firebaseapp.com",
        projectId: "adogcao-1b54a",
        storageBucket: "adogcao-1b54a.appspot.com",
        messagingSenderId: "200884834778",
        appId: "1:200884834778:web:adogcao-app",
        measurementId: "G-XXXXXXXXXX",
      ),
    );
    debugPrint("Firebase inicializado com sucesso");
  } catch (e) {
    debugPrint("Erro ao inicializar Firebase: $e");
  }
  
  // Inicializar a sessão do usuário
  await UserSession.instance.initialize();
  
  runApp(const AdoptionApp());
}

class AdoptionApp extends StatelessWidget {
  const AdoptionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adogção',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
      routes: {
        '/cadastro': (context) => const RegistrationScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.longAnimationDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();

    // Verificar se o usuário já está logado
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        if (UserSession.instance.isLoggedIn) {
          // Se já está logado, vai direto para a home
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // Se não está logado, vai para a tela de login
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: Stack(
          children: [
            // Linhas decorativas animadas
            Positioned.fill(
              child: CustomPaint(
                painter: CurvedLinesPainter(),
              ),
            ),
            
            // Conteúdo principal
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo/Ícone do app
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.accentColor.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.pets,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Título do app
                      const Text(
                        'Adogção',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Subtítulo
                      const Text(
                        'Encontre seu companheiro perfeito',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 60),
                      
                      // Avatares dos pets animados
                      _buildPetAvatars(),
                      
                      const SizedBox(height: 40),
                      
                      // Indicador de carregamento
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetAvatars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildAnimatedPetAvatar('Leo', 'https://p2.trrsf.com/image/fget/cf/774/0/images.terra.com/2024/03/29/1527502278-golden-retriever.jpg'),
        _buildAnimatedPetAvatar('Tom', 'lib/images/tom.png', isAsset: true),
        _buildAnimatedPetAvatar('Lua', 'lib/images/lua.png', isAsset: true),
      ],
    );
  }

  Widget _buildAnimatedPetAvatar(String name, String imageUrl, {bool isAsset = false}) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + (name.length * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: PetAvatar(
            name: name,
            imageUrl: imageUrl,
            isAssetImage: isAsset,
          ),
        );
      },
    );
  }
}

class CurvedLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Linha superior
    final path1 = Path();
    path1.moveTo(0, size.height * 0.15);
    path1.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.10,
      size.width,
      size.height * 0.15,
    );
    canvas.drawPath(path1, paint);

    // Linha média
    final path2 = Path();
    path2.moveTo(0, size.height * 0.25);
    path2.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.20,
      size.width,
      size.height * 0.25,
    );
    canvas.drawPath(path2, paint);

    // Linha inferior
    final path3 = Path();
    path3.moveTo(0, size.height * 0.35);
    path3.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.30,
      size.width,
      size.height * 0.35,
    );
    canvas.drawPath(path3, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
