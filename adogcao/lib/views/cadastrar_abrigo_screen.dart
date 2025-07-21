import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:adogcao/models/abrigo.dart';
import 'package:adogcao/session/UserSession.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/abrigo_controller.dart';
// Removido: import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
// Removido: import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:adogcao/core/services/cep_service.dart';

class CadastrarAbrigoScreen extends StatefulWidget {
  const CadastrarAbrigoScreen({super.key});

  @override
  _CadastrarAbrigoScreenState createState() => _CadastrarAbrigoScreenState();
}

class _CadastrarAbrigoScreenState extends State<CadastrarAbrigoScreen> {
  final AbrigoController _abrigoController = AbrigoController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _complementoController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  GoogleMapController? mapController;
  final LatLng _center = const LatLng(-8.017788, -34.944773);
  String _address = '';
  final String _googleApiKey = 'AIzaSyCqvxvqh9AAFxFQN7mRPazAGibBg7RI75o';
  Marker? _marker;

  String? _nomeError;
  String? _emailError;
  String? _telefoneError;
  double lat = 0;
  double lng = 0;

  String? _cepError;
  String? _ruaError;
  String? _numeroError;
  String? _bairroError;
  String? _cidadeError;
  String? _estadoError;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onPlaceSelected(dynamic prediction) async {
    // TODO: Implementar Google Places quando dependência for resolvida
    // Por enquanto, apenas atualiza o endereço manualmente
    setState(() {
      _address = 'Endereço selecionado';
      // Usar coordenadas padrão por enquanto
      lat = -8.017788;
      lng = -34.944773;
      
      // Atualiza o marcador para o novo endereço selecionado
      _marker = Marker(
        markerId: const MarkerId('endereco'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: _address),
      );
    });
  }

  void _validateNome() {
    setState(() {
      String nome = _nomeController.text.trim();
      if (nome.isEmpty) {
        _nomeError = 'Nome do abrigo é obrigatório';
      } else {
        _nomeError = null;
      }
    });
  }

  void _validateEmail() {
    setState(() {
      String email = _emailController.text.trim();
      if (email.isEmpty) {
        _emailError = 'Email é obrigatório';
      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
        _emailError = 'Por favor, insira um email válido';
      } else {
        _emailError = null;
      }
    });
  }

  void _validateTelefone() {
    setState(() {
      String telefone = _telefoneController.text.trim();
      if (telefone.isEmpty) {
        _telefoneError = 'Número de telefone é obrigatório';
      } else {
        _telefoneError = null;
      }
    });
  }

