import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/abrigo.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/abrigo_controller.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

class AbrigosScreen extends StatelessWidget {
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
                  Color.fromARGB(255, 0, 13, 32).withAlpha(200),
                ],
              ),
            ),
          ),
          Column(
            children: [
              AppBar(
                title: Text('Meus abrigos'),
                foregroundColor: Colors.white,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('abrigos')
                      .where('volunteerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid) // Adiciona o filtro pelo ID do voluntário logado
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                          child: Text('Ocorreu um erro ao carregar os dados.'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
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

                        return ListTile(
                          leading: Icon(Icons.location_on, color: Colors.white),
                          title: Text(
                            abrigo.nome,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetalhesAbrigoScreen(
                                      abrigoId: abrigo.id),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: Text('Ver'),
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
}

class DetalhesAbrigoScreen extends StatelessWidget {
  final String? abrigoId;

  DetalhesAbrigoScreen({required this.abrigoId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 13, 32).withAlpha(200),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditarAbrigoScreen(abrigoId: abrigoId),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              _confirmDelete(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black,
                  Color.fromARGB(255, 0, 13, 32).withAlpha(200),
                ],
              ),
            ),
          ),
          FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('abrigos')
                .doc(abrigoId)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: Text('Erro ao carregar os detalhes do abrigo.'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              final doc = snapshot.data!;
              final abrigo = Abrigo(nome: doc['nome'],
                                            email: doc['email'],
                                            endereco: doc['endereco'],
                                            lat: doc['lat'],
                                            lng: doc['lng'],
                                            telefone: doc['telefone'],
                                            volunteerId: doc['volunteerId'],
                                            createdAt: doc['createdAt'],
                                            id: doc.id,
                                        );
                                            
                                   
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      abrigo.nome,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'E-mail:',
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      abrigo.email,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Endereço:',
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      abrigo.endereco,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Telefone:',
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      abrigo.telefone,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmação'),
          content: Text('Você tem certeza que deseja excluir este abrigo?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Excluir', style: TextStyle(color: Colors.red)),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('abrigos')
                    .doc(abrigoId)
                    .delete()
                    .then((_) {
                  Navigator.of(context).pop(); // Fechar o diálogo
                  Navigator.of(context).pop(); // Voltar para a tela anterior
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

  EditarAbrigoScreen({required this.abrigoId});

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
      throw e;
    }
  }

  Future<DocumentSnapshot> getAbrigoById(String? id) async {
    try {
      return await _firestore.collection('abrigos').doc(id).get();
    } catch (e) {
      print('Erro ao obter abrigo: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Color.fromARGB(255, 0, 13, 32).withAlpha(200),
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
                Color.fromARGB(255, 0, 13, 32).withAlpha(200),
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
                      SizedBox(height: 20),
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
                          errorText: _enderecoError,
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
                      SizedBox(height: 16), // Espaçamento adicionado
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
                                    markerId: MarkerId('endereco'),
                                    position: _center,
                                    infoWindow: InfoWindow(title: _address),
                                  ),
                                }
                              : {},
                        ),
                      ),
                      SizedBox(height: 25),
                      Text('Telefone',
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
                      SizedBox(height: 40),
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
                                  SnackBar(
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
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

