import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_owner_app/core/view_models/auth_provider.dart';
import 'package:shop_owner_app/ui/routes/route_name.dart';
import 'package:shop_owner_app/ui/utils/ui_tools/my_alert_dialog.dart';
import 'package:shop_owner_app/ui/widgets/image_preview.dart';
import 'package:shop_owner_app/ui/widgets/reusable_text_field.dart';

import '../../core/models/user_model.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late FocusNode _fullNameNode;
  late FocusNode _passwordNode;
  late FocusNode _emailNode;
  late FocusNode _phoneNumberNode;
  late FocusNode _addressNode;
  String _pickedImagePath = '';
  final _formKey = GlobalKey<FormState>();
  late UserModel _userModel;
  late String _password;
  late bool _isEmailValid;
  late bool _isLoading;

  void initializeValues() {
    _userModel = UserModel();
    _isLoading = false;
    _isEmailValid = true;
    _fullNameNode = FocusNode();
    _passwordNode = FocusNode();
    _emailNode = FocusNode();
    _phoneNumberNode = FocusNode();
    _addressNode = FocusNode();
  }

  void disposeValues() {
    _passwordNode.dispose();
    _emailNode.dispose();
    _phoneNumberNode.dispose();
    _addressNode.dispose();
  }

  @override
  void initState() {
    super.initState();
    initializeValues();
  }

  @override
  void dispose() {
    disposeValues();
    super.dispose();
  }

  void _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      setState(() => _isLoading = true);

      await authProvider
          .signUp(
        email: _userModel.email.toLowerCase().trim(),
        password: _password.trim(),
        userModel: _userModel,
      )
          .then((_) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteName.bottomBarScreen,
          (Route<dynamic> route) => false,
        );
      }).catchError((error) {
        if (error.toString().toLowerCase().contains('email')) {
          _isEmailValid = false;
          _formKey.currentState!.validate();
        } else if (error.toString().toLowerCase().contains('network')) {
          MyAlertDialog.connectionError(context);
        } else {
          MyAlertDialog.error(context, error.message.toString());
        }
      }).whenComplete(() {
        setState(() => _isLoading = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.06, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.07),

                // Upload Profile Picture
                Center(
                  child: Stack(
                    children: [
                      ImagePreview(imagePath: _pickedImagePath),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: SizedBox(
                          height: 26,
                          width: 26,
                          child: RawMaterialButton(
                            elevation: 5,
                            fillColor: Theme.of(context).primaryColor,
                            shape: const CircleBorder(),
                            onPressed: () async {
                              MyAlertDialog.imagePickerForAuth(context)
                                  .then(
                                    (pickedImagePath) => setState(
                                      () => _pickedImagePath = pickedImagePath,
                                    ),
                                  )
                                  .then(
                                    (_) =>
                                        _userModel.imageUrl = _pickedImagePath,
                                  );
                            },
                            child: const Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 65,
                  padding: const EdgeInsets.only(top: 14),
                  child: !_isEmailValid
                      ? const Text(
                          'This email already exists. You can reset your passowd from login page..',
                          style: TextStyle(color: Colors.redAccent),
                        )
                      : null,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Full Name TextFormField
                      ReusableTextField(
                        valueKey: 'Full Name',
                        focusNode: _fullNameNode,
                        labelText: 'Full Name',
                        hintText: 'Enter your full name',
                        textCapitalization: TextCapitalization.words,
                        validator: (value) => value!.isEmpty
                            ? 'Please enter your full name'
                            : null,
                        maxLines: 1,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        onEditingComplete: () =>
                            FocusScope.of(context).requestFocus(_emailNode),
                        onSaved: (value) => _userModel.fullName = value!,
                      ),

                      // Email TextFormField
                      ReusableTextField(
                        focusNode: _emailNode,
                        valueKey: 'Email',
                        validator: (value) => value == null ||
                                !EmailValidator.validateEmail(value)
                            ? 'Please enter a valid email address'
                            : null,
                        maxLines: 1,
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        onEditingComplete: () =>
                            FocusScope.of(context).requestFocus(_passwordNode),
                        onSaved: (value) => _userModel.email = value!,
                      ),

                      // Phone Number TextFormField
                      ReusableTextField(
                        valueKey: 'Phone Number',
                        focusNode: _phoneNumberNode,
                        labelText: 'Phone Number',
                        hintText: 'Enter your phone number',
                        validator: (value) => value!.isEmpty
                            ? 'Please enter a valid phone number'
                            : null,
                        keyboardType: TextInputType.phone,
                        onEditingComplete: () =>
                            FocusScope.of(context).requestFocus(_addressNode),
                        onSaved: (value) => _userModel.phoneNumber = value!,
                      ),

                      // Address
                      ReusableTextField(
                        valueKey: 'Address',
                        focusNode: _addressNode,
                        labelText: 'Address',
                        hintText: 'Enter your full address',
                        validator: (value) =>
                            value!.isEmpty ? 'Please Enter full address' : null,
                        onEditingComplete: () =>
                            FocusScope.of(context).requestFocus(_passwordNode),
                        onSaved: (value) => _userModel.address = value!,
                      ),

                      // Password TextFormField
                      PasswordTextField(
                        focusNode: _passwordNode,
                        label: 'Password',
                        validator: (value) => value != null && value.length < 6
                            ? 'Password must be at least 6 characters'
                            : null,
                        onSaved: (value) => _password = value!,
                        onEditingComplete: _submitForm,
                      ),

                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),

                      // Sign Up button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? () {}
                              : () {
                                  _submitForm();
                                  FocusScope.of(context).unfocus();
                                },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _isLoading
                                  ? CircularProgressIndicator(
                                      color: Theme.of(context).primaryColor,
                                    )
                                  : const Text('Sign Up'),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Already have an account?',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.popAndPushNamed(
                                  context, RouteName.logInScreen);
                            },
                            child: const Text('LogIn'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmailValidator {
  static bool validateEmail(String email) {
    final emailReg = RegExp(
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|.(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return emailReg.hasMatch(email);
  }
}
