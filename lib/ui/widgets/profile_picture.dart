import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePicture extends StatelessWidget {
  final String? imageUrl;
  const ProfilePicture({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.7),
              spreadRadius: -0.01,
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: CircleAvatar(
          backgroundColor: Colors.red,
          radius: 53,
          child: CircleAvatar(
            backgroundColor: Colors.red,
            radius: 50,
            child: ClipOval(
              child: imageUrl == null || imageUrl!.isEmpty
                  ? const Icon(
                      Icons.person_3_outlined,
                      size: 90,
                      color: Colors.white,
                    )
                  : CachedNetworkImage(
                      imageUrl: imageUrl!,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          color: Colors.grey,
                          width: 100,
                          height: 100,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