  void _validateCamposEndereco() {
    setState(() {
      _cepError = _cepController.text.trim().isEmpty ? 'CEP é obrigatório' : null;
      _ruaError = _ruaController.text.trim().isEmpty ? 'Rua é obrigatória' : null;
      _numeroError = _numeroController.text.trim().isEmpty ? 'Número é obrigatório' : null;
      _bairroError = _bairroController.text.trim().isEmpty ? 'Bairro é obrigatório' : null;
      _cidadeError = _cidadeController.text.trim().isEmpty ? 'Cidade é obrigatória' : null;
      _estadoError = _estadoController.text.trim().isEmpty ? 'Estado é obrigatório' : null;
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color.fromARGB(255, 0, 13, 32).withAlpha(200),
    resizeToAvoidBottomInset: true,
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
                  height: 120,
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text('Nome do abrigo',
                        style: TextStyle(color: Colors.grey.shade500)),
                    const SizedBox(height: 3),
                    TextField(
                      controller: _nomeController,
                      decoration: InputDecoration(
                        hintText: 'Digite o nome do abrigo',
                        errorText: _nomeError,
                        hintStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.grey.shade800,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Colors.grey.shade600, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Colors.grey.shade600, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Colors.grey.shade600, width: 1),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 25),
                    Text('Email',
                        style: TextStyle(color: Colors.grey.shade500)),
                    const SizedBox(height: 3),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Digite o email',
                        errorText: _emailError,
                        hintStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.grey.shade800,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Colors.grey.shade600, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Colors.grey.shade600, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Colors.grey.shade600, width: 1),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 25),
                    Text('Telefone', style: TextStyle(color: Colors.grey.shade500)),
                    const SizedBox(height: 3),
                    TextField(
                      controller: _telefoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Digite o telefone',
                        errorText: _telefoneError,
                        hintStyle: const TextStyle(color: Colors.white),
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
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 25),
                    Text('CEP', style: TextStyle(color: Colors.grey.shade500)),
                    const SizedBox(height: 3),
                    TextField(
                      controller: _cepController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Digite o CEP',
                        errorText: _cepError,
                        hintStyle: const TextStyle(color: Colors.white),
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
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) async {
                        if (value.length == 8) {
                          final data = await CepService.buscarEndereco(value);
                          if (data != null) {
                            _ruaController.text = data['logradouro'] ?? '';
                            _bairroController.text = data['bairro'] ?? '';
                            _cidadeController.text = data['localidade'] ?? '';
                            _estadoController.text = data['uf'] ?? '';
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Text('Rua', style: TextStyle(color: Colors.grey.shade500)),
                    const SizedBox(height: 3),
                    TextField(
                      controller: _ruaController,
                      decoration: InputDecoration(
                        hintText: 'Rua',
                        errorText: _ruaError,
                        hintStyle: const TextStyle(color: Colors.white),
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
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text('Número', style: TextStyle(color: Colors.grey.shade500)),
                    const SizedBox(height: 3),
                    TextField(
                      controller: _numeroController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Número',
                        errorText: _numeroError,
                        hintStyle: const TextStyle(color: Colors.white),
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
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text('Complemento', style: TextStyle(color: Colors.grey.shade500)),
                    const SizedBox(height: 3),
                    TextField(
                      controller: _complementoController,
                      decoration: InputDecoration(
                        hintText: 'Complemento (opcional)',
                        hintStyle: const TextStyle(color: Colors.white),
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
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text('Bairro', style: TextStyle(color: Colors.grey.shade500)),
                    const SizedBox(height: 3),
                    TextField(
                      controller: _bairroController,
                      decoration: InputDecoration(
                        hintText: 'Bairro',
                        errorText: _bairroError,
                        hintStyle: const TextStyle(color: Colors.white),
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
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text('Cidade', style: TextStyle(color: Colors.grey.shade500)),
                    const SizedBox(height: 3),
                    TextField(
                      controller: _cidadeController,
                      decoration: InputDecoration(
                        hintText: 'Cidade',
                        errorText: _cidadeError,
                        hintStyle: const TextStyle(color: Colors.white),
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
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text('Estado', style: TextStyle(color: Colors.grey.shade500)),
                    const SizedBox(height: 3),
                    TextField(
                      controller: _estadoController,
                      decoration: InputDecoration(
                        hintText: 'Estado',
                        errorText: _estadoError,
                        hintStyle: const TextStyle(color: Colors.white),
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
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 25),
                     Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          _validateNome();
                          _validateEmail();
                          _validateTelefone();
                          _validateCamposEndereco();

                          print('DEBUG:');
                          print('nome: "${_nomeController.text}" erro: $_nomeError');
                          print('email: "${_emailController.text}" erro: $_emailError');
                          print('telefone: "${_telefoneController.text}" erro: $_telefoneError');
                          print('cep: "${_cepController.text}" erro: $_cepError');
                          print('rua: "${_ruaController.text}" erro: $_ruaError');
                          print('numero: "${_numeroController.text}" erro: $_numeroError');
                          print('bairro: "${_bairroController.text}" erro: $_bairroError');
                          print('cidade: "${_cidadeController.text}" erro: $_cidadeError');
                          print('estado: "${_estadoController.text}" erro: $_estadoError');

                          if (_nomeError == null &&
                              _emailError == null &&
                              _telefoneError == null &&
                              _cepError == null &&
                              _ruaError == null &&
                              _numeroError == null &&
                              _bairroError == null &&
                              _cidadeError == null &&
                              _estadoError == null) {
                            try {

                              Abrigo abrigo = Abrigo(
                                nome: _nomeController.text.trim(),
                                email: _emailController.text.trim(),
                                cep: _cepController.text.trim(),
                                rua: _ruaController.text.trim(),
                                numero: _numeroController.text.trim(),
                                complemento: _complementoController.text.trim(),
                                bairro: _bairroController.text.trim(),
                                cidade: _cidadeController.text.trim(),
                                estado: _estadoController.text.trim(),
                                telefone: _telefoneController.text.trim(),
                                lat: lat,
                                lng: lng,
                                volunteerId: UserSession.instance.userId,
                                createdAt: Timestamp.now(),
                              );
                              // Chama o método para registrar o abrigo
                              await _abrigoController.registrarAbrigo(abrigo);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Abrigo cadastrado com sucesso!'),
                                ),
                              );
                              Navigator.pop(context);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Erro ao cadastrar abrigo: $e'),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Por favor, preencha todos os campos obrigatórios.'),
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
                        child: Text('Registrar',
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
}}