import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/edit_user_controller.dart';
import 'package:flutter_application_1/session/UserSession.dart';
import 'package:flutter_application_1/views/home_screen.dart';
import 'login_screen.dart';

class EditUserScreen extends StatefulWidget {
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
                      SizedBox(height: 55),
                      Text('Nome',
                          style: TextStyle(color: Colors.grey.shade500)),
                      SizedBox(height: 3),
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
                      
                      Text('Número de telefone',
                          style: TextStyle(color: Colors.grey.shade500)),
                      SizedBox(height: 3),
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
                              SnackBar(
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
                              SnackBar(
                                content: Text('Informações salvas'),
                              ),
                            );

                          } catch (e) {
                            // Tratar erros de registro
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Erro ao editar usuário'),
                              ),
                            );
                          }
          
                          },
                          child: Text('Salvar',
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20),
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
