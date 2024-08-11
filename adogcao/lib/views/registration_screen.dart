import 'package:flutter/material.dart';
import '../controllers/registration_controller.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final RegistrationController _controller = RegistrationController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  String? _nameError;
  String? _confirmPasswordError;
  String? _phoneError;

  bool isVolunteer = false;
  bool isAdotante = false;

  void _validateEmail() {
    setState(() {
      String email = _emailController.text;
      if (email.isEmpty) {
        _emailError = 'Email é obrigatório';
      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
        _emailError = 'Por favor, insira um email válido';
      } else {
        _emailError = null;
      }
    });
  }

  void _validateSenha() {
    setState(() {
      String senha = _passwordController.text;
      String confirmacao = _confirmPasswordController.text;
      if (senha.isEmpty) {
        _passwordError = 'Senha é obrigatória';
      }
      if (confirmacao.isEmpty) {
        _confirmPasswordError = 'Confirmação de senha é obrigatória';
      }
      if (senha != confirmacao) {
        _passwordError = 'As senhas devem ser iguais';
        _confirmPasswordError = _passwordError;
      }
      if (senha.length < 6) {
        _passwordError = 'A senha deve ter pelo menos 6 caracteres';
      } else {
        _passwordError = null;
        _confirmPasswordError = _passwordError;
      }
    });
  }

  void _validateName() {
    setState(() {
      String name = _nameController.text;
      if (name.isEmpty) {
        _nameError = 'Nome é obrigatório';
      } else {
        _nameError = null;
      }
    });
  }

  void _validateTelefone() {
    setState(() {
      String phone = _phoneController.text;
      if (phone.isEmpty) {
        _phoneError = 'Telefone é obrigatório';
      } else {
        _phoneError = null;
      }
    });
  }

  void _setVolunteer(bool? value) {
    setState(() {
      isVolunteer = value ?? false;
      isAdotante = !isVolunteer; // Garantir que apenas um checkbox esteja marcado
      _controller.toggleVolunteer(isVolunteer);
    });
  }

  void _setAdotante(bool? value) {
    setState(() {
      isAdotante = value ?? false;
      isVolunteer = !isAdotante; // Garantir que apenas um checkbox esteja marcado
      _controller.toggleVolunteer(isVolunteer);
    });
  }

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
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Cadastre-se',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: Text(
                        'Já possui uma conta? Login',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 55),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Nome',
                        errorText: _nameError,
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
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'E-mail',
                        errorText: _emailError,
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
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: 'Senha',
                        errorText: _passwordError,
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
                    TextField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        hintText: 'Confirmar senha',
                        errorText: _confirmPasswordError,
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
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        hintText: 'Número de telefone',
                        errorText: _phoneError,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: isVolunteer,
                          onChanged: _setVolunteer,
                        ),
                        Text(
                          'Voluntário',
                          style: TextStyle(color: Colors.white),
                        ),
                        Checkbox(
                          value: isAdotante,
                          onChanged: _setAdotante,
                        ),
                        Text(
                          'Adotante',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: 70),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          // Coletar os dados dos campos de texto
                          String name = _nameController.text;
                          String email = _emailController.text;
                          String password = _passwordController.text;
                          String phoneNumber = _phoneController.text;
                          _validateEmail();
                          _validateName();
                          _validateSenha();
                          _validateTelefone();

                          // Verificar se o perfil foi selecionado
                          if (!isVolunteer && !isAdotante) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Por favor, selecione um perfil: Voluntário ou Adotante.'),
                              ),
                            );
                            return;
                          }

                          try {
                            // Registrar o usuário no Firebase
                            await _controller.registerUser(
                              name: name,
                              email: email,
                              password: password,
                              phoneNumber: phoneNumber,
                            );

                            // Navegar para a tela de login após o registro
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                          } catch (e) {
                            // Tratar erros de registro
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Erro ao registrar usuário: $e'),
                              ),
                            );
                          }
                        },
                        child: Text('Registrar',
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding:
                              EdgeInsets.symmetric(horizontal: 212, vertical: 35),
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
          ),
        ],
      ),
    );
  }
}
