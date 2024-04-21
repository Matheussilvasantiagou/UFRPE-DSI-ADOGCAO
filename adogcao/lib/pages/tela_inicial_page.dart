import 'package:adogcao/components/my_button.dart';
import 'package:adogcao/components/my_button_cadastro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:adogcao/components/my_textfield.dart';


class TelaInicialPage extends StatefulWidget {
  const TelaInicialPage({super.key});

  @override
  _TelaInicialPageState createState() => _TelaInicialPageState();
}

class _TelaInicialPageState extends State<TelaInicialPage> {
  

  void signUserIn() {
    setState(() {
          Navigator.pushNamed(context, '/login');
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

                  const SizedBox(height: 180),

                  const Text(
                  'Adote o cachorro perfeito para você!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                  ),
                  textAlign: TextAlign.center,

                  ),

                  const Text(
                    'Explore perfis de cachorros prontos para adoção e use filtros personalizados para encontrar o companheiro ideal. Comece sua jornada de adoção e encontre um amigo para a vida toda!',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 30),

                  MyButton(onTap: signUserIn),

                ],
              ),
            ),
          ),
        ));
  }
}

// void main() {
//   runApp(const MaterialApp(home: CadastroPage()));
// }
