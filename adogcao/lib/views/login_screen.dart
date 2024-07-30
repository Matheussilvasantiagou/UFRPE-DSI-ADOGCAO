import 'package:flutter/material.dart';
import '../controllers/login_controller.dart';
import 'home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Certifique-se de adicionar esta importação

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController _controller = LoginController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Entrar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/cadastro');
                    },
                    child: Text(
                      'Crie uma conta ou Cadastre-se',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 55),
                  Text('Email', style: TextStyle(color: Colors.grey.shade500)),
                  SizedBox(height: 3),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Digite seu email',
                      hintStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.grey.shade800,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.grey.shade600, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.grey.shade600, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.grey.shade600, width: 1),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 25),
                  Text('Senha', style: TextStyle(color: Colors.grey.shade500)),
                  SizedBox(height: 3),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: 'Digite sua senha',
                      hintStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.grey.shade800,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.grey.shade600, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.grey.shade600, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.grey.shade600, width: 1),
                      ),
                    ),
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 25),
                  Row(
                    children: [
                      Checkbox(
                        value: _controller.agreeToTerms,
                        onChanged: (value) {
                          setState(() {
                            _controller.toggleAgreeToTerms(value!);
                          });
                        },
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Ação para exibir os termos de uso
                          },
                          child: Text(
                            'Eu li e concordo com os termos de uso',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 70),
                  Center(
                    child: ElevatedButton(
                      onPressed: _controller.agreeToTerms
                          ? () async {
                              String email = _emailController.text;
                              String password = _passwordController.text;
                              try {
                                UserCredential? userCredential = await _controller.loginUser(
                                  email: email,
                                  password: password,
                                );
                                if (userCredential != null) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeScreen(),
                                    ),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Erro ao fazer login: $e'),
                                  ),
                                );
                              }
                            }
                          : null,
                      child: Text('Entrar', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _controller.agreeToTerms
                            ? Colors.blue
                            : Colors.blue,
                        padding: EdgeInsets.symmetric(horizontal: 220, vertical: 35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
