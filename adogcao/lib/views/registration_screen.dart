import 'package:flutter/material.dart';
import '../controllers/registration_controller.dart';
import 'login_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final RegistrationController _controller = RegistrationController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _emailError;
  String? _passwordError;
  String? _nameError;
  String? _confirmPasswordError;
  String? _phoneError;

  bool isVolunteer = false;
  bool isAdotante = false;

  File? _imageFile;
  Uint8List? _webImage;
  String? _imageUrl;

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
      isAdotante =
          !isVolunteer; // Garantir que apenas um checkbox esteja marcado
      _controller.toggleVolunteer(isVolunteer);
    });
  }

  void _setAdotante(bool? value) {
    setState(() {
      isAdotante = value ?? false;
      isVolunteer =
          !isAdotante; // Garantir que apenas um checkbox esteja marcado
      _controller.toggleVolunteer(isVolunteer);
    });
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.single.bytes != null) {
        setState(() {
          _webImage = result.files.single.bytes;
          _imageFile = null;
          _imageUrl = null;
        });
      }
    } else {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _webImage = null;
          _imageUrl = _imageFile!.path;
        });
      }
    }
  }

  Future<void> _uploadImage() async {
    // Não faz upload, apenas salva o caminho local da imagem
    print('Entrou no _uploadImage (local)');
    if (_imageFile != null) {
      _imageUrl = _imageFile!.path; // Salva o caminho local
      print('Caminho da imagem local salvo: $_imageUrl');
    } else {
      print('Nenhuma imagem selecionada, usando imagem padrão');
      _imageUrl = '';
    }
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
                  const Color.fromARGB(255, 0, 13, 32).withAlpha(200)
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
                    const Text(
                      'Cadastre-se',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: const Text(
                        'Já possui uma conta? Login',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 55),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Nome',
                        errorText: _nameError,
                        hintStyle: const TextStyle(color: Colors.white),
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
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 25),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'E-mail',
                        errorText: _emailError,
                        hintStyle: const TextStyle(color: Colors.white),
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
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 25),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: 'Senha',
                        errorText: _passwordError,
                        hintStyle: const TextStyle(color: Colors.white),
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
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 25),
                    TextField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        hintText: 'Confirmar senha',
                        errorText: _confirmPasswordError,
                        hintStyle: const TextStyle(color: Colors.white),
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
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 25),
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        hintText: 'Número de telefone',
                        errorText: _phoneError,
                        hintStyle: const TextStyle(color: Colors.white),
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
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: isVolunteer,
                          onChanged: _setVolunteer,
                        ),
                        const Text(
                          'Voluntário',
                          style: TextStyle(color: Colors.white),
                        ),
                        Checkbox(
                          value: isAdotante,
                          onChanged: _setAdotante,
                        ),
                        const Text(
                          'Adotante',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 70),
                    Center(
                      child: Column(
                        children: [
                          if (kIsWeb && _webImage != null)
                            Image.memory(_webImage!, height: 120)
                          else if (!kIsWeb && _imageFile != null)
                            Image.file(_imageFile!, height: 120)
                          else if (_imageUrl != null && _imageUrl!.isNotEmpty)
                            kIsWeb
                              ? Image.network(_imageUrl!, height: 120)
                              : Image.file(File(_imageUrl!), height: 120)
                          else
                            Image.asset('lib/images/dog.png', height: 120), // imagem padrão local
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _pickImage,
                            child: const Text('Escolher imagem'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 70),
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
                              const SnackBar(
                                content: Text(
                                    'Por favor, selecione um perfil: Voluntário ou Adotante.'),
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
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Registrar',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16),
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
