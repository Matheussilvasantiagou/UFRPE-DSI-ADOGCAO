import 'package:flutter/material.dart';

class PetAvatar extends StatelessWidget {
  final String name;
  final String imageUrl;
  final bool isAssetImage;

  PetAvatar({
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
          backgroundImage: isAssetImage
              ? AssetImage(imageUrl)
              : NetworkImage(imageUrl) as ImageProvider,
        ),
        SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
