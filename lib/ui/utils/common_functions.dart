import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      hintStyle: CommonFunctions.appTextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        textColor: Colors.grey,
      ),
      labelStyle: CommonFunctions.appTextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        textColor: Colors.grey,
      ),
      suffix: suffix,
      floatingLabelAlignment: FloatingLabelAlignment.center,
    );
  }

  static appTextStyle(
      {required double fontSize,
      required FontWeight fontWeight,
      required Color textColor}) {
    return GoogleFonts.poppins(
        fontSize: fontSize, fontWeight: fontWeight, color: textColor);
  }

  static bool validateEmail(String email) {
    final emailReg = RegExp(
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|.(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return emailReg.hasMatch(email);
  }
}
