import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email inválido';
    }
    
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }
    
    if (value.length < AppConstants.minPasswordLength) {
      return 'Senha deve ter pelo menos ${AppConstants.minPasswordLength} caracteres';
    }
    
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirme sua senha';
    }
    
    if (value != password) {
      return 'Senhas não coincidem';
    }
    
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome é obrigatório';
    }
    
    if (value.length > AppConstants.maxNameLength) {
      return 'Nome muito longo';
    }
    
    if (value.length < 2) {
      return 'Nome deve ter pelo menos 2 caracteres';
    }
    
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefone é obrigatório';
    }
    
    // Remove caracteres especiais para validação
    final cleanPhone = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanPhone.length < 10 || cleanPhone.length > 11) {
      return 'Telefone inválido';
    }
    
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }
    
    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Descrição é obrigatória';
    }
    
    if (value.length > AppConstants.maxDescriptionLength) {
      return 'Descrição muito longa';
    }
    
    if (value.length < 10) {
      return 'Descrição deve ter pelo menos 10 caracteres';
    }
    
    return null;
  }

  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Idade é obrigatória';
    }
    
    final age = int.tryParse(value);
    if (age == null || age < 0 || age > 30) {
      return 'Idade inválida';
    }
    
    return null;
  }

  static String? validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Peso é obrigatório';
    }
    
    final weight = double.tryParse(value.replaceAll(',', '.'));
    if (weight == null || weight <= 0 || weight > 1000) {
      return 'Peso inválido';
    }
    
    return null;
  }

  static String? validateLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Localização é obrigatória';
    }
    
    if (value.length < 5) {
      return 'Localização muito curta';
    }
    
    return null;
  }

  static String? validateImage(String? value) {
    if (value == null || value.isEmpty) {
      return 'Imagem é obrigatória';
    }
    
    return null;
  }

  // Validação de formulário completo
  static bool validateForm(GlobalKey<FormState> formKey) {
    if (formKey.currentState != null) {
      return formKey.currentState!.validate();
    }
    return false;
  }

  // Limpar formulário
  static void clearForm(GlobalKey<FormState> formKey) {
    if (formKey.currentState != null) {
      formKey.currentState!.reset();
    }
  }
} 