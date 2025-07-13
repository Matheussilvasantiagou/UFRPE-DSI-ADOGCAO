import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:adogcao/models/abrigo.dart';
import 'package:adogcao/session/UserSession.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/abrigo_controller.dart';
// Removido: import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
// Removido: import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

class CadastrarAbrigoScreen extends StatefulWidget {
  const CadastrarAbrigoScreen({super.key});

  @override
  _CadastrarAbrigoScreenState createState() => _CadastrarAbrigoScreenState();
}

class _CadastrarAbrigoScreenState extends State<CadastrarAbrigoScreen> {
  final AbrigoController _abrigoController = AbrigoController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  GoogleMapController? mapController;
  final LatLng _center = const LatLng(-8.017788, -34.944773);
  String _address = '';
  final String _googleApiKey = 'AIzaSyCqvxvqh9AAFxFQN7mRPazAGibBg7RI75o';
  Marker? _marker;

  String? _nomeError;
  String? _emailError;
  String? _enderecoError;
  String? _telefoneError;
  double lat = 0;
  double lng = 0;

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
                    Text('Endereço',
                        style: TextStyle(color: Colors.grey.shade500)),
                    const SizedBox(height: 3),
                    TextField(
                      controller: _enderecoController,
                      decoration: InputDecoration(
                        hintText: 'Digite o endereço do abrigo',
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
                      onTap: () async {
                        // TODO: Implementar Google Places quando dependência for resolvida
                        // Prediction? p = await PlacesAutocomplete.show(
                        //   context: context,
                        //   apiKey: _googleApiKey,
                        //   mode: Mode.overlay,
                        //   language: "pt",
                        //   components: [Component(Component.country, "br")],
                        // );
                        // if (p != null) {
                        //   _onPlaceSelected(p);
                        //   setState(() {
                        //     _enderecoController.text =
                        //         p.description.toString();
                        //   });
                        // }
                      },
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 200,
                      child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: _center,
                          zoom: 16.0,
                        ),
                        markers: _marker != null ? {_marker!} : {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Endereço: $_address'),
                    ),
                    Text('Número de telefone',
                        style: TextStyle(color: Colors.grey.shade500)),
                    const SizedBox(height: 3),
                    TextField(
                      controller: _telefoneController,
                      decoration: InputDecoration(
                        hintText: 'Digite o número de telefone',
                        errorText: _telefoneError,
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
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 25),
                     Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          _validateNome();
                          _validateEmail();
                          _validateEndereco();
                          _validateTelefone();

                          if (_nomeError == null &&
                              _emailError == null &&
                              _enderecoError == null &&
                              _telefoneError == null) {
                            try {

                              Abrigo abrigo =  Abrigo(nome: _nomeController.text, email: _emailController.text, endereco: _enderecoController.text, telefone: _telefoneController.text, lat: lat, lng: lng, volunteerId: UserSession.instance.userId, createdAt: Timestamp.now());
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