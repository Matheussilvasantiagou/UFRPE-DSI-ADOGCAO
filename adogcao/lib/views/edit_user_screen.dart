import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/edit_user_controller.dart';
import 'package:flutter_application_1/session/UserSession.dart';
import 'package:flutter_application_1/views/home_screen.dart';
import 'login_screen.dart';

class EditUserScreen extends StatefulWidget {
  const EditUserScreen({super.key});

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final EditUserController _controller = EditUserController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();


  String? _nameError;
  String? _phoneError;

  bool isVolunteer = false;
  bool isAdotante = false;

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

  @override
  Widget build(BuildContext context) {
    _nameController.text = UserSession.instance.userName!;
    _phoneController.text = UserSession.instance.userPhone!;
    isVolunteer = UserSession.instance.isVolunteer;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 13, 32).withAlpha(200),
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
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: const BorderRadius.only(
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
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Edição de perfil',
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
                      const SizedBox(height: 55),
                      Text('Nome',
                          style: TextStyle(color: Colors.grey.shade500)),
                      const SizedBox(height: 3),
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
                      
                      Text('Número de telefone',
                          style: TextStyle(color: Colors.grey.shade500)),
                      const SizedBox(height: 3),
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
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            // Validações
                            _validateName();
                            _validateTelefone();
                            String name = _nameController.text;
                            String phoneNumber = _phoneController.text;

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
                            await _controller.editUser(
                              name: name,
                              phoneNumber: phoneNumber,
                              isVolunteer: isVolunteer
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Informações salvas'),
                              ),
                            );

                          } catch (e) {
                            // Tratar erros de registro
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Erro ao editar usuário'),
                              ),
                            );
                          }
          
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text('Salvar',
                              style: TextStyle(color: Colors.white)),
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
