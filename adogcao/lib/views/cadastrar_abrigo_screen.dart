import 'package:flutter/material.dart';
import '../controllers/abrigo_controller.dart';

class CadastrarAbrigoScreen extends StatefulWidget {
  @override
  _CadastrarAbrigoScreenState createState() => _CadastrarAbrigoScreenState();
}

class _CadastrarAbrigoScreenState extends State<CadastrarAbrigoScreen> {
  final AbrigoController _abrigoController = AbrigoController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();

  String? _nomeError;
  String? _emailError;
  String? _enderecoError;
  String? _telefoneError;

  void _validateNome() {
    setState(() {
      String nome = _nomeController.text;
      if (nome.isEmpty) {
        _nomeError = 'Nome do abrigo é obrigatório';
      } else {
        _nomeError = null;
      }
    });
  }

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

  void _validateEndereco() {
    setState(() {
      String endereco = _enderecoController.text;
      if (endereco.isEmpty) {
        _enderecoError = 'Endereço é obrigatório';
      } else {
        _enderecoError = null;
      }
    });
  }

  void _validateTelefone() {
    setState(() {
      String telefone = _telefoneController.text;
      if (telefone.isEmpty) {
        _telefoneError = 'Número de telefone é obrigatório';
      } else {
        _telefoneError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 13, 32).withAlpha(200),
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
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: 20,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Cadastrar Abrigo',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 55),
                      Text('Nome do abrigo', style: TextStyle(color: Colors.grey.shade500)),
                      SizedBox(height: 3),
                      TextField(
                        controller: _nomeController,
                        decoration: InputDecoration(
                          hintText: 'Digite o nome do abrigo',
                          errorText: _nomeError,
                          hintStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.grey.shade800,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade600, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade600, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade600, width: 1),
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 25),
                      Text('Email', style: TextStyle(color: Colors.grey.shade500)),
                      SizedBox(height: 3),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Digite o email',
                          errorText: _emailError,
                          hintStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.grey.shade800,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade600, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade600, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade600, width: 1),
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 25),
                      Text('Endereço', style: TextStyle(color: Colors.grey.shade500)),
                      SizedBox(height: 3),
                      TextField(
                        controller: _enderecoController,
                        decoration: InputDecoration(
                          hintText: 'Digite o endereço',
                          errorText: _enderecoError,
                          hintStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.grey.shade800,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade600, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade600, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade600, width: 1),
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 25),
                      Text('Número de telefone', style: TextStyle(color: Colors.grey.shade500)),
                      SizedBox(height: 3),
                      TextField(
                        controller: _telefoneController,
                        decoration: InputDecoration(
                          hintText: 'Digite o número de telefone',
                          errorText: _telefoneError,
                          hintStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.grey.shade800,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade600, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade600, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade600, width: 1),
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 70),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            // Validações
                            _validateNome();
                            _validateEmail();
                            _validateEndereco();
                            _validateTelefone();

                            if (_nomeError == null &&
                                _emailError == null &&
                                _enderecoError == null &&
                                _telefoneError == null) {
                              try {
                                // Chama o método para registrar o abrigo
                                await _abrigoController.registrarAbrigo(
                                  nome: _nomeController.text,
                                  email: _emailController.text,
                                  endereco: _enderecoController.text,
                                  telefone: _telefoneController.text,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Abrigo cadastrado com sucesso!'),
                                  ),
                                );
                                Navigator.pop(context);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Erro ao cadastrar abrigo: $e'),
                                  ),
                                );
                              }
                            }
                          },
                          child: Text('Registrar', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
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
        ],
      ),
    );
  }
}
