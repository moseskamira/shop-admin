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
      child: SizedBox(
        width: 100,
        height: 100,
        child: Column(
          children: [
            Container(
              height: imageSize,
              width: imageSize,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                color: Colors.deepPurple[50],
              ),
              child: Center(
                child: Image.asset(
                  category.image,
                  width: imageSize * 0.65,
                  height: imageSize * 0.65,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              category.title,
              style: const TextStyle(
                  
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
