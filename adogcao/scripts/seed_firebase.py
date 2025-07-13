#!/usr/bin/env python3
"""
Script para popular o Firebase Firestore com dados de exemplo
"""

import json
from datetime import datetime

import firebase_admin
from firebase_admin import credentials, firestore

# Configuração do Firebase
cred = credentials.Certificate("google-services.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

def add_pets():
    """Adiciona pets de exemplo"""
    pets_data = [
        {
            'name': 'Thor',
            'imageUrl': 'lib/images/thor.png',
            'location': 'Recife, PE',
            'description': 'Thor é um cachorro muito brincalhão e carinhoso. Adora crianças e passeios no parque.',
            'age': '3 anos',
            'weight': '25kg',
            'animalType': 'Cachorro',
            'userId': 'exemplo_user_id',
            'createdAt': firestore.SERVER_TIMESTAMP,
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
            'createdAt': firestore.SERVER_TIMESTAMP,
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
            'createdAt': firestore.SERVER_TIMESTAMP,
        },
    ]
    
    for pet in pets_data:
        doc_ref = db.collection('pets').add(pet)
        print(f'Pet adicionado: {pet["name"]} (ID: {doc_ref[1].id})')

def add_abrigos():
    """Adiciona abrigos de exemplo"""
    abrigos_data = [
        {
            'nome': 'Abrigo Amor aos Animais',
            'email': 'contato@amoraosanimais.org',
            'endereco': 'Rua das Flores, 123 - Recife, PE',
            'telefone': '(81) 99999-9999',
            'lat': -8.0476,
            'lng': -34.8770,
            'volunteerId': 'exemplo_volunteer_id',
            'createdAt': firestore.SERVER_TIMESTAMP,
        },
        {
            'nome': 'Lar Temporário Recife',
            'email': 'contato@lartemporario.org',
            'endereco': 'Av. Boa Viagem, 456 - Recife, PE',
            'telefone': '(81) 88888-8888',
            'lat': -8.1198,
            'lng': -34.9047,
            'volunteerId': 'exemplo_volunteer_id',
            'createdAt': firestore.SERVER_TIMESTAMP,
        },
    ]
    
    for abrigo in abrigos_data:
        doc_ref = db.collection('abrigos').add(abrigo)
        print(f'Abrigo adicionado: {abrigo["nome"]} (ID: {doc_ref[1].id})')

def add_users():
    """Adiciona usuários de exemplo"""
    users_data = [
        {
            'name': 'João Silva',
            'email': 'joao@exemplo.com',
            'phoneNumber': '(81) 99999-9999',
            'isVolunteer': True,
            'createdAt': firestore.SERVER_TIMESTAMP,
            'uid': 'user1'
        },
        {
            'name': 'Maria Santos',
            'email': 'maria@exemplo.com',
            'phoneNumber': '(81) 88888-8888',
            'isVolunteer': False,
            'createdAt': firestore.SERVER_TIMESTAMP,
            'uid': 'user2'
        },
    ]
    
    for user in users_data:
        doc_ref = db.collection('users').document(user['uid']).set(user)
        print(f'Usuário adicionado: {user["name"]} (ID: {user["uid"]})')

def add_lar_temporario():
    """Adiciona lares temporários de exemplo"""
    lares_data = [
        {
            'uid': 'user1',
            'nome': 'João Silva',
            'telefone': '(81) 99999-9999',
            'endereco': 'Rua das Palmeiras, 789 - Recife, PE',
            'latitude': -8.0476,
            'longitude': -34.8770,
            'tiposAnimais': ['Cachorro', 'Gato'],
            'capacidade': 5,
        },
        {
            'uid': 'user2',
            'nome': 'Maria Santos',
            'telefone': '(81) 88888-8888',
            'endereco': 'Av. Conde da Boa Vista, 321 - Recife, PE',
            'latitude': -8.1198,
            'longitude': -34.9047,
            'tiposAnimais': ['Gato'],
            'capacidade': 3,
        },
    ]
    
    for lar in lares_data:
        doc_ref = db.collection('lar_temporario').add(lar)
        print(f'Lar temporário adicionado: {lar["nome"]} (ID: {doc_ref[1].id})')

def main():
    """Função principal"""
    print("Iniciando população do Firebase Firestore...")
    
    try:
        print("\n1. Adicionando usuários...")
        add_users()
        
        print("\n2. Adicionando pets...")
        add_pets()
        
        print("\n3. Adicionando abrigos...")
        add_abrigos()
        
        print("\n4. Adicionando lares temporários...")
        add_lar_temporario()
        
        print("\n✅ Dados de exemplo adicionados com sucesso!")
        
    except Exception as e:
        print(f"\n❌ Erro ao adicionar dados: {e}")

if __name__ == "__main__":
    main() 