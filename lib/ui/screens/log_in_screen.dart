import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shop_owner_app/core/models/user_model.dart';
import 'package:shop_owner_app/core/view_models/auth_provider.dart';
import 'package:shop_owner_app/ui/routes/route_name.dart';
import 'package:shop_owner_app/ui/utils/common_functions.dart';
import 'package:shop_owner_app/ui/widgets/reusable_text_field.dart';

import '../../core/enums/app_enums.dart';
import '../widgets/password_text_field.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  late FocusNode _passwordNode;
  late FocusNode _emailFocusNode;
  late TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();

  final UserModel _user = UserModel();
  late String _password;

  @override
  void initState() {
    super.initState();
    _passwordNode = FocusNode();
    _emailFocusNode = FocusNode();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordNode.dispose();
    _emailFocusNode.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submitForm(AuthProvider authProvider) async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    _formKey.currentState!.save();
    await authProvider.signIn(
      email: _user.email,
      password: _password,
      ctx: context,
    );
  }

  Widget _buildLoginForm(AuthProvider authProvider, Size mediaQuery) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ReusableTextField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            valueKey: appLocalizations.email,
            validator: (value) =>
                value == null || !CommonFunctions.validateEmail(value)
                    ? appLocalizations.pleaseEnterValidEmail
                    : null,
            maxLines: 1,
            labelText: appLocalizations.emailAddress,
            hintText: appLocalizations.enterYourEmailAddress,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            onEditingComplete: () =>
                FocusScope.of(context).requestFocus(_passwordNode),
            onSaved: (value) => _user.email = value!,
          ),
          PasswordTextField(
            focusNode: _passwordNode,
            label: appLocalizations.password,
            validator: (value) => value != null && value.length < 6
                ? appLocalizations.passwordLimit
                : null,
            onSaved: (value) => _password = value!,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  RouteName.forgotPasswordScreen,
                );
              },
              child: Text(
                appLocalizations.forgotPassword,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          SizedBox(height: mediaQuery.height * 0.02),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => authProvider.authState == AuthStates.loginLoading
                  ? null
                  : _submitForm(authProvider),
              child: authProvider.authState == AuthStates.loginLoading
                  ? CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                      strokeWidth: 2,
                    )
                  : Text(appLocalizations.login),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final mediaQuery = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return Column(
                  children: [
                    SizedBox(height: mediaQuery.height * 0.1),
                    Row(
                      children: [
                        Icon(
                          Icons.shopping_bag_rounded,
                          size: 32,
                          color: Theme.of(context).primaryColor,
                        ),
                        Text(
                          appLocalizations.shopApp,
                          style: CommonFunctions.appTextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            textColor: Colors.blue,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: mediaQuery.height * 0.1),
                    _buildLoginForm(authProvider, mediaQuery),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          appLocalizations.doNotHaveAccount,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.popAndPushNamed(
                                context, RouteName.signUpScreen);
                          },
                          child: Text(appLocalizations.signUp),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
