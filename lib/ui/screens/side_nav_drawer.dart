import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shop_owner_app/core/models/user_model.dart';
import 'package:shop_owner_app/core/view_models/profile_provider.dart';
import 'package:shop_owner_app/core/view_models/theme_change_provider.dart';
import 'package:shop_owner_app/ui/utils/ui_tools/my_alert_dialog.dart';
import 'package:shop_owner_app/ui/widgets/profile_picture.dart';
import 'package:shop_owner_app/ui/widgets/user_full_name_user_email.dart';

import '../routes/route_name.dart';

class SideNavDrawer extends StatelessWidget {
  const SideNavDrawer({super.key});

  Widget _buildIconProfileRow(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xff24263f),
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Center(
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 15,
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              appLocalizations.profile,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileDetailsRow(UserModel userData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 10),
        ProfilePicture(imageUrl: userData.imageUrl),
        const SizedBox(width: 5),
        UserFullNameUserName(
          fullName: userData.fullName,
          userName: userData.email,
        ),
      ],
    );
  }

  Widget _buildEditProfileRow(BuildContext context, UserModel userData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
              RouteName.updateUserInfo,
              arguments: userData,
            ),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.edit_note_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeChangeProvider>(context);
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return SafeArea(
      child: Drawer(
        child: ListView(
          children: [
            Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black12,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Consumer<ProfileProvider>(
                      builder: (context, userDataProvider, child) {
                    return StreamBuilder<UserModel>(
                      stream: userDataProvider.fetchProfile!,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              appLocalizations.errorLoadingUserData,
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return Center(
                            child: Text(
                              appLocalizations.noUserdataAvailable,
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        final userData = snapshot.data!;
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: _buildIconProfileRow(context),
                            ),
                            const SizedBox(height: 10),
                            _buildProfileDetailsRow(userData),
                            _buildEditProfileRow(
                              context,
                              userData,
                            ),
                          ],
                        );
                      },
                    );
                  }),
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
            Card(
              child: SwitchListTile(
                title: const Text('Dark Theme'),
                secondary: Icon(
                  Icons.dark_mode,
                  color: Theme.of(context).iconTheme.color,
                ),
                value: themeChange.isDarkTheme,
                onChanged: (bool value) {
                  themeChange.isDarkTheme = value;
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: Text(appLocalizations.signOut),
              onTap: (() {
                MyAlertDialog.signOut(context);
              }),
            ),
          ],
        ),
      ),
    );
  }
}
