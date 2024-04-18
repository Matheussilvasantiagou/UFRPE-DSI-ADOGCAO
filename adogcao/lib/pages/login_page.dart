import 'package:flutter/material.dart';
import 'package:adogcao/components/my_textfield.dart';
import 'package:adogcao/components/my_button.dart';


class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() {}

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
                ),
      
                const SizedBox(height: 10),
      
                MyTextField(
                  controller: passwordController,
                  hintText: 'Senha',
                  obscureText: true,
                ),
      
                // const SizedBox(height: 10),
      
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       Text(
                //         'Esqueceu a senha?',
                //         style: TextStyle(color: Colors.grey[600]),
                //       ),
                //     ],
                //   ),
                // ),
      
                const SizedBox(height: 260),
      
                // sign in button
                MyButton(
                  onTap: signUserIn,
                ),
      
                const SizedBox(height: 25),
      
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Não tem cadastro?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Cadastre-se agora',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}