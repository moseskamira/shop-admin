import 'package:flutter/material.dart';

import '../utils/common_functions.dart';

class AddCategoryCard extends StatelessWidget {
  final String name;

  const AddCategoryCard({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey),
            color: Colors.deepPurple[50],
          ),
          child: Center(
            child: Icon(
              Icons.add,
              size: 35,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: CommonFunctions.appTextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            textColor: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
