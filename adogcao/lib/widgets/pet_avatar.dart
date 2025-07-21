import 'package:flutter/material.dart';

class PetAvatar extends StatelessWidget {
  final String name;
  final String imageUrl;
  final bool isAssetImage;

  const PetAvatar({super.key, 
    required this.name,
    required this.imageUrl,
    this.isAssetImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: imageUrl.startsWith('http')
              ? NetworkImage(imageUrl)
              : AssetImage(imageUrl) as ImageProvider,
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
