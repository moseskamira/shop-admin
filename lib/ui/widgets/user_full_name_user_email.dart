import 'package:flutter/material.dart';
import 'package:shop_owner_app/ui/utils/common_functions.dart';

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
    return Flexible(
      flex: 1,
      fit: FlexFit.loose,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              fullName,
              style: CommonFunctions.appTextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                textColor: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              userName,
              style: CommonFunctions.appTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                textColor: const Color(0xff6D6F7E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
