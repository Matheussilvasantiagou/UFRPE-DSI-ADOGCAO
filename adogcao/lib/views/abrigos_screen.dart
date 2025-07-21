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
                        cep: doc['cep'] ?? '',
                        rua: doc['rua'] ?? '',
                        numero: doc['numero'] ?? '',
                        complemento: doc['complemento'],
                        bairro: doc['bairro'] ?? '',
                        cidade: doc['cidade'] ?? '',
                        estado: doc['estado'] ?? '',
                        telefone: doc['telefone'],
                        lat: doc['lat'],
                        lng: doc['lng'],
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
                                  '${abrigo.rua}, ${abrigo.numero}${abrigo.complemento != null && abrigo.complemento!.isNotEmpty ? ' - ${abrigo.complemento}' : ''}, ${abrigo.bairro}, ${abrigo.cidade} - ${abrigo.estado}, CEP: ${abrigo.cep}',
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
              onPressed: () async {
                // 1. Buscar todos os pets do abrigo
                final pets = await FirebaseFirestore.instance
                    .collection('pets')
                    .where('shelterId', isEqualTo: abrigoId)
                    .get();

                // 2. Excluir cada pet
                for (var doc in pets.docs) {
                  await doc.reference.delete();
                }

                // 3. Excluir o abrigo
                await FirebaseFirestore.instance
                    .collection('abrigos')
                    .doc(abrigoId)
                    .delete();

                Navigator.of(context).pop(); // Fechar o diálogo
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
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _complementoController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();

  String? _nomeError;
  String? _emailError;
  String? _cepError;
  String? _ruaError;
  String? _numeroError;
  String? _bairroError;
  String? _cidadeError;
  String? _estadoError;
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
      setState(() {
        _nomeController.text = dados['nome'] ?? '';
        _emailController.text = dados['email'] ?? '';
        _cepController.text = dados['cep'] ?? '';
        _ruaController.text = dados['rua'] ?? '';
        _numeroController.text = dados['numero'] ?? '';
        _complementoController.text = dados['complemento'] ?? '';
        _bairroController.text = dados['bairro'] ?? '';
        _cidadeController.text = dados['cidade'] ?? '';
        _estadoController.text = dados['estado'] ?? '';
        _telefoneController.text = dados['telefone'] ?? '';
      });
    } catch (e) {
      print('Erro ao carregar dados do abrigo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados do abrigo: $e')),
      );
    }
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

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> atualizarAbrigoDetalhado({
    required String? id,
    required String nome,
    required String email,
    required String cep,
    required String rua,
    required String numero,
    String? complemento,
    required String bairro,
    required String cidade,
    required String estado,
    required String telefone,
  }) async {
    try {
      await _firestore.collection('abrigos').doc(id).update({
        'nome': nome,
        'email': email,
        'cep': cep,
        'rua': rua,
        'numero': numero,
        'complemento': complemento,
        'bairro': bairro,
        'cidade': cidade,
        'estado': estado,
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text('Nome do abrigo', style: TextStyle(color: Colors.grey.shade500)),
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
                      Text('Email', style: TextStyle(color: Colors.grey.shade500)),
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
                        keyboardType: TextInputType.emailAddress,
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
                            // Aqui você pode usar o serviço de CEP se quiser
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
                      const SizedBox(height: 40),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            _validateNome();
                            _validateEmail();
                            _validateTelefone();
                            _validateCamposEndereco();
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
                                await atualizarAbrigoDetalhado(
                                  id: widget.abrigoId,
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
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Abrigo atualizado com sucesso!'),
                                  ),
                                );
                                Navigator.of(context).pop();
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Erro ao atualizar abrigo: $e'),
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
            ],
          ),
        ],
      ),
    );
  }
}

