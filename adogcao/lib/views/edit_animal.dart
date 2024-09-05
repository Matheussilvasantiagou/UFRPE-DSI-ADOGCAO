import '../session/AnimalSession.dart';
import '../controllers/edit_animal_controller.dart';
import 'package:flutter/material.dart';

class EditAnimalScreen extends StatefulWidget {
  final String docId; // Adicione o docId como um parâmetro

  EditAnimalScreen({required this.docId}); // Construtor para aceitar o docId

  @override
  _EditAnimalScreenState createState() => _EditAnimalScreenState();
}

class _EditAnimalScreenState extends State<EditAnimalScreen> {
  final EditAnimalController _controller = EditAnimalController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Preenche os controladores com os valores existentes da sessão
    _nameController.text = AnimalSession.instance.animalName ?? '';
    _ageController.text = AnimalSession.instance.animalAge ?? '';
    _weightController.text = AnimalSession.instance.animalWeight ?? '';
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 55),
                      Text('Nome do Animal',
                          style: TextStyle(color: Colors.grey.shade500)),
                      SizedBox(height: 3),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Nome',
                          hintStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.grey.shade800,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: Colors.grey.shade600, width: 1),
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 15),
                      Text('Idade do Animal',
                          style: TextStyle(color: Colors.grey.shade500)),
                      SizedBox(height: 3),
                      TextField(
                        controller: _ageController,
                        decoration: InputDecoration(
                          hintText: 'Idade',
                          hintStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.grey.shade800,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: Colors.grey.shade600, width: 1),
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 15),
                      Text('Peso do Animal (kg)',
                          style: TextStyle(color: Colors.grey.shade500)),
                      SizedBox(height: 3),
                      TextField(
                        controller: _weightController,
                        decoration: InputDecoration(
                          hintText: 'Peso',
                          hintStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.grey.shade800,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: Colors.grey.shade600, width: 1),
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 25),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            // Captura os valores dos campos
                            String name = _nameController.text;
                            String age = _ageController.text;
                            String weight = _weightController.text;

                            // Verifica se pelo menos um campo foi alterado
                            if (name.isNotEmpty ||
                                age.isNotEmpty ||
                                weight.isNotEmpty) {
                              try {
                                // Atualizar dados do animal no sistema, passando o docId
                                await _controller.editAnimal(
                                  widget.docId, // Usar o docId da widget
                                  name,
                                  age,
                                  weight,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Dados do animal salvos com sucesso!')),
                                );
                                Navigator.pop(context);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Erro ao salvar dados do animal: ${e.toString()}')),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Nenhum dado foi alterado.')),
                              );
                            }
                          },
                          child: Text('Salvar',
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
