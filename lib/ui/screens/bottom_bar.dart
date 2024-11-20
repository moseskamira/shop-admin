import 'package:flutter/material.dart';
import 'package:shop_owner_app/ui/constants/app_consntants.dart';
import 'package:shop_owner_app/ui/screens/feeds.dart';
import 'package:shop_owner_app/ui/screens/home.dart';
import 'package:shop_owner_app/ui/screens/my_users_screen.dart';
import 'package:shop_owner_app/ui/screens/orders_list.dart';
import 'package:shop_owner_app/ui/screens/update_product.dart';
import 'package:shop_owner_app/ui/screens/upload_product.dart';
import 'package:shop_owner_app/ui/screens/user_info.dart';
import 'package:shop_owner_app/ui/widgets/authenticate.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  late List<Map> _pages;
  late int _selectedIndex;
  void _selectedPages(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  void initState() {
    super.initState();
    _pages = [
      {'page': const HomeScreen(), 'title': 'Home'},
      {'page': const FeedsScreen(), 'title': 'Feeds'},

      {'page': const UploadProductScreen(), 'title': 'Search'},
      {'page':   MyUsersScreen(), 'title': 'MyUsers'},
      {'page': const PendingOrdersList(), 'title': 'Orders'},

      /// {'page': Authenticate(child: UserInfoScreen()), 'title': 'User'},
    ];
    _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _pages[_selectedIndex]['page'],
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        notchMargin: 6,
        height: 90,
        clipBehavior: Clip.antiAlias,
        shape: const CircularNotchedRectangle(),
        child: BottomNavigationBar(
          unselectedItemColor: Theme.of(context).unselectedWidgetColor,
          selectedItemColor: Theme.of(context).primaryColor,
          onTap: _selectedPages,
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          backgroundColor: Theme.of(context).cardColor,
          items: const [
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
              icon: Icon(null),
              label: 'Search',
              tooltip: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(mUserIcon),
              label: 'MyUsers',
              tooltip: 'MyUsers',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_shopping_cart),
              label: 'Orders',
              tooltip: 'Orders',
            ),
          ],
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _selectedPages(2);
        },
        elevation: 2,
        splashColor: Theme.of(context).primaryColor.withAlpha(2),
        child: const Icon(Icons.add),
      ),
    );
  }
}
