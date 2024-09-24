import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  final Function(
          String? selectedShelter, int? selectedAge, double? selectedWeight)
      onApplyFilters;

  const FilterScreen({Key? key, required this.onApplyFilters})
      : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String? selectedShelter;
  int? selectedAge;
  double? selectedWeight;

  List<String> shelters = [];
  List<int> ages = [];
  List<double> weights = [];

  @override
  void initState() {
    super.initState();
    fetchFilterData(); // Buscar dados para preencher os dropdowns
  }

  Future<void> fetchFilterData() async {
    final snapshot = await FirebaseFirestore.instance.collection('pets').get();
    final pets = snapshot.docs.map((doc) => doc.data()).toList();

    final shelterSet = <String>{};
    final ageSet = <int>{};
    final weightSet = <double>{};

    for (var pet in pets) {
      shelterSet.add(pet['shelterId']);
      ageSet.add(pet['age']);
      weightSet.add(pet['weight'].toDouble());
    }

    setState(() {
      shelters = shelterSet.toList();
      ages = ageSet.toList()..sort();
      weights = weightSet.toList()..sort();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF001E3C),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Filtrar Animais',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            // Dropdown para Abrigo
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Selecionar Abrigo',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              dropdownColor: Colors.grey[800],
              value: selectedShelter,
              items: shelters.map((shelter) {
                return DropdownMenuItem(
                  value: shelter,
                  child: Text(shelter, style: TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedShelter = value;
                });
              },
            ),
            SizedBox(height: 20),
            // Dropdown para Idade
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: 'Selecionar Idade',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              dropdownColor: Colors.grey[800],
              value: selectedAge,
              items: ages.map((age) {
                return DropdownMenuItem(
                  value: age,
                  child:
                      Text('$age anos', style: TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedAge = value;
                });
              },
            ),
            SizedBox(height: 20),
            // Dropdown para Peso
            DropdownButtonFormField<double>(
              decoration: InputDecoration(
                labelText: 'Selecionar Peso',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              dropdownColor: Colors.grey[800],
              value: selectedWeight,
              items: weights.map((weight) {
                return DropdownMenuItem(
                  value: weight,
                  child: Text('${weight.toStringAsFixed(1)} kg',
                      style: TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedWeight = value;
                });
              },
            ),
            SizedBox(height: 30),
            // Botão de Aplicar Filtros
            ElevatedButton(
              onPressed: () {
                widget.onApplyFilters(
                    selectedShelter, selectedAge, selectedWeight);
                Navigator.pop(context); // Fecha a tela de filtro
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
              ),
              child: Text(
                'Aplicar Filtros',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
