# Configuração do Firestore - App de Adoção

## 📋 Coleções Configuradas

### 1. **users** - Usuários do Sistema

**Estrutura:**

```json
{
  "name": "string",
  "email": "string",
  "phoneNumber": "string",
  "isVolunteer": "boolean",
  "createdAt": "timestamp",
  "uid": "string"
}
```

### 2. **pets** - Animais para Adoção

**Estrutura:**

```json
{
  "name": "string",
  "imageUrl": "string",
  "location": "string",
  "description": "string",
  "age": "string",
  "weight": "string",
  "animalType": "string",
  "userId": "string",
  "shelterId": "string",
  "createdAt": "timestamp"
}
```

### 3. **abrigos** - Abrigos e ONGs

**Estrutura:**

```json
{
  "nome": "string",
  "email": "string",
  "endereco": "string",
  "telefone": "string",
  "lat": "number",
  "lng": "number",
  "volunteerId": "string",
  "createdAt": "timestamp"
}
```

### 4. **lar_temporario** - Lar Temporário

**Estrutura:**

```json
{
  "nome": "string",
  "email": "string",
  "endereco": "string",
  "telefone": "string",
  "lat": "number",
  "lng": "number",
  "userId": "string",
  "createdAt": "timestamp"
}
```

## 🔒 Regras de Segurança

### Usuários

- **Leitura/Escrita**: Apenas o próprio usuário
- **Leitura**: Usuários logados podem ver outros usuários

### Pets

- **Leitura**: Pública (qualquer pessoa pode ver)
- **Criação**: Usuários logados
- **Edição/Exclusão**: Proprietário do pet ou abrigo

### Abrigos

- **Leitura**: Pública
- **Criação**: Usuários logados
- **Edição/Exclusão**: Voluntário responsável

### Lar Temporário

- **Leitura**: Pública
- **Criação**: Usuários logados
- **Edição/Exclusão**: Proprietário do lar

## 📊 Índices Configurados

1. **pets** por `userId` + `createdAt`
2. **pets** por `animalType` + `createdAt`
3. **abrigos** por `volunteerId` + `createdAt`
4. **lar_temporario** por `userId` + `createdAt`

## 🚀 Como Usar

### Executar o App

```bash
flutter run -d chrome
```

### Adicionar Dados de Exemplo (Opcional)

```bash
dart scripts/seed_data.dart
```

### Deploy das Regras

```bash
firebase deploy --only firestore:rules
```

### Deploy dos Índices

```bash
firebase deploy --only firestore:indexes
```

## 🔧 Configuração Completa

✅ **Firebase Project**: adogcao-1b54a
✅ **Authentication**: Habilitado (Email/Password)
✅ **Firestore Database**: Criado
✅ **Regras de Segurança**: Configuradas
✅ **Índices**: Otimizados
✅ **Coleções**: Estrutura definida

## 📱 Funcionalidades Disponíveis

- ✅ Registro de usuários
- ✅ Login de usuários
- ✅ Cadastro de pets
- ✅ Listagem de pets
- ✅ Cadastro de abrigos
- ✅ Lar temporário
- ✅ Filtros de busca
- ✅ Geolocalização

O app está completamente configurado e pronto para uso! 🐕🐱
