import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_owner_app/ui/constants/assets_path.dart';
import 'package:shop_owner_app/ui/routes/route_name.dart';
import 'package:shop_owner_app/core/models/user_model.dart';
import 'package:shop_owner_app/core/view_models/auth_provider.dart';
import 'package:shop_owner_app/ui/utils/ui_tools/my_alert_dialog.dart';
import 'package:shop_owner_app/ui/utils/ui_tools/my_border.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  late FocusNode _passwordNode;
  final _formKey = GlobalKey<FormState>();
  bool _passwordIsVisibile = false;
  final UserModel _user = UserModel();
  late String _password;
  bool _wrongEmailOrPassword = false;
  bool _isLoading = false;

  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    _passwordNode = FocusNode();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    print('inside init');
  }

  @override
  void dispose() {
    super.dispose();
    _passwordNode.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void _submitForm() async {
    _user.email = emailController.text.toString();
    _password = emailController.text.toString();
    final isValid = _formKey.currentState!.validate();

    FocusScope.of(context).unfocus();
    setState(() => _wrongEmailOrPassword = false);
    if (isValid) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      _formKey.currentState!.save();
      setState(() => _isLoading = true);

      authProvider.signIn(email: _user.email, password: _password).then((_) {
        if (Navigator.canPop(context)) Navigator.pop(context);
      }).catchError((e) {
        print(e.toString());
        if (e.toString().contains('wrong-password') ||
            e.toString().contains('user-not-found')) {
          setState(() => _wrongEmailOrPassword = true);
        } else if (e.toString().toLowerCase().contains('network')) {
          MyAlertDialog.connectionError(context);
        } else {
          MyAlertDialog.error(context, e.message.toString());
        }
      }).whenComplete(() {
        setState(() => _isLoading = false);
      });
    }
  }

  void _googleSignIn() async {
    setState(() => _isLoading = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.googleSignIn().then((_) {
      if (Navigator.canPop(context)) Navigator.pop(context);
    }).whenComplete(() => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    print('inside build');
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                //  App Logo
                Row(
                  children: [
                    Icon(
                      Icons.shopping_bag_rounded,
                      size: 32,
                      color: Theme.of(context).primaryColor,
                    ),
                    const Text(
                      ' Merchant App',
                      style: TextStyle(fontSize: 22),
                    )
                  ],
                ),

                //Show Log In error message
                Container(
                  height: 65,
                  padding: const EdgeInsets.only(top: 14),
                  child: _wrongEmailOrPassword
                      ? const Text(
                          'The email or password you entered did not match our records. Please double check and try again',
                          style: TextStyle(color: Colors.redAccent),
                        )
                      : null,
                ),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Email TextFormField
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: TextFormField(
                          controller: emailController,
                          key: const ValueKey('Email'),
                          validator: (value) =>
                              value!.isEmpty || !value.contains('@')
                                  ? 'Please enter a valid email address'
                                  : null,
                          maxLines: 1,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            contentPadding: const EdgeInsets.all(12),
                            border: const OutlineInputBorder(),
                            enabledBorder: MyBorder.outlineInputBorder(context),
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                          ),
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_passwordNode),
                        ),
                      ),

                      // Password TextFormField
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        child: TextFormField(
                          key: const ValueKey('Password'),
                          validator: (value) => value!.isEmpty
                              ? 'Please enter a valid password'
                              : null,
                          maxLines: 1,
                          focusNode: _passwordNode,
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          onEditingComplete: _submitForm,
                          obscureText: !_passwordIsVisibile,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            labelText: 'Password',
                            border: const OutlineInputBorder(),
                            enabledBorder: MyBorder.outlineInputBorder(context),
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                            suffix: SizedBox(
                              height: 32,
                              width: 28,
                              child: IconButton(
                                onPressed: () => setState(() =>
                                    _passwordIsVisibile = !_passwordIsVisibile),
                                splashRadius: 18,
                                iconSize: 18,
                                icon: Icon(
                                  _passwordIsVisibile
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Forgot Password Button
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, RouteName.forgotPasswordScreen);
                            },
                            child: Text(
                              'Forgot password ?',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            )),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),

                      // Log in button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => _submitForm(),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text('Log In'),
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(child: Divider(thickness: 1)),
                      Text('  or   ',
                          style: Theme.of(context).textTheme.titleSmall),
                      const Expanded(child: Divider(thickness: 1)),
                    ],
                  ),
                ),

                // Buttom Log In with Google
                _loginWithButton(
                  onPressed: _googleSignIn,
                  appLogoUrl: ImagePath.googleLogo,
                  title: 'Log in with Google',
                ),
                const SizedBox(height: 16),
                _loginWithButton(
                  onPressed: () {},
                  appLogoUrl: ImagePath.facebookLogo,
                  title: 'Log in with Facebook',
                ),

                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RouteName.signUpScreen);
                        },
                        child: const Text('Sign up'))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginWithButton(
      {String title = '',
      String appLogoUrl = '',
      required Function() onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: Material(
        elevation: 0.6,
        borderRadius: BorderRadius.circular(4),
        color: Theme.of(context).cardColor,
        textStyle: Theme.of(context).textTheme.labelLarge,
        child: InkWell(
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                appLogoUrl,
                fit: BoxFit.contain,
                height: 16,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
