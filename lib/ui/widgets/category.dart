import 'package:flutter/material.dart';
import 'package:shop_owner_app/core/models/category_model.dart';
import 'package:shop_owner_app/ui/routes/route_name.dart';

class Category extends StatelessWidget {
  final CategoryModel category;

  const Category({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    double imageSize = 70;
    return InkWell(
      onTap: () => Navigator.pushNamed(context, RouteName.categoryScreen,
          arguments: {'cat': category.title}),
      child: Column(
        children: [
          SizedBox(
            width: imageSize * 0.65,
            height: imageSize * 0.65,
            child: Center(
              child: Image.asset(
                category.image,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            category.title,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
