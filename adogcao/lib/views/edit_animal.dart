import '../session/AnimalSession.dart';
import '../controllers/edit_animal_controller.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditAnimalScreen extends StatefulWidget {
  final String docId; // Adicione o docId como um parâmetro

  const EditAnimalScreen({super.key, required this.docId}); // Construtor para aceitar o docId

  @override
  _EditAnimalScreenState createState() => _EditAnimalScreenState();
}

class _EditAnimalScreenState extends State<EditAnimalScreen> {
  final EditAnimalController _controller = EditAnimalController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  XFile? _imageFile;
  Uint8List? _webImage;
  String? _imageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPetData();
  }

  Future<void> _fetchPetData() async {
    try {
      final doc = await FirebaseFirestore.instance.collection('pets').doc(widget.docId).get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _nameController.text = data['name'] ?? '';
          _ageController.text = data['age'] ?? '';
          _weightController.text = data['weight'] ?? '';
          _imageUrl = data['imageUrl'] ?? '';
        });
      }
    } catch (e) {
      print('Erro ao buscar dados do pet: ' + e.toString());
    }
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.single.bytes != null) {
        setState(() {
          _webImage = result.files.single.bytes;
          _imageFile = null;
        });
      }
    } else {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    }
  }

  Future<void> _uploadImage() async {
    print('Entrou no _uploadImage');
    if (_imageFile == null && _webImage == null) {
      print('Nenhuma imagem selecionada, saindo do upload');
      return;
    }
    String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    UploadTask uploadTask;
    if (kIsWeb && _webImage != null) {
      print('Fazendo upload via web');
      uploadTask = FirebaseStorage.instance
          .ref()
          .child('pets_images')
          .child(fileName)
          .putData(_webImage!);
    } else if (_imageFile != null) {
      print('Fazendo upload via arquivo');
      uploadTask = FirebaseStorage.instance
          .ref()
          .child('pets_images')
          .child(fileName)
          .putFile(File(_imageFile!.path));
    } else {
      print('Caiu no else final, saindo do upload');
      return;
    }
    print('Aguardando uploadTask');
    TaskSnapshot snapshot = await uploadTask;
    print('Upload finalizado, pegando URL');
    _imageUrl = await snapshot.ref.getDownloadURL();
    print('URL da imagem:  [32m [1m [4m$_imageUrl [0m');
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
          SingleChildScrollView(
            child: Column(
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
                            'Edição do animal',
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 55),
                      Text('Nome do Animal',
                          style: TextStyle(color: Colors.grey.shade500)),
                      const SizedBox(height: 3),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Nome',
                          hintStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.grey.shade800,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: Colors.grey.shade600, width: 1),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 15),
                      Text('Idade do Animal',
                          style: TextStyle(color: Colors.grey.shade500)),
                      const SizedBox(height: 3),
                      TextField(
                        controller: _ageController,
                        decoration: InputDecoration(
                          hintText: 'Idade',
                          hintStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.grey.shade800,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: Colors.grey.shade600, width: 1),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 15),
                      Text('Peso do Animal (kg)',
                          style: TextStyle(color: Colors.grey.shade500)),
                      const SizedBox(height: 3),
                      TextField(
                        controller: _weightController,
                        decoration: InputDecoration(
                          hintText: 'Peso',
                          hintStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.grey.shade800,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: Colors.grey.shade600, width: 1),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 25),
                      Text('Imagem do Pet', style: TextStyle(color: Colors.grey.shade500)),
                      const SizedBox(height: 3),
                      Center(
                        child: Column(
                          children: [
                            if (_webImage != null)
                              Image.memory(_webImage!, height: 120)
                            else if (_imageFile != null)
                              Image.file(File(_imageFile!.path), height: 120)
                            else if (_imageUrl != null && _imageUrl!.isNotEmpty)
                              Image.network(_imageUrl!, height: 120)
                            else
                              const Text('Nenhuma imagem selecionada.', style: TextStyle(color: Colors.white)),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: _pickImage,
                              child: const Text('Escolher nova imagem'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() { _isLoading = true; });
                            print('Iniciando upload de imagem');
                            try {
                              await _uploadImage();
                              print('Upload de imagem finalizado');
                              await _controller.editAnimal(
                                widget.docId,
                                _nameController.text,
                                _ageController.text,
                                _weightController.text,
                                _imageUrl ?? '',
                              );
                              print('Edit animal finalizado');
                              if (mounted) {
                                Navigator.of(context).pop();
                              }
                            } catch (e) {
                              print('Erro: ' + e.toString());
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Erro ao salvar: ' + e.toString())),
                                );
                              }
                            } finally {
                              print('Finalizando loading');
                              if (mounted) {
                                setState(() { _isLoading = false; });
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
                          child: _isLoading ? const CircularProgressIndicator() : const Text('Salvar Alterações'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
