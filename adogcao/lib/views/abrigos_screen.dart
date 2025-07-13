import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adogcao/models/abrigo.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/abrigo_controller.dart';
// Removido: import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
// Removido: import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

class AbrigosScreen extends StatelessWidget {
  const AbrigosScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  const Color.fromARGB(255, 0, 13, 32).withAlpha(200),
                ],
              ),
            ),
          ),
          Column(
            children: [
              AppBar(
                title: const Text('Meus abrigos'),
                foregroundColor: Colors.white,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('abrigos')
                      .where('volunteerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                          child: Text('Ocorreu um erro ao carregar os dados.'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final abrigos = snapshot.data!.docs.map((doc) {
                      return Abrigo(
                        nome: doc['nome'],
                        email: doc['email'],
                        endereco: doc['endereco'],
                        lat: doc['lat'],
                        lng: doc['lng'],
                        telefone: doc['telefone'],
                        volunteerId: doc['volunteerId'],
                        createdAt: doc['createdAt'],
                        id: doc.id,
                      );
                    }).toList();

                    return ListView.builder(
                      itemCount: abrigos.length,
                      itemBuilder: (context, index) {
                        final abrigo = abrigos[index];

                        return Card(
                          color: const Color.fromARGB(255, 0, 13, 32),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      abrigo.nome,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit, color: Colors.white),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => EditarAbrigoScreen(
                                                    abrigoId: abrigo.id),
                                              ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () {
                                            _confirmDelete(context, abrigo.id!);
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  abrigo.email,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  abrigo.endereco,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Telefone: ${abrigo.telefone}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String abrigoId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmação'),
          content: const Text('Você tem certeza que deseja excluir este abrigo?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('abrigos')
                    .doc(abrigoId)
                    .delete()
                    .then((_) {
                  Navigator.of(context).pop(); // Fechar o diálogo
                });
              },
            ),
          ],
        );
      },
    );
  }
}


class EditarAbrigoScreen extends StatefulWidget {
  final String? abrigoId; // ID do abrigo a ser editado

  const EditarAbrigoScreen({super.key, required this.abrigoId});

  @override
  _EditarAbrigoScreenState createState() => _EditarAbrigoScreenState();
}

class _EditarAbrigoScreenState extends State<EditarAbrigoScreen> {
  final AbrigoController _abrigoController = AbrigoController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  GoogleMapController? mapController;
  final LatLng _center = const LatLng(-8.017788, -34.944773);
  String _address = '';
  final String _googleApiKey = 'AIzaSyCqvxvqh9AAFxFQN7mRPazAGibBg7RI75o';

  String? _nomeError;
  String? _emailError;
  String? _enderecoError;
  String? _telefoneError;

  @override
  void initState() {
    super.initState();
    _carregarDadosAbrigo();
  }

  void _carregarDadosAbrigo() async {
    try {
      DocumentSnapshot snapshot = await getAbrigoById(widget.abrigoId);
      Map<String, dynamic> dados = snapshot.data() as Map<String, dynamic>;

      final abrigo = Abrigo(nome: dados['nome'],
                                            email: dados['email'],
                                            endereco: dados['endereco'],
                                            lat: dados['lat'],
                                            lng: dados['lng'],
                                            telefone: dados['telefone'],
                                            volunteerId: dados['volunteerId'],
                                            createdAt: dados['createdAt'],
                                        );

      setState(() {
        _nomeController.text = abrigo.nome;
        _emailController.text = abrigo.email;
        _enderecoController.text = abrigo.endereco;
        _telefoneController.text = abrigo.telefone;
      });
    } catch (e) {
      print('Erro ao carregar dados do abrigo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados do abrigo: $e')),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onPlaceSelected(dynamic prediction) async {
    // TODO: Implementar Google Places quando dependência for resolvida
    setState(() {
      _address = 'Endereço selecionado';
      // mapController?.animateCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));
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

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> atualizarAbrigo({
    required String? id,
    required String nome,
    required String email,
    required String endereco,
    required String telefone,
  }) async {
    try {
      await _firestore.collection('abrigos').doc(id).update({
        'nome': nome,
        'email': email,
        'endereco': endereco,
        'telefone': telefone,
      });
    } catch (e) {
      print('Erro ao atualizar abrigo: $e');
      rethrow;
    }
  }

  Future<DocumentSnapshot> getAbrigoById(String? id) async {
    try {
      return await _firestore.collection('abrigos').doc(id).get();
    } catch (e) {
      print('Erro ao obter abrigo: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color.fromARGB(255, 0, 13, 32).withAlpha(200),
    resizeToAvoidBottomInset: true, // Adicionado para evitar overlap com teclado
    body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black,
                const Color.fromARGB(255, 0, 13, 32).withAlpha(200),
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
                        'Editar Abrigo',
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
              child: SingleChildScrollView( // Adicionado para permitir scroll
                child: Padding(
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
                          errorText: _enderecoError,
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
                      const SizedBox(height: 16), // Espaçamento adicionado
                      SizedBox(
                        height: 200, // Defina um tamanho fixo para o mapa
                        child: GoogleMap(
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: _center,
                            zoom: 16.0,
                          ),
                          markers: _address.isNotEmpty
                              ? {
                                  Marker(
                                    markerId: const MarkerId('endereco'),
                                    position: _center,
                                    infoWindow: InfoWindow(title: _address),
                                  ),
                                }
                              : {},
                        ),
                      ),
                      const SizedBox(height: 25),
                      Text('Telefone',
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
                      const SizedBox(height: 40),
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
                                // Chama o método para atualizar o abrigo
                                await atualizarAbrigo(
                                  id: widget.abrigoId,
                                  nome: _nomeController.text,
                                  email: _emailController.text,
                                  endereco: _enderecoController.text,
                                  telefone: _telefoneController.text,
                                );

                                // Exibe uma mensagem de sucesso
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Abrigo atualizado com sucesso!'),
                                  ),
                                );
                                // Volta para a tela anterior
                                Navigator.of(context).pop();
                              } catch (e) {
                                // Exibe uma mensagem de erro
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Erro ao atualizar abrigo: $e'),
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Salvar Alterações',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
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
      ]
    ),
  );
}
}

