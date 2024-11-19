import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_owner_app/core/view_models/auth_provider.dart';
import 'package:shop_owner_app/ui/widgets/log_in_suggestion.dart';

class Authenticate extends StatefulWidget {
  final Widget child;
  const Authenticate({super.key, required this.child});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    final isLoggedIn = Provider.of<AuthProvider>(context).isLoggedIn;
    //  // final isLoggedIn = true;
    if (isLoggedIn) return widget.child;
    return const Scaffold(body: LogInSuggestion());
  }
}
