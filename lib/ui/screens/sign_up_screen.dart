import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shop_owner_app/core/view_models/auth_provider.dart';
import 'package:shop_owner_app/ui/routes/route_name.dart';
import 'package:shop_owner_app/ui/utils/common_functions.dart';
import 'package:shop_owner_app/ui/utils/ui_tools/my_alert_dialog.dart';
import 'package:shop_owner_app/ui/widgets/image_preview.dart';
import 'package:shop_owner_app/ui/widgets/reusable_text_field.dart';

import '../../core/enums/app_enums.dart';
import '../../core/models/user_model.dart';
import '../widgets/password_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  late UserModel _userModel;
  late String _password;
  String _pickedImagePath = '';

  late final FocusNode _fullNameNode;
  late final FocusNode _passwordNode;
  late final FocusNode _emailNode;
  late final FocusNode _phoneNumberNode;
  late final FocusNode _addressNode;

  @override
  void initState() {
    super.initState();
    _userModel = UserModel();

    _fullNameNode = FocusNode();
    _passwordNode = FocusNode();
    _emailNode = FocusNode();
    _phoneNumberNode = FocusNode();
    _addressNode = FocusNode();
  }

  @override
  void dispose() {
    _fullNameNode.dispose();
    _passwordNode.dispose();
    _emailNode.dispose();
    _phoneNumberNode.dispose();
    _addressNode.dispose();
    super.dispose();
  }

  Future<void> _submitForm(AuthProvider authProvider, BuildContext ctx) async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(ctx).unfocus();
    _formKey.currentState!.save();
    await authProvider.signUp(
      email: _userModel.email.trim().toLowerCase(),
      password: _password.trim(),
      userModel: _userModel,
      ctx: ctx,
    );
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            20,
            MediaQuery.of(context).size.height * 0.06,
            20,
            16,
          ),
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.07),
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
                                final pickedImagePath =
                                    await MyAlertDialog.imagePickerForAuth(
                                        context);
                                if (pickedImagePath != null &&
                                    pickedImagePath.isNotEmpty) {
                                  setState(() {
                                    _pickedImagePath = pickedImagePath;
                                    _userModel.imageUrl = pickedImagePath;
                                  });
                                }
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
                  if (authProvider.authState == AuthStates.signupEmailExists)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        appLocalizations.emailExistsText,
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        ReusableTextField(
                          valueKey: appLocalizations.fullName,
                          focusNode: _fullNameNode,
                          labelText: appLocalizations.fullName,
                          hintText: appLocalizations.enterYourFullName,
                          textCapitalization: TextCapitalization.words,
                          validator: (value) => value!.isEmpty
                              ? appLocalizations.pleaseEnterYourFullName
                              : null,
                          maxLines: 1,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          onEditingComplete: () => _emailNode.requestFocus(),
                          onSaved: (value) => _userModel.fullName = value!,
                        ),
                        ReusableTextField(
                          focusNode: _emailNode,
                          valueKey: appLocalizations.email,
                          labelText: appLocalizations.email,
                          hintText: appLocalizations.enterYourEmailAddress,
                          validator: (value) => value == null ||
                                  !CommonFunctions.validateEmail(value)
                              ? appLocalizations.pleaseEnterValidEmail
                              : null,
                          maxLines: 1,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          onEditingComplete: () => _passwordNode.requestFocus(),
                          onSaved: (value) => _userModel.email = value!,
                        ),
                        ReusableTextField(
                          valueKey: appLocalizations.phoneNumber,
                          focusNode: _phoneNumberNode,
                          labelText: appLocalizations.phoneNumber,
                          hintText: appLocalizations.enterYourPhoneNumber,
                          validator: (value) => value!.isEmpty
                              ? appLocalizations.pleaseEnterValidPhoneNumber
                              : null,
                          keyboardType: TextInputType.phone,
                          onEditingComplete: () => _addressNode.requestFocus(),
                          onSaved: (value) => _userModel.phoneNumber = value!,
                        ),
                        ReusableTextField(
                          valueKey: appLocalizations.address,
                          focusNode: _addressNode,
                          labelText: appLocalizations.address,
                          hintText: appLocalizations.enterFullAddress,
                          validator: (value) => value!.isEmpty
                              ? appLocalizations.pleaseEnterFullAddress
                              : null,
                          onEditingComplete: () => _passwordNode.requestFocus(),
                          onSaved: (value) => _userModel.address = value!,
                        ),
                        PasswordTextField(
                          focusNode: _passwordNode,
                          label: appLocalizations.password,
                          validator: (value) =>
                              (value != null && value.length < 6)
                                  ? appLocalizations.passwordLimit
                                  : null,
                          onSaved: (value) => _password = value!,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: authProvider.authState ==
                                    AuthStates.signupLoading
                                ? null
                                : () => _submitForm(authProvider, context),
                            child: authProvider.authState ==
                                    AuthStates.signupLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.blue,
                                    strokeWidth: 2,
                                  )
                                : Text(appLocalizations.signUp),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              appLocalizations.alreadyHaveAccount,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            TextButton(
                              onPressed: () => Navigator.popAndPushNamed(
                                  context, RouteName.logInScreen),
                              child: Text(appLocalizations.login),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
