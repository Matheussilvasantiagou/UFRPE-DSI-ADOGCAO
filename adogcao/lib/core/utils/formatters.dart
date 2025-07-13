import 'package:intl/intl.dart';

class Formatters {
  // Formatação de data
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return 'Agora mesmo';
      } else if (difference.inHours == 1) {
        return 'Há 1 hora';
      } else {
        return 'Há ${difference.inHours} horas';
      }
    } else if (difference.inDays == 1) {
      return 'Ontem';
    } else if (difference.inDays < 7) {
      return 'Há ${difference.inDays} dias';
    } else {
      return formatDate(date);
    }
  }

  // Formatação de telefone
  static String formatPhone(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanPhone.length == 11) {
      return '(${cleanPhone.substring(0, 2)}) ${cleanPhone.substring(2, 7)}-${cleanPhone.substring(7)}';
    } else if (cleanPhone.length == 10) {
      return '(${cleanPhone.substring(0, 2)}) ${cleanPhone.substring(2, 6)}-${cleanPhone.substring(6)}';
    }
    
    return phone;
  }

  // Formatação de CPF
  static String formatCPF(String cpf) {
    final cleanCPF = cpf.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanCPF.length == 11) {
      return '${cleanCPF.substring(0, 3)}.${cleanCPF.substring(3, 6)}.${cleanCPF.substring(6, 9)}-${cleanCPF.substring(9)}';
    }
    
    return cpf;
  }

  // Formatação de peso
  static String formatWeight(double weight) {
    if (weight < 1) {
      return '${(weight * 1000).toStringAsFixed(0)}g';
    } else {
      return '${weight.toStringAsFixed(1)}kg';
    }
  }

  // Formatação de distância
  static String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)}m';
    } else {
      final km = distanceInMeters / 1000;
      return '${km.toStringAsFixed(1)}km';
    }
  }

  // Formatação de idade
  static String formatAge(int ageInMonths) {
    if (ageInMonths < 12) {
      if (ageInMonths == 1) {
        return '1 mês';
      } else {
        return '$ageInMonths meses';
      }
    } else {
      final years = ageInMonths ~/ 12;
      final months = ageInMonths % 12;
      
      if (years == 1 && months == 0) {
        return '1 ano';
      } else if (years == 1) {
        return '1 ano e $months meses';
      } else if (months == 0) {
        return '$years anos';
      } else {
        return '$years anos e $months meses';
      }
    }
  }

  // Formatação de moeda
  static String formatCurrency(double value) {
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );
    return formatter.format(value);
  }

  // Formatação de número
  static String formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }

  // Capitalização de texto
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // Capitalização de cada palavra
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }

  // Truncamento de texto
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // Formatação de nome
  static String formatName(String name) {
    return capitalizeWords(name.trim());
  }

  // Formatação de endereço
  static String formatAddress(String address) {
    return capitalizeWords(address.trim());
  }

  // Formatação de descrição
  static String formatDescription(String description) {
    return description.trim();
  }

  // Validação de email
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Validação de telefone
  static bool isValidPhone(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    return cleanPhone.length >= 10 && cleanPhone.length <= 11;
  }

  // Validação de CPF
  static bool isValidCPF(String cpf) {
    final cleanCPF = cpf.replaceAll(RegExp(r'[^\d]'), '');
    return cleanCPF.length == 11;
  }
} 