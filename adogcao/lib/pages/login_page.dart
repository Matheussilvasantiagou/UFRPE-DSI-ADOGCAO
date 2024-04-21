import 'package:adogcao/components/my_button.dart';
import 'package:flutter/material.dart';
import 'package:adogcao/components/my_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _validateUsuario = false;
  bool _validatePassword = false;

  void signUserIn() {
    setState(() {
      _validatePassword = passwordController.text.isEmpty;
      final bool validateUsuarioFormat = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(passwordController.text);
      _validateUsuario =
          (usernameController.text.isEmpty) && !validateUsuarioFormat;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment(6.123234262925839e-17, 1),
              end: Alignment(-1, 6.123234262925839e-17),
              colors: [
                Color.fromRGBO(22, 22, 24, 1),
                Color.fromRGBO(30, 38, 51, 1)
              ]),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Image.asset(
                    'lib/images/logo.jpeg',
                    width: 150,
                    height: 150,
                  ),

                  const SizedBox(height: 50),

                  const Text(
                  'Entrar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                  ),
                ),

                  const SizedBox(height: 25),

                  MyTextField(
                    controller: usernameController,
                    hintText: 'Email',
                    obscureText: false,
                    errorText: _validateUsuario ? "Campo email inválido" : null,
                  ),

                  const SizedBox(height: 10),

                  MyTextField(
                    controller: passwordController,
                    hintText: 'Senha',
                    obscureText: true,
                    errorText:
                        _validatePassword ? "Campo senha é obrigatório" : null,
                  ),

                  const SizedBox(height: 260),

                  MyButton(onTap: signUserIn),

                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Não tem cadastro?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                       GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/cadastro');
                        },
                        child: Text(
                          'Cadastre-se agora',
                          style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

void main() {
  runApp(const MaterialApp(home: LoginPage()));
}
