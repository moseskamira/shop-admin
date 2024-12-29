import 'package:shop_owner_app/core/models/user_model.dart';
import 'package:shop_owner_app/core/view_models/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_owner_app/core/view_models/theme_change_provider.dart';
import 'package:shop_owner_app/ui/utils/ui_tools/my_alert_dialog.dart';
import 'package:shop_owner_app/ui/widgets/profile_picture.dart';
import 'package:shop_owner_app/ui/widgets/user_full_name_user_email.dart';
import '../routes/route_name.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeChangeProvider>(context);

    return SafeArea(
      child: Drawer(
        child: ListView(
          // Remove padding
          padding: EdgeInsets.zero,
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .30,
                  decoration: const BoxDecoration(
                    color: Color(0Xff0c0e2a),
                  ),
                  child: StreamBuilder<UserModel>(
                    stream:
                        Provider.of<UserDataProvider>(context, listen: false)
                            .fetchUserData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            'Error loading user data',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return const Center(
                          child: Text(
                            'No user data available',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      final userData = snapshot.data!;
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        .0430,
                                    width: MediaQuery.of(context).size.width *
                                        .087,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xff24263f),
                                        width: .5,
                                      ),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                const Text(
                                  'Profile',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(width: 20),
                              ProfilePicture(imageUrl: userData.imageUrl),
                              const SizedBox(width: 15),
                              UserFullNameUserName(
                                fullName: userData.fullName,
                                userName: userData.email,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () => Navigator.of(context).pushNamed(
                                    RouteName.updateUserInfo,
                                    arguments: userData,
                                  ),
                                  child:   Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color:Theme.of(context).primaryColor,
                                     borderRadius: BorderRadius.circular(10), 
                                    ),
                                    child: const  Icon(Icons.edit_note_outlined, color: Colors.white,),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            ListTile(
              leading: const Icon(Icons.pending_actions),
              title: const Text('Pending Order'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.account_circle_outlined),
              title: const Text('My Profile'),
              onTap: (() {}),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.policy_sharp),
              title: const Text('Privacy Policies'),
              onTap: (() async {}),
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Terms Of Use'),
              onTap: (() async {}),
            ),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Dark Theme'),
                    secondary: _customIcon(Icons.dark_mode, context),
                    value: themeChange.isDarkTheme,
                    onChanged: (bool value) {
                      themeChange.isDarkTheme = value;
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Sign Out'),
              onTap: (() {
                MyAlertDialog.signOut(context);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customIcon(IconData icon, BuildContext context) {
    return Icon(
      icon,
      color: Theme.of(context).iconTheme.color,
    );
  }
}
