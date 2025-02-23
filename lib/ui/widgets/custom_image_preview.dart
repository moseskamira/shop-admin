import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomImagePreView extends StatelessWidget {
  final String? imagePath;

  const CustomImagePreView({super.key, required this.imagePath});

  bool get isNetworkImage =>
      imagePath != null &&
      (imagePath!.startsWith('http://') || imagePath!.startsWith('https://'));

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!, width: 1),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imagePath == null || imagePath!.isEmpty
            ? const Icon(Icons.image, size: 50, color: Colors.grey)
            : isNetworkImage
                ? CachedNetworkImage(
                    imageUrl: imagePath!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.broken_image,
                      color: Colors.red,
                      size: 50,
                    ),
                  )
                : Image.file(
                    File(imagePath!),
                    fit: BoxFit.cover,
                  ),
      ),
    );
  }
}
