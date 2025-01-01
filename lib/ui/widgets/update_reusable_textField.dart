import 'package:flutter/material.dart';
import 'package:shop_owner_app/ui/utils/ui_tools/my_border.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final InputBorder? enabledBorder;
  final int maxLines;
  final FocusNode? nextFocusNode; // Added this to handle focus transition
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final FocusNode focusNode;
  

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.focusNode,
    this.maxLines = 1,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.next,
    this.enabledBorder,
    this.nextFocusNode,
    this.validator,
    this.keyboardType,
  });

  @override
Widget build(BuildContext context) {
  return TextFormField(
    controller: controller,
    textCapitalization: textCapitalization,
    textInputAction: maxLines > 1 ? TextInputAction.newline : textInputAction,
    keyboardType: keyboardType ?? (maxLines > 1 ? TextInputType.multiline : TextInputType.text),
    focusNode: focusNode,
    maxLines: maxLines,
    //  keyboardType: TextInputType.multiline,
    decoration: InputDecoration(
      hintText: hintText,
      enabledBorder: enabledBorder ?? MyBorder.underlineInputBorder(context),
    ),
    onEditingComplete: () {
      if (maxLines == 1 && nextFocusNode != null) {
        FocusScope.of(context).requestFocus(nextFocusNode);
      } else {
        focusNode.unfocus();
      }
    },
    validator: validator,
  );
}
}