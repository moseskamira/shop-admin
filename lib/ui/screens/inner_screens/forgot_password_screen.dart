import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shop_owner_app/core/enums/app_enums.dart';
import 'package:shop_owner_app/core/view_models/auth_provider.dart';
import 'package:shop_owner_app/ui/constants/app_consntants.dart';
import 'package:shop_owner_app/ui/utils/common_functions.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String? _noticeText;
  String _email = '';
  final _formKey = GlobalKey<FormState>();

  Future<void> _submitForm(
      AuthProvider authProvider, AppLocalizations appLocal) async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    Future.microtask(() {
      setState(() => _noticeText = null);
    });
    await authProvider.resetPassword(email: _email);
    setState(() {
      if (authProvider.authState == AuthStates.resetPasswordSuccess) {
        _noticeText = appLocal.resetPasswordLinkText;
      } else if (authProvider.authState == AuthStates.resetPasswordError) {
        _noticeText = authProvider.resetPasswordErrorMessage;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.resetYourPassword),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appLocalizations.enterYourEmailAddressToResetPassword,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),

                  // Email Input
                  TextFormField(
                    key: ValueKey(appLocalizations.email),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@')) {
                        return appLocalizations.pleaseEnterValidEmailAddress;
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    decoration: CommonFunctions.customInputDecoration(
                      appLocalizations.email,
                      appLocalizations.enterYourEmailAddress,
                      context,
                      const Icon(mEmailIcon),
                    ),
                    onSaved: (value) => _email = value!,
                  ),
                  const SizedBox(height: 20),

                  // Reset Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _submitForm(
                        authProvider,
                        appLocalizations,
                      ),
                      child: authProvider.authState ==
                              AuthStates.resetPasswordLoading
                          ? const CircularProgressIndicator(color: Colors.blue)
                          : Text(appLocalizations.changePassword),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_noticeText != null)
                    Center(
                      child: Text(
                        _noticeText!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _noticeText!.contains('error')
                              ? Colors.red
                              : Colors.green,
                          fontSize: 14,
                        ),
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
