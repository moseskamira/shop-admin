import 'package:flutter/material.dart';
import 'package:shop_owner_app/ui/constants/app_consntants.dart';
import 'package:shop_owner_app/ui/routes/route_name.dart';
import 'package:shop_owner_app/ui/screens/feeds.dart';
import 'package:shop_owner_app/ui/screens/home.dart';
import 'package:shop_owner_app/ui/screens/my_users_screen.dart';
import 'package:shop_owner_app/ui/screens/orders_list.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  late List<Map> _pages;
  late int _selectedIndex;

  void _selectedPages(int index) {
    if (index == 2) {
      return;
    }
    setState(() => _selectedIndex = index);
  }

  @override
  void initState() {
    super.initState();
    _pages = [
      {'page': const HomeScreen(), 'title': 'Home'},
      {'page': const FeedsScreen(), 'title': 'Feeds'},
      {},
      {'page': const MyUsersScreen(), 'title': 'MyUsers'},
      {'page': const OrdersList(), 'title': 'Orders'},
    ];
    _selectedIndex = 0;
  }

// PopScope<void>(
//       canPop: false,
//       onPopInvokedWithResult: (bool didPop, void result) async {
//         if (didPop) {
//           return;
//         }
//         if (_selectedIndex != 0) {
//           setState(() {
//             _selectedIndex = 0;
//           });
//           return;
//         }
//         if (context.mounted) {
//         Navigator.of(context).pop();
//          // Navigator.pop(context);
//          //auth navigation.....
//         }
//       },

  @override
  Widget build(BuildContext context) {
    ///TODO fixing the deprications

    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0; // Navigate to the first index (Home)
          });
          return false; // Prevent app from closing
        }
        return true; // Allow app to close if already on the first index
      },
      child: Scaffold(
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
            iconSize: 23,
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
                label: '',
                tooltip: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(mUserIcon),
                label: 'MyUsers',
                tooltip: 'MyUsers',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.pending_actions),
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
            Navigator.of(context).pushNamed(RouteName.uploadProductScreen);
          },
          elevation: 2,
          splashColor: Theme.of(context).primaryColor.withAlpha(2),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
