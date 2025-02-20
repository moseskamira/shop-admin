import 'package:flutter/material.dart';

import '../utils/common_functions.dart';

class PasswordTextField extends StatefulWidget {
  final FocusNode? focusNode;
  final String label;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final VoidCallback? onEditingComplete;

  const PasswordTextField({
    super.key,
    this.focusNode,
    required this.label,
    this.validator,
    this.onSaved,
    this.onEditingComplete,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _passwordIsVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        focusNode: widget.focusNode,
        validator: widget.validator,
        onSaved: widget.onSaved,
        onEditingComplete: widget.onEditingComplete,
        obscureText: !_passwordIsVisible,
        maxLines: 1,
        keyboardType: TextInputType.visiblePassword,
        decoration: CommonFunctions.customInputDecoration(
          widget.label,
          widget.label,
          context,
          SizedBox(
            height: 32,
            width: 28,
            child: IconButton(
              onPressed: () {
                setState(() {
                  _passwordIsVisible = !_passwordIsVisible;
                });
              },
              splashRadius: 18,
              iconSize: 18,
              icon: Icon(
                _passwordIsVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
            ),
          ),
        ),
        style: CommonFunctions.appTextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          textColor: Colors.black,
        ),
      ),
    );
  }
}
