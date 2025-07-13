# 📋 Como Popular o Firebase Firestore

Este diretório contém scripts e dados para popular o Firebase Firestore com dados de exemplo para o projeto Adoção.

## 🗂️ Estrutura das Tabelas

### 1. **`users`** - Usuários do Sistema

- `name` (string) - Nome do usuário
- `email` (string) - Email do usuário
- `phoneNumber` (string) - Telefone do usuário
- `isVolunteer` (boolean) - Se é voluntário
- `createdAt` (timestamp) - Data de criação
- `uid` (string) - ID único do usuário

### 2. **`pets`** - Animais para Adoção

- `name` (string) - Nome do animal
- `imageUrl` (string) - URL da imagem do animal
- `location` (string) - Localização (cidade, estado)
- `description` (string) - Descrição do animal
- `age` (string) - Idade do animal
- `weight` (string) - Peso do animal
- `animalType` (string) - Tipo do animal (Cachorro, Gato, etc.)
- `userId` (string) - ID do usuário que cadastrou
- `createdAt` (timestamp) - Data de criação

### 3. **`abrigos`** - Abrigos de Animais

- `nome` (string) - Nome do abrigo
- `email` (string) - Email do abrigo
- `endereco` (string) - Endereço completo
- `telefone` (string) - Telefone do abrigo
- `lat` (number) - Latitude da localização
- `lng` (number) - Longitude da localização
- `volunteerId` (string) - ID do voluntário responsável
- `createdAt` (timestamp) - Data de criação

### 4. **`lar_temporario`** - Lares Temporários

- `uid` (string) - ID do usuário responsável
- `nome` (string) - Nome do responsável
- `telefone` (string) - Telefone do responsável
- `endereco` (string) - Endereço do lar temporário
- `latitude` (number) - Latitude da localização
- `longitude` (number) - Longitude da localização
- `tiposAnimais` (array) - Lista de tipos de animais aceitos
- `capacidade` (number) - Capacidade de animais

## 🚀 Métodos para Popular o Firebase

### Opção 1: Firebase Console (Mais Fácil)

1. Acesse o [Firebase Console](https://console.firebase.google.com/)
2. Selecione seu projeto `adogcao-1b54a`
3. Vá para **Firestore Database**
4. Para cada coleção (`users`, `pets`, `abrigos`, `lar_temporario`):
   - Clique em **"Adicionar documento"**
   - Use os dados do arquivo `firebase_seed_data.json`
   - Ou copie os dados manualmente

### Opção 2: Script Python

**Pré-requisitos:**

```bash
pip install firebase-admin
```

**Executar:**

```bash
cd scripts
python seed_firebase.py
```

### Opção 3: Script Dart (Flutter)

**Executar:**

```bash
cd adogcao
flutter run -d chrome --target=scripts/seed_data_simple.dart
```

## 📊 Dados de Exemplo Incluídos

### Pets

- **Thor**: Cachorro, 3 anos, 25kg, Recife
- **Lua**: Gato, 2 anos, 4kg, Olinda
- **Mel**: Cachorro, 4 anos, 30kg, Jaboatão

### Abrigos

- **Abrigo Amor aos Animais**: Recife
- **Lar Temporário Recife**: Recife

### Usuários

- **João Silva**: Voluntário
- **Maria Santos**: Usuário comum

### Lares Temporários

- **João Silva**: Aceita cães e gatos, capacidade 5
- **Maria Santos**: Aceita apenas gatos, capacidade 3

## ⚠️ Importante

- Certifique-se de que o Firebase está configurado corretamente
- Verifique se as regras de segurança do Firestore permitem escrita
- Os dados são apenas para teste/desenvolvimento
- Em produção, use dados reais e apropriados

## 🔧 Configuração do Firebase

Se você ainda não configurou o Firebase:

1. Crie um projeto no [Firebase Console](https://console.firebase.google.com/)
2. Ative o Firestore Database
3. Configure as regras de segurança
4. Baixe o arquivo `google-services.json` e coloque na raiz do projeto
5. Configure as credenciais no seu app Flutter

## 📝 Regras de Segurança Sugeridas

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Usuários podem ler/escrever seus próprios dados
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Pets podem ser lidos por todos, escritos por usuários autenticados
    match /pets/{petId} {
      allow read: if true;
      allow write: if request.auth != null;
    }

    // Abrigos podem ser lidos por todos, escritos por voluntários
    match /abrigos/{abrigoId} {
      allow read: if true;
      allow write: if request.auth != null &&
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isVolunteer == true;
    }

    // Lares temporários podem ser lidos por todos, escritos por usuários autenticados
    match /lar_temporario/{larId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```
