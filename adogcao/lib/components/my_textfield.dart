import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final String? errorText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color.fromRGBO(116, 115, 120, 1)),
              borderRadius: BorderRadius.circular(20.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(20.0),
            ),
            fillColor: const Color.fromRGBO(44, 44, 46, 1),
            filled: true,
            hintText: hintText,
            errorText: errorText, 
            errorStyle: const TextStyle(color: Colors.white),
            hintStyle: TextStyle(color: Colors.grey[500])),
            style: const TextStyle(color: Colors.white),
                 
      )
    );
  }
}