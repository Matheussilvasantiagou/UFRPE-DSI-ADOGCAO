import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/abrigo_controller.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

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
  GoogleMapController? mapController;
  final LatLng _center = const LatLng(-15.7942, -47.8822);
  String _address = '';
  final String _googleApiKey = 'AIzaSyCqvxvqh9AAFxFQN7mRPazAGibBg7RI75o';

  String? _nomeError;
  String? _emailError;
  String? _enderecoError;
  String? _telefoneError;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onPlaceSelected(Prediction prediction) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
      apiKey: _googleApiKey,
      apiHeaders: await GoogleApiHeaders().getHeaders(),
    );
    PlacesDetailsResponse detail =
        await places.getDetailsByPlaceId(prediction.placeId!);
    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;
    setState(() {
      _address = prediction.description!;
      mapController?.animateCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));
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
                      Text('Nome do abrigo',
                          style: TextStyle(color: Colors.grey.shade500)),
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
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 25),
                      Text('Email',
                          style: TextStyle(color: Colors.grey.shade500)),
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
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 25),
                      Text('Endereço',
                          style: TextStyle(color: Colors.grey.shade500)),
                      SizedBox(height: 3),
                      TextField(
                        controller: _enderecoController,
                        decoration: InputDecoration(
                          hintText: 'Digite o endereço do abrigo',
                          errorText: _nomeError,
                          hintStyle: TextStyle(color: Colors.white),
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
                        style: TextStyle(color: Colors.white),
                        onTap: () async {
                          Prediction? p = await PlacesAutocomplete.show(
                            context: context,
                            apiKey: _googleApiKey,
                            mode: Mode.overlay,
                            language: "pt",
                            components: [Component(Component.country, "br")],
                          );
                          if (p != null) {
                            _onPlaceSelected(p);
                            setState(() {
                              _enderecoController.text =
                                  p.description.toString();
                            });
                          }
                        },
                      ),
                      Expanded(
                        child: GoogleMap(
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: _center,
                            zoom: 11.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Endereço: $_address'),
                      ),
                      Text('Número de telefone',
                          style: TextStyle(color: Colors.grey.shade500)),
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
                          child: Text('Registrar',
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
