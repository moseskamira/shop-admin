import 'package:flutter/material.dart';
import 'package:shop_owner_app/ui/utils/common_functions.dart';

class ReusableTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode focusNode;
  final String valueKey;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final int maxLines;
  final String labelText;
  final String hintText;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final VoidCallback? onEditingComplete;
  final void Function(String?)? onSaved;

  const ReusableTextField({
    super.key,
    this.controller,
    required this.focusNode,
    required this.valueKey,
    this.textCapitalization = TextCapitalization.words,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.onSaved,
    this.maxLines = 1,
    required this.labelText,
    required this.hintText,
    this.onEditingComplete,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        key: ValueKey(valueKey),
        textCapitalization: textCapitalization,
        validator: validator,
        maxLines: maxLines,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        onSaved: onSaved,
        decoration: CommonFunctions.customInputDecoration(
            labelText, hintText, context, null),
        onEditingComplete: onEditingComplete,
      ),
    );
  }
}
