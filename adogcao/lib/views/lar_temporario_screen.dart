import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:adogcao/controllers/lar_temporario_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'cadastrar_lar_temporario_screen.dart';

class LarTemporarioScreen extends StatefulWidget {
  @override
  _LarTemporarioScreenState createState() => _LarTemporarioScreenState();
}

class _LarTemporarioScreenState extends State<LarTemporarioScreen> {
  final LarTemporarioController _controller = LarTemporarioController();
  bool isLarTemporario = false;
  GoogleMapController? _mapController;
  LatLng _currentPosition = LatLng(-23.5505, -46.6333); // Local inicial
  String? selectedMarkerId; // Armazena o ID do marcador selecionado
  double selectedLat = 0;
  double selectedLng = 0;
  String selectedInfo = ''; // Informações selecionadas

  @override
  void initState() {
    super.initState();
    checkIfUserIsLarTemporario();
    _determinePosition();
  }

  Future<void> checkIfUserIsLarTemporario() async {
    String? larId = await _controller.isUserLarTemporario();
    setState(() {
      isLarTemporario = larId != null;
    });
  }

  // Obtém a localização atual do usuário
  Future<void> _determinePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLng(_currentPosition));
    }
  }

  // Função para confirmar a exclusão do lar temporário
  Future<void> _confirmDeactivateLarTemporario() async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Desativar Lar Temporário"),
          content: const Text("Tem certeza de que deseja desativar seu lar temporário?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text("Desativar"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    // Se confirmado, chamar a função para remover o lar temporário
    if (confirm) {
      String? larId = await _controller.isUserLarTemporario();
      if (larId != null) {
        await _controller.cancelarLarTemporario(larId);
        setState(() {
          isLarTemporario = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lar temporário desativado com sucesso!")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lar Temporário',
          style: TextStyle(
            color: Colors.white, // Define a cor branca para o título
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          // Exibe o mapa com os lares temporários
          StreamBuilder<QuerySnapshot>(
            stream: _controller.getLaresTemporarios(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              Set<Marker> markers = snapshot.data!.docs.map((doc) {
                double lat = doc['latitude'];
                double lng = doc['longitude'];
                String telefone = doc['telefone'];
                String endereco = doc['endereco']; // Obtém o endereço

                return Marker(
                  markerId: MarkerId(doc.id),
                  position: LatLng(lat, lng),
                  onTap: () {
                    setState(() {
                      selectedMarkerId = doc.id;
                      selectedLat = lat;
                      selectedLng = lng;
                      selectedInfo = '''
Nome: ${doc['nome']}
Tipos de animais que aceito: ${doc['tiposAnimais'].join(', ')}
Capacidade: ${doc['capacidade']}
Telefone: $telefone
Endereço: $endereco
'''; // Inclui o endereço
                    });
                  },
                );
              }).toSet();

              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _currentPosition,
                  zoom: 12,
                ),
                markers: markers,
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                },
                myLocationEnabled: true,
                zoomControlsEnabled: false,
              );
            },
          ),

          // Exibe o widget customizado quando um marcador é selecionado
          if (selectedMarkerId != null)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1,
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedInfo,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              selectedMarkerId = null;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Botão para encontrar a localização atual do usuário
          Positioned(
            bottom: 150,
            right: 20,
            child: FloatingActionButton(
              onPressed: _determinePosition,
              backgroundColor: Colors.orange,
              child: const Icon(Icons.my_location, color: Colors.white),
            ),
          ),

          // Botão de Zoom In
          Positioned(
            bottom: 220,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                _mapController?.animateCamera(CameraUpdate.zoomIn());
              },
              backgroundColor: Colors.orange,
              child: const Icon(Icons.zoom_in, color: Colors.white),
            ),
          ),

          // Botão de Zoom Out
          Positioned(
            bottom: 290,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                _mapController?.animateCamera(CameraUpdate.zoomOut());
              },
              backgroundColor: Colors.orange,
              child: const Icon(Icons.zoom_out, color: Colors.white),
            ),
          ),

          // Botão de ação (cadastrar ou desativar lar temporário)
          Positioned(
            bottom: 80,
            left: 20,
            right: 20,
            child: isLarTemporario
                ? ElevatedButton(
                    onPressed: _confirmDeactivateLarTemporario, // Chamar confirmação
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white, // Cor do texto
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Desativar meu Lar Temporário'),
                  )
                : ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CadastrarLarTemporarioScreen(), // Certifique-se de que este nome esteja correto
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white, // Cor do texto
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Cadastrar como Lar Temporário'),
                  ),
          ),
        ],
      ),
    );
  }
}
