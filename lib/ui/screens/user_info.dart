import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_owner_app/core/models/user_model.dart';
import 'package:shop_owner_app/core/view_models/user_data_provider.dart';
import 'package:shop_owner_app/ui/constants/app_consntants.dart';
import 'package:shop_owner_app/ui/constants/assets_path.dart';
import 'package:shop_owner_app/ui/utils/ui_tools/my_alert_dialog.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final ScrollController _scrollController = ScrollController();
  UserModel _userData = UserModel();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      userDataProvider.fetchUserData();
    });
    _userData = userDataProvider.userData;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: _userData.imageUrl.isNotEmpty && !kIsWeb
                      ? Image.network(
                          _userData.imageUrl,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(ImagePath.profilePlaceholder,
                          fit: BoxFit.cover),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 28.0, horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///    User bag section

                      //    User information section

                      _sectionTitle('User Information'),
                      Card(
                        child: Column(
                          children: [
                            _userInformationListTile(
                                _userData.fullName, mUserIcon, context),
                            _userInformationListTile(
                                _userData.email, mEmailIcon, context),
                            _userInformationListTile(
                                _userData.phoneNumber, mPhoneIcon, context),
                            _userInformationListTile(
                                '', mShippingAddress, context),
                            _userInformationListTile(
                                'Joined ${_userData.joinedAt}',
                                mJoinDateIcon,
                                context),
                          ],
                        ),
                      ),

                      //    Settings Section
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Floating Button Appbar to upload profile picture
          _uploadPictureFab(),
        ],
      ),
    );
  }

  Widget _userInformationListTile(title, icon, context) {
    return ListTile(
      title: Text(title),
      leading: _customIcon(icon),
      onTap: () {},
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 0, 0),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _customIcon(IconData icon) {
    return Icon(
      icon,
      color: Theme.of(context).iconTheme.color,
    );
  }

  Widget _uploadPictureFab() {
    // Starting Fab position
    const double defaultTopMargin = 200.0 - 20;
    // pixels from top where scalling should start
    const double scaleStart = defaultTopMargin / 2;
    // pixels from top where scalling should end
    const double scaleEnd = scaleStart / 2;

    double top = defaultTopMargin;
    double scale = 1.0;

    if (_scrollController.hasClients) {
      double offset = _scrollController.offset;
      top -= offset;

      if (offset < defaultTopMargin - scaleStart) {
        //offset small => don't scale down
        scale = 1.0;
      } else if (offset < defaultTopMargin - scaleEnd) {
        // offset between scaleStart and scaleEnd => scale down
        scale = (defaultTopMargin - scaleEnd - offset) / scaleEnd;
      } else {
        // offset passed scaleEnd => hide Fab
        scale = 0.0;
      }
    }

    return Positioned(
        top: top,
        right: 16.0,
        child: Transform(
          transform: Matrix4.identity()..scale(scale),
          alignment: Alignment.center,
          child: FloatingActionButton(
            mini: true,
            onPressed: () => MyAlertDialog.imagePicker(context),
            heroTag: 'btn1',
            child: const Icon(mCameraIcon),
          ),
        ));
  }
}
