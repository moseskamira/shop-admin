import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_owner_app/core/models/user_model.dart';
import 'package:shop_owner_app/core/view_models/auth_provider.dart';
import 'package:shop_owner_app/ui/routes/route_name.dart';
import 'package:shop_owner_app/ui/screens/sign_up.dart';
import 'package:shop_owner_app/ui/widgets/reusable_text_field.dart';

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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ReusableTextField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            valueKey: 'Email',
            validator: (value) =>
                value == null || !EmailValidator.validateEmail(value)
                    ? 'Please enter a valid email address'
                    : null,
            maxLines: 1,
            labelText: 'Email Address',
            hintText: 'Enter your email',
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            onEditingComplete: () =>
                FocusScope.of(context).requestFocus(_passwordNode),
            onSaved: (value) => _user.email = value!,
          ),
          PasswordTextField(
            focusNode: _passwordNode,
            label: 'Password',
            validator: (value) => value != null && value.length < 6
                ? 'Password must be at least 6 characters'
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
                  'Forgot password ?',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                )),
          ),
          SizedBox(height: mediaQuery.height * 0.02),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () =>
                  authProvider.loginState == AuthStates.loginLoading
                      ? null
                      : _submitForm(authProvider),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  authProvider.loginState == AuthStates.loginLoading
                      ? CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        )
                      : const Text('Log In'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                        const Text(
                          ' ShopApp',
                          style: TextStyle(fontSize: 22),
                        )
                      ],
                    ),
                    SizedBox(height: mediaQuery.height * 0.1),
                    Visibility(
                      visible: authProvider.loginState == AuthStates.wrongCreds,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'The email or password you entered did not match our records. Please double check and try again',
                          style: TextStyle(color: Colors.redAccent),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    _buildLoginForm(authProvider, mediaQuery),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account? ',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.popAndPushNamed(
                                context, RouteName.signUpScreen);
                          },
                          child: const Text('Sign up'),
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
