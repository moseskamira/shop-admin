import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_owner_app/core/view_models/bottom_nav_index_provider.dart';
import 'package:shop_owner_app/ui/routes/route_name.dart';
import 'package:shop_owner_app/ui/screens/feeds.dart';
import 'package:shop_owner_app/ui/screens/home_screen.dart';
import 'package:shop_owner_app/ui/screens/my_users_screen.dart';
import 'package:shop_owner_app/ui/screens/orders_list.dart';

import '../constants/app_consntants.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  final List<Map<String, dynamic>> _pages = [
    {'page': const HomeScreen(), 'title': 'Home'},
    {'page': const FeedsScreen(), 'title': 'Feeds'},
    {},
    {'page': const MyUsersScreen(), 'title': 'My Users'},
    {'page': const OrdersList(), 'title': 'Orders'},
  ];

  List<BottomNavigationBarItem> _buildBottomNavItems() {
    return const [
      BottomNavigationBarItem(
        icon: Icon(mHomeIcon),
        label: 'Home',
        tooltip: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(mFeedsIcon),
        label: 'Feeds',
        tooltip: 'Feeds',
      ),
      BottomNavigationBarItem(
        icon: SizedBox.shrink(),
        label: '',
        tooltip: '',
      ),
      BottomNavigationBarItem(
        icon: Icon(mUserIcon),
        label: 'My Users',
        tooltip: 'My Users',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.pending_actions),
        label: 'Orders',
        tooltip: 'Orders',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavIndexProvider = context.watch<BottomNavIndexProvider>();
    return PopScope(
      canPop: bottomNavIndexProvider.selectedIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          bottomNavIndexProvider.reset(0);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: _pages[bottomNavIndexProvider.selectedIndex]['page'],
        bottomNavigationBar: BottomAppBar(
          elevation: 10,
          notchMargin: 6,
          height: 90,
          clipBehavior: Clip.antiAlias,
          shape: const CircularNotchedRectangle(),
          child: BottomNavigationBar(
            currentIndex: bottomNavIndexProvider.selectedIndex,
            onTap: (index) {
              const int emptyIndex = 2;
              if (index != emptyIndex &&
                  index != bottomNavIndexProvider.selectedIndex) {
                bottomNavIndexProvider.reset(index);
              }
            },
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Theme.of(context).unselectedWidgetColor,
            selectedItemColor: Theme.of(context).primaryColor,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            iconSize: 23,
            backgroundColor: Theme.of(context).cardColor,
            items: _buildBottomNavItems(),
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
              Navigator.of(context).pushNamed(RouteName.uploadProductScreen),
          elevation: 2,
          splashColor: Theme.of(context).primaryColor.withAlpha(50),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
