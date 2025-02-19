import 'package:flutter/material.dart';

class CommonFunctions {
  static customInputDecoration(
    String labelText,
    String hintText,
    BuildContext ctx,
    Widget? suffix,
  ) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      contentPadding: const EdgeInsets.all(8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          20,
        ), // Rounded corners
        borderSide: const BorderSide(
          color: Colors.grey,
        ), // Default border
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          20,
        ), // Rounded corners
        borderSide: const BorderSide(
          color: Colors.grey,
        ), // Enabled border
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          20,
        ), // Rounded corners
        borderSide: const BorderSide(
          color: Colors.purple,
          width: 1,
        ), // Focus border
      ),
      filled: true,
      fillColor: Theme.of(ctx).cardColor,
      suffix: suffix,
      floatingLabelAlignment: FloatingLabelAlignment.center,
    );
  }
}
