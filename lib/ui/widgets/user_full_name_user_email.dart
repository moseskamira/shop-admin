import 'package:flutter/material.dart';

class UserFullNameUserName extends StatelessWidget {
  final String fullName;
  final String userName;
  const UserFullNameUserName({
    super.key,
    required this.fullName,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: SizedBox(
            width: 150,
            child: Text(
              fullName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: SizedBox(
            width: 150,
            child: Text(
              userName,
              style: const TextStyle(
                color: Color(0xff6D6F7E),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
