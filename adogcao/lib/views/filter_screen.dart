import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/filterAnimalController.dart';

class FilterScreen extends StatefulWidget {
  final Function(String?, String?, String?) onApplyFilters;

  const FilterScreen({required this.onApplyFilters, Key? key})
      : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final FilterAnimalController _filterAnimalController =
      FilterAnimalController();
  String? selectedShelter;
  String? selectedAge;
  String? selectedWeight;
  List<String> shelterOptions = [];
  List<String> ageOptions = [];
  List<String> weightOptions = [];

  @override
  void initState() {
    super.initState();
    loadFilterOptions();
  }

  Future<void> loadFilterOptions() async {
    try {
      // Carrega as opções de filtros utilizando o controller
      shelterOptions = await _filterAnimalController.getShelters();
      ageOptions = await _filterAnimalController.getAges();
      weightOptions = await _filterAnimalController.getWeights();

      setState(() {}); // Atualiza o estado com as novas opções carregadas
    } catch (e) {
      print('Erro ao carregar opções de filtro: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtrar Animais'),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF001E3C),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDropdown(
                label: 'Selecionar Abrigo',
                value: selectedShelter,
                items: shelterOptions,
                onChanged: (value) {
                  setState(() {
                    selectedShelter = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              buildDropdown(
                label: 'Selecionar Idade',
                value: selectedAge,
                items: ageOptions,
                onChanged: (value) {
                  setState(() {
                    selectedAge = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              buildDropdown(
                label: 'Selecionar Peso',
                value: selectedWeight,
                items: weightOptions,
                onChanged: (value) {
                  setState(() {
                    selectedWeight = value;
                  });
                },
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApplyFilters(
                        selectedShelter, selectedAge, selectedWeight);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007EA7),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Aplicar Filtros',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF243447),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white),
            ),
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: const Color(0xFF243447),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              underline: Container(),
              onChanged: onChanged,
              items: items
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
