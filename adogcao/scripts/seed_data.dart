import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCnrIaWPLaTizXxJfcKveVoQJYi-FY3yq4",
      authDomain: "adogcao-1b54a.firebaseapp.com",
      projectId: "adogcao-1b54a",
      storageBucket: "adogcao-1b54a.appspot.com",
      messagingSenderId: "200884834778",
      appId: "1:200884834778:web:adogcao-app",
    ),
  );

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Dados de exemplo para pets
  final List<Map<String, dynamic>> petsData = [
    {
      'name': 'Thor',
      'imageUrl': 'lib/images/thor.png',
      'location': 'Recife, PE',
      'description': 'Thor é um cachorro muito brincalhão e carinhoso. Adora crianças e passeios no parque.',
      'age': '3 anos',
      'weight': '25kg',
      'animalType': 'Cachorro',
      'userId': 'exemplo_user_id',
      'createdAt': FieldValue.serverTimestamp(),
    },
    {
      'name': 'Lua',
      'imageUrl': 'lib/images/lua.png',
      'location': 'Olinda, PE',
      'description': 'Lua é uma gata tranquila e independente. Perfeita para apartamentos.',
      'age': '2 anos',
      'weight': '4kg',
      'animalType': 'Gato',
      'userId': 'exemplo_user_id',
      'createdAt': FieldValue.serverTimestamp(),
    },
    {
      'name': 'Mel',
      'imageUrl': 'lib/images/mel.png',
      'location': 'Jaboatão, PE',
      'description': 'Mel é uma cadela muito dócil e protetora. Ideal para famílias.',
      'age': '4 anos',
      'weight': '30kg',
      'animalType': 'Cachorro',
      'userId': 'exemplo_user_id',
      'createdAt': FieldValue.serverTimestamp(),
    },
  ];

  // Dados de exemplo para abrigos
  final List<Map<String, dynamic>> abrigosData = [
    {
      'nome': 'Abrigo Amor aos Animais',
      'email': 'contato@amoraosanimais.org',
      'endereco': 'Rua das Flores, 123 - Recife, PE',
      'telefone': '(81) 99999-9999',
      'lat': -8.0476,
      'lng': -34.8770,
      'volunteerId': 'exemplo_volunteer_id',
      'createdAt': FieldValue.serverTimestamp(),
    },
    {
      'nome': 'Lar Temporário Recife',
      'email': 'contato@lartemporario.org',
      'endereco': 'Av. Boa Viagem, 456 - Recife, PE',
      'telefone': '(81) 88888-8888',
      'lat': -8.1198,
      'lng': -34.9047,
      'volunteerId': 'exemplo_volunteer_id',
      'createdAt': FieldValue.serverTimestamp(),
    },
  ];

  try {
    // Adicionar pets
    for (var pet in petsData) {
      await firestore.collection('pets').add(pet);
      print('Pet adicionado: ${pet['name']}');
    }

    // Adicionar abrigos
    for (var abrigo in abrigosData) {
      await firestore.collection('abrigos').add(abrigo);
      print('Abrigo adicionado: ${abrigo['nome']}');
    }

    print('Dados de exemplo adicionados com sucesso!');
  } catch (e) {
    print('Erro ao adicionar dados: $e');
  }
} 