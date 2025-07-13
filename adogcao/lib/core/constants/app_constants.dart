class AppConstants {
  // Nomes das coleções do Firestore
  static const String usersCollection = 'users';
  static const String animalsCollection = 'animals';
  static const String sheltersCollection = 'shelters';
  static const String favoritesCollection = 'favorites';
  static const String temporaryHomesCollection = 'temporary_homes';
  
  // Tipos de animais
  static const List<String> animalTypes = [
    'Cachorro',
    'Gato',
    'Pássaro',
    'Coelho',
    'Cavalo',
    'Hamster',
    'Porquinho-da-índia',
    'Peixe',
    'Tartaruga',
    'Outros'
  ];
  
  // Idades dos animais
  static const List<String> animalAges = [
    'Filhote (0-1 ano)',
    'Jovem (1-3 anos)',
    'Adulto (3-7 anos)',
    'Idoso (7+ anos)'
  ];
  
  // Tamanhos dos animais
  static const List<String> animalSizes = [
    'Pequeno',
    'Médio',
    'Grande'
  ];
  
  // Status de adoção
  static const String statusAvailable = 'disponível';
  static const String statusAdopted = 'adotado';
  static const String statusPending = 'pendente';
  
  // Configurações de localização
  static const double defaultLatitude = -8.0476; // Recife
  static const double defaultLongitude = -34.8770;
  static const double maxDistanceKm = 50.0;
  
  // Configurações de paginação
  static const int itemsPerPage = 10;
  
  // Configurações de cache
  static const Duration cacheDuration = Duration(hours: 1);
  
  // URLs e endpoints
  static const String privacyPolicyUrl = 'https://adogcao.com/privacy';
  static const String termsOfServiceUrl = 'https://adogcao.com/terms';
  static const String supportEmail = 'suporte@adogcao.com';
  
  // Mensagens de erro
  static const String networkErrorMessage = 'Erro de conexão. Verifique sua internet.';
  static const String generalErrorMessage = 'Algo deu errado. Tente novamente.';
  static const String authErrorMessage = 'Email ou senha incorretos.';
  static const String permissionErrorMessage = 'Permissão negada.';
  
  // Mensagens de sucesso
  static const String loginSuccessMessage = 'Login realizado com sucesso!';
  static const String registrationSuccessMessage = 'Conta criada com sucesso!';
  static const String animalSavedMessage = 'Animal salvo com sucesso!';
  static const String profileUpdatedMessage = 'Perfil atualizado com sucesso!';
  
  // Validações
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 500;
  
  // Animações
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
} 