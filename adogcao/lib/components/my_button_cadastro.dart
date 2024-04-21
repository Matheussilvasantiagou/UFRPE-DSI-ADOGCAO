import 'package:flutter/material.dart';

class MyButtonCadastro extends StatelessWidget {
  final Function()? onTap;

  const MyButtonCadastro({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(64, 142, 253, 1),
          borderRadius: BorderRadius.circular(40),
        ),
        child: const Center(
          child: Text(
            "Cadastre-se",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}