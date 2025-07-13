# 🐾 Adogção - App de Adoção de Animais

[![Flutter](https://img.shields.io/badge/Flutter-3.4.4-blue.svg)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Latest-orange.svg)](https://firebase.google.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Um aplicativo móvel moderno e intuitivo para conectar pessoas que desejam adotar animais com abrigos e lares temporários. Desenvolvido com Flutter e Firebase.

## ✨ Características

- 🎨 **Interface moderna** com design responsivo e animações suaves
- 🔐 **Autenticação segura** com Firebase Auth
- 📱 **Funcionalidades completas** para adoção de animais
- 🗺️ **Integração com mapas** para localização de abrigos
- 🔍 **Sistema de filtros avançado** para encontrar o animal perfeito
- ❤️ **Sistema de favoritos** para salvar animais de interesse
- 📸 **Upload de imagens** com Firebase Storage
- 🌙 **Modo escuro/claro** automático
- 📍 **Geolocalização** para encontrar animais próximos

## 🚀 Tecnologias Utilizadas

- **Flutter 3.4.4** - Framework de desenvolvimento
- **Firebase** - Backend como serviço
  - Firebase Auth - Autenticação
  - Cloud Firestore - Banco de dados
  - Firebase Storage - Armazenamento de arquivos
- **Google Maps** - Integração com mapas
- **Provider** - Gerenciamento de estado
- **Google Fonts** - Tipografia moderna

## 📱 Funcionalidades Principais

### Para Usuários

- ✅ Cadastro e login de usuários
- ✅ Visualização de animais disponíveis para adoção
- ✅ Filtros por tipo, idade, tamanho e localização
- ✅ Sistema de favoritos
- ✅ Detalhes completos dos animais
- ✅ Contato com abrigos
- ✅ Perfil de usuário personalizável

### Para Abrigos e Voluntários

- ✅ Cadastro de abrigos e lares temporários
- ✅ Cadastro de animais para adoção
- ✅ Gerenciamento de perfis de animais
- ✅ Edição de informações
- ✅ Visualização de interessados

## 🛠️ Instalação e Configuração

### Pré-requisitos

- Flutter SDK 3.4.4 ou superior
- Dart SDK
- Android Studio / VS Code
- Conta no Firebase

### Passos para Instalação

1. **Clone o repositório**

   ```bash
   git clone https://github.com/seu-usuario/adogcao.git
   cd adogcao
   ```

2. **Instale as dependências**

   ```bash
   flutter pub get
   ```

3. **Configure o Firebase**

   - Crie um projeto no [Firebase Console](https://console.firebase.google.com/)
   - Adicione um app Android/iOS
   - Baixe o arquivo `google-services.json` (Android) ou `GoogleService-Info.plist` (iOS)
   - Coloque o arquivo na pasta apropriada do projeto

4. **Configure as variáveis de ambiente**

   - Copie o arquivo `.env.example` para `.env`
   - Preencha as variáveis necessárias

5. **Execute o projeto**
   ```bash
   flutter run
   ```

## 📁 Estrutura do Projeto

```
lib/
├── core/
│   ├── constants/          # Constantes da aplicação
│   ├── theme/             # Temas e estilos
│   ├── utils/             # Utilitários e helpers
│   ├── services/          # Serviços externos
│   └── widgets/           # Widgets reutilizáveis
├── features/
│   ├── auth/              # Funcionalidades de autenticação
│   ├── animals/           # Funcionalidades relacionadas aos animais
│   └── shelters/          # Funcionalidades de abrigos
├── models/                # Modelos de dados
├── controllers/           # Controladores de estado
├── views/                 # Telas da aplicação
├── widgets/               # Widgets específicos
└── session/               # Gerenciamento de sessão
```

## 🔧 Configuração do Firebase

### Firestore Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Usuários podem ler/editar apenas seus próprios dados
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Animais podem ser lidos por todos, editados apenas pelo criador
    match /animals/{animalId} {
      allow read: if true;
      allow write: if request.auth != null &&
        request.auth.uid == resource.data.userId;
    }

    // Favoritos podem ser lidos/escritos apenas pelo usuário
    match /favorites/{favoriteId} {
      allow read, write: if request.auth != null &&
        request.auth.uid == resource.data.userId;
    }
  }
}
```

### Storage Rules

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /animals/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }

    match /users/{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## 🎨 Design System

O app utiliza um design system consistente com:

- **Cores principais**: Azul (#1E3A8A), Verde (#10B981)
- **Tipografia**: Google Fonts (Poppins)
- **Componentes**: Botões, campos de texto e cards customizados
- **Animações**: Transições suaves e feedback visual

## 📊 Funcionalidades Futuras

- [ ] Chat em tempo real entre usuários e abrigos
- [ ] Sistema de notificações push
- [ ] Integração com redes sociais
- [ ] Sistema de avaliações e comentários
- [ ] Relatórios e estatísticas para abrigos
- [ ] Modo offline com sincronização
- [ ] Integração com veterinários
- [ ] Sistema de doações

## 🤝 Contribuição

Contribuições são bem-vindas! Para contribuir:

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📝 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 👥 Equipe

- **Matheus Santiago** - Desenvolvedor Full Stack
- **UFRPE** - Universidade Federal Rural de Pernambuco
- **DSI** - Departamento de Sistemas de Informação

## 📞 Suporte

- 📧 Email: suporte@adogcao.com
- 🐛 Issues: [GitHub Issues](https://github.com/seu-usuario/adogcao/issues)
- 📖 Documentação: [Wiki do Projeto](https://github.com/seu-usuario/adogcao/wiki)

## 🙏 Agradecimentos

- Flutter Team pelo framework incrível
- Firebase pela infraestrutura robusta
- Comunidade Flutter pela documentação e suporte
- Todos os abrigos e voluntários que inspiram este projeto

---

**Adogção** - Conectando corações, salvando vidas 🐾❤️
