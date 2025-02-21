import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_owner_app/ui/screens/bottom_bar_screen.dart';
import 'package:shop_owner_app/ui/screens/log_in_screen.dart';

import '../../core/view_models/auth_provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return context.watch<AuthProvider>().isLoggedIn
        ? const BottomBarScreen()
        : const LogInScreen();
  }
}
