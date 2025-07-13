import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/lar_temporario_controller.dart';
import 'package:google_api_headers/google_api_headers.dart';

class CadastrarLarTemporarioScreen extends StatefulWidget {
  const CadastrarLarTemporarioScreen({super.key});

  @override
  _CadastrarLarTemporarioScreenState createState() =>
      _CadastrarLarTemporarioScreenState();
}

class _CadastrarLarTemporarioScreenState
    extends State<CadastrarLarTemporarioScreen> {
  final LarTemporarioController _larTemporarioController =
      LarTemporarioController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _capacidadeController = TextEditingController();
  GoogleMapController? mapController;
  final LatLng _center = const LatLng(-8.017788, -34.944773);
  String _address = '';
  final String _googleApiKey = 'AIzaSyCqvxvqh9AAFxFQN7mRPazAGibBg7RI75o'; // Reutilizando a chave
  Marker? _marker;

  double lat = 0;
  double lng = 0;

  // Lista de animais e controle dos checkboxes
  final List<String> _animalTypes = ['Cachorro', 'Gato', 'Coelho', 'Cavalo', 'Pássaro'];
  Map<String, bool> _selectedAnimalTypes = {};

  @override
  void initState() {
    super.initState();
    // Inicializa o estado dos checkboxes
    _selectedAnimalTypes = {for (var animal in _animalTypes) animal: false};
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _onPlaceSelected(dynamic prediction) async {
    // TODO: Implementar Google Places quando dependência for resolvida
    // Por enquanto, usar coordenadas padrão
    lat = -8.017788;
    lng = -34.944773;

    // Atualize o estado com o novo endereço e a posição
    setState(() {
      _address = 'Endereço selecionado';
      _marker = Marker(
        markerId: const MarkerId('endereco'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: _address),
      );
    });

    // Verifica se o mapController não é nulo e só então anima a câmera
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLng(LatLng(lat, lng)),
      );
    } else {
      // Caso mapController seja nulo, você pode adicionar uma mensagem de erro no log
      print('mapController ainda não foi inicializado.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Lar Temporário'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 13, 32).withAlpha(200),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      // Capacidade
                      Text('Número de capacidade',
                          style: TextStyle(color: Colors.grey.shade500)),
                      const SizedBox(height: 3),
                      TextField(
                        controller: _capacidadeController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Digite a capacidade de animais',
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
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),

                      // Tipos de Animais (Checkboxes)
                      Text('Tipos de animais que aceito: ',
                          style: TextStyle(color: Colors.grey.shade500)),
                      const SizedBox(height: 3),
                      Column(
                        children: _animalTypes.map((animal) {
                          return CheckboxListTile(
                            title: Text(
                              animal,
                              style: const TextStyle(color: Colors.white),
                            ),
                            value: _selectedAnimalTypes[animal],
                            onChanged: (bool? value) {
                              setState(() {
                                _selectedAnimalTypes[animal] = value!;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: Colors.blue,
                            checkColor: Colors.white,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),

                      // Endereço
                      Text('Endereço',
                          style: TextStyle(color: Colors.grey.shade500)),
                      const SizedBox(height: 3),
                      TextField(
                        controller: _enderecoController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Digite o endereço',
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

                      // Mapa
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
                      const SizedBox(height: 25),

                      // Botão de Registrar
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            // Filtra os animais selecionados
                            List<String> selectedAnimals = _selectedAnimalTypes.keys
                                .where((animal) => _selectedAnimalTypes[animal]!)
                                .toList();

                            if (_enderecoController.text.isNotEmpty &&
                                _capacidadeController.text.isNotEmpty &&
                                lat != 0 &&
                                lng != 0 &&
                                selectedAnimals.isNotEmpty) {
                              try {
                                await _larTemporarioController
                                    .cadastrarLarTemporario(
                                  endereco: _enderecoController.text,
                                  latitude: lat,
                                  longitude: lng,
                                  tiposAnimais: selectedAnimals,
                                  capacidade: int.parse(
                                      _capacidadeController.text),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Lar temporário cadastrado com sucesso!')),
                                );
                                Navigator.pop(context);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Erro ao cadastrar: $e')),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Preencha todos os campos!')),
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
                          child: const Text('Registrar',
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
