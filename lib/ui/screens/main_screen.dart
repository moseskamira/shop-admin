import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 import 'package:shop_owner_app/ui/screens/bottom_bar.dart';
import 'package:shop_owner_app/ui/screens/log_in.dart';
import '../../core/view_models/auth_provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = Provider.of<AuthProvider>(context).isLoggedIn;
    if (isLoggedIn) return const BottomBarScreen();
    return const LogInScreen();
  }
}