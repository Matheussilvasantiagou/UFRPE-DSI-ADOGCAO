import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/cadastrar_pet_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';

class CadastrarPetScreen extends StatefulWidget {
  const CadastrarPetScreen({super.key});

  @override
  _CadastrarPetScreenState createState() => _CadastrarPetScreenState();
}

class _CadastrarPetScreenState extends State<CadastrarPetScreen> {
  final CadastrarPetController _petController = CadastrarPetController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  bool _isLoading = false;

  String? _nomeError;
  String? _idadeError;
  String? _pesoError;
  String? _descricaoError;
  String? selectedAnimalType;
  String? selectedShelter;
  List<String> animalTypes = [
    'Cachorro',
    'Gato',
    'Pássaro',
    'Coelho',
    'Cavalo'
  ];
  List<String> shelters = [];

  XFile? _imageFile;
  Uint8List? _webImage;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    fetchShelters();
  }

  void fetchShelters() async {
    shelters = await _petController.getShelters();
    setState(() {});
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });

      if (kIsWeb) {
        _webImage = await pickedFile.readAsBytes();
      }
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    UploadTask uploadTask;

    if (kIsWeb && _webImage != null) {
      uploadTask = FirebaseStorage.instance
          .ref()
          .child('pets_images')
          .child(fileName)
          .putData(_webImage!);
    } else {
      uploadTask = FirebaseStorage.instance
          .ref()
          .child('pets_images')
          .child(fileName)
          .putFile(File(_imageFile!.path));
    }

    TaskSnapshot snapshot = await uploadTask;
    _imageUrl = await snapshot.ref.getDownloadURL();
  }

  void _validateNome() {
    setState(() {
      String nome = _nomeController.text;
      if (nome.isEmpty) {
        _nomeError = 'Nome do pet é obrigatório';
      } else {
        _nomeError = null;
      }
    });
  }

  void _validateIdade() {
    setState(() {
      String idade = _idadeController.text;
      if (idade.isEmpty) {
        _idadeError = 'Idade do pet é obrigatória';
      } else {
        _idadeError = null;
      }
    });
  }

  void _validatePeso() {
    setState(() {
      String peso = _pesoController.text;
      if (peso.isEmpty) {
        _pesoError = 'Peso do pet é obrigatório';
      } else {
        _pesoError = null;
      }
    });
  }

  void _validateDescricao() {
    setState(() {
      String descricao = _descricaoController.text;
      if (descricao.isEmpty) {
        _descricaoError = 'Descrição é obrigatória';
      } else {
        _descricaoError = null;
      }
    });
  }

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
                          'Cadastrar Pet',
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
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 55),
                        Text('Nome do pet',
                            style: TextStyle(color: Colors.grey.shade500)),
                        const SizedBox(height: 3),
                        TextField(
                          controller: _nomeController,
                          decoration: InputDecoration(
                            hintText: 'Digite o nome do pet',
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
                        Text('Idade',
                            style: TextStyle(color: Colors.grey.shade500)),
                        const SizedBox(height: 3),
                        TextField(
                          controller: _idadeController,
                          decoration: InputDecoration(
                            hintText: 'Digite a idade do pet',
                            errorText: _idadeError,
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
                        Text('Peso',
                            style: TextStyle(color: Colors.grey.shade500)),
                        const SizedBox(height: 3),
                        TextField(
                          controller: _pesoController,
                          decoration: InputDecoration(
                            hintText: 'Digite o peso do pet',
                            errorText: _pesoError,
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
                        Text('Tipo de animal',
                            style: TextStyle(color: Colors.grey.shade500)),
                        const SizedBox(height: 3),
                        DropdownButtonFormField<String>(
                          value: selectedAnimalType,
                          items: animalTypes.map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type,
                                  style: const TextStyle(color: Colors.black)),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedAnimalType = newValue;
                            });
                          },
                          decoration: InputDecoration(
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
                          dropdownColor: Colors.white,
                        ),
                        const SizedBox(height: 25),
                        Text('Abrigo',
                            style: TextStyle(color: Colors.grey.shade500)),
                        const SizedBox(height: 3),
                        DropdownButtonFormField<String>(
                          value: selectedShelter,
                          items: shelters.map((String shelter) {
                            return DropdownMenuItem<String>(
                              value: shelter,
                              child: Text(shelter,
                                  style: const TextStyle(color: Colors.black)),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedShelter = newValue;
                            });
                          },
                          decoration: InputDecoration(
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
                          dropdownColor: Colors.white,
                        ),
                        const SizedBox(height: 25),
                        Text('Imagem do pet',
                            style: TextStyle(color: Colors.grey.shade500)),
                        const SizedBox(height: 3),
                        Center(
                          child: Column(
                            children: [
                              if (_imageFile == null)
                                const Text('Nenhuma imagem selecionada.',
                                    style: TextStyle(color: Colors.white))
                              else if (kIsWeb && _webImage != null)
                                Image.memory(
                                  _webImage!,
                                  height: 150,
                                )
                              else if (_imageFile != null)
                                Image.file(
                                  File(_imageFile!.path),
                                  height: 150,
                                ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () =>
                                    _pickImage(ImageSource.gallery),
                                child: const Text('Escolher da Galeria'),
                              ),
                              ElevatedButton(
                                onPressed: () => _pickImage(ImageSource.camera),
                                child: const Text('Tirar uma Foto'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        Text('Descrição',
                            style: TextStyle(color: Colors.grey.shade500)),
                        const SizedBox(height: 3),
                        TextField(
                          controller: _descricaoController,
                          decoration: InputDecoration(
                            hintText: 'Digite a descrição do pet',
                            errorText: _descricaoError,
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
                          maxLines: 3,
                        ),
                        const SizedBox(height: 70),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _isLoading =
                                    true;
                              });
                              // Validações
                              _validateNome();
                              _validateIdade();
                              _validatePeso();
                              _validateDescricao();
                              await _uploadImage(); // Upload da imagem

                              if (_nomeError == null &&
                                  _idadeError == null &&
                                  _pesoError == null &&
                                  _descricaoError == null &&
                                  selectedAnimalType != null &&
                                  selectedShelter != null) {
                                try {
                                  await _petController.registerPet(
                                    name: _nomeController.text,
                                    age: _idadeController.text,
                                    weight: _pesoController.text,
                                    animalType: selectedAnimalType!,
                                    shelterId: selectedShelter!,
                                    description: _descricaoController.text,
                                    imageUrl:
                                        _imageUrl, // Adiciona a URL da imagem ao cadastro do pet
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Pet cadastrado com sucesso!'),
                                    ),
                                  );
                                  Navigator.pop(context);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Erro ao cadastrar pet: $e'),
                                    ),
                                  );
                                } finally {
                                  setState(() {
                                    _isLoading =
                                        false;
                                  });
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Por favor, preencha todos os campos.'),
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
              ),
            ],
          ),
          if (_isLoading)
                          Container(
                            color: Colors.black.withOpacity(0.5),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
        ],
      ),
    );
  }
}
