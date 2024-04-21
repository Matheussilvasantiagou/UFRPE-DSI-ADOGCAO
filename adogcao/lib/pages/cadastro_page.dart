import 'package:adogcao/components/my_button_cadastro.dart';
import 'package:adogcao/components/my_textfield_number.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:adogcao/components/my_textfield.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  bool _validateEmail = true;
  bool _validateName = false;
  bool _validatePassword = false;
  bool _validatePhone = false;
  bool _adotante = true;

  void signUserUp() {
    setState(() {
      _validatePassword = passwordController.text.isEmpty;
      _validateName = nameController.text.isEmpty;
      _validatePhone = phoneController.text.isEmpty;
      final bool validateEmailFormat = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(emailController.text);
      _validateEmail =
          !(emailController.text.isEmpty) && validateEmailFormat;
      
      if(_validatePassword == false && _validateName == false && _validateEmail == true && _validatePhone == false){
          Navigator.pushNamed(context, '/login');
      }
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

                  const Text(
                  'Cadastre-se',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                  ),
                ),

                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'já possui uma conta?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  MyTextField(
                    controller: nameController,
                    hintText: 'Nome',
                    obscureText: false,
                    errorText: _validateName ? "Campo nome é obrigatório" : null,
                  ),

                  const SizedBox(height: 30),

                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                    errorText: _validateEmail ? null : "Campo email inválido",
                  ),

                  const SizedBox(height: 30),

                  MyTextField(
                    controller: passwordController,
                    hintText: 'Senha',
                    obscureText: true,
                    errorText:
                        _validatePassword ? "Campo senha é obrigatório" : null,
                  ),

                  const SizedBox(height: 30),

                  MyTextFieldNumber(
                    controller: phoneController,
                    hintText: 'Número de telefone',
                    obscureText: false,
                    errorText:
                        _validatePhone ? "Campo número de telefone é obrigatório" : null,
                  ),

                  const SizedBox(height: 100),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Voluntário',
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 4),
                      CupertinoSwitch(
                        value: _adotante,
                        onChanged: (value) {
                        setState(() {
                        _adotante = value; // Atualize o valor do switch quando alternado
                      });
                      },
                    ),
                      Text(
                          'Adotante',
                          style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),

                  const SizedBox(height: 130),

                  MyButtonCadastro(onTap: signUserUp),

                  const SizedBox(height: 25),
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
