
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const UserProfileScreen(),
    );
  }
}

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * .35,
                            decoration: const BoxDecoration(
                              color: Color(0Xff0c0e2a),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {},
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .0430,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .087,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: const Color(0xff24263f),
                                              width: .5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(50),
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
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 20),
                                    ProfilePicture(
                                      imageUrl:
                                          'https://avatar.iran.liara.run/public',
                                    ),
                                    SizedBox(width: 15),
                                    UserFullNameUserName(
                                      fullName: 'Marvin McKinney',
                                      userName: '@mac_01',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: -1,
                            child: Container(
                              height: MediaQuery.of(context).size.height * .080,
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.only(left: 20, top: 20),
                                child: Text(
                                  'Account Information',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff3F3F3F),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ProfileItems(
                              onPressed: () async {},
                              leadingIcon: Icons.person_2_outlined,
                              text: 'Edit profile',
                            ),
                            ProfileItems(
                              onPressed: () async {},
                              leadingIcon: Icons.security_outlined,
                              text: 'Change password',
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const TitleTextWidget(title: 'Legal'),
                            const SizedBox(
                              height: 20,
                            ),
                            ProfileItems(
                              onPressed: () async {},
                              leadingIcon: Icons.gavel,
                              text: 'Terms & Conditions',
                            ),
                            ProfileItems(
                              onPressed: () {},
                              leadingIcon: Icons.policy,
                              text: 'Privacy Policy',
                            ),
                            ProfileItems(
                              onPressed: () {},
                              leadingIcon: Icons.delete_forever,
                              text: 'Delete Account',
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      LogoutButton(
                        text: 'Log Out',
                        onPressed: () async {},
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

typedef VoidCallback = void Function();

class ProfileItems extends StatelessWidget {
  final IconData leadingIcon;
  final VoidCallback onPressed;

  final String text;
  const ProfileItems({
    super.key,
    required this.leadingIcon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 23,
      ),
      child: GestureDetector(
        onTap: onPressed,
        child: Row(
          children: [
            Icon(
              leadingIcon,
              color: const Color(0xff3F3F3F),
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xff3F3F3F),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                    width: .5,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xff3F3F3F),
                    size: 9,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const LogoutButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          height: MediaQuery.of(context).size.height * .06,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: const Color(0xffFFF5F6),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xffF84646),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TitleTextWidget extends StatelessWidget {
  final String title;
  const TitleTextWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 14),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Color(0xff3F3F3F),
        ),
      ),
    );
  }
}

class ProfilePicture extends StatelessWidget {
  final String imageUrl;
  const ProfilePicture({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.7),
              spreadRadius: -.01,
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        //TODO caching image on prod
        child: CircleAvatar(
          backgroundColor: Colors.red,
          radius: 53,
          child: CircleAvatar(
            backgroundColor: Colors.red,
            radius: 50,
            backgroundImage: NetworkImage(
              imageUrl,
            ), //NetworkImage
          ),
        ),
      ),
    );
  }
}

class UserFullNameUserName extends StatelessWidget {
  final String fullName;
  final String userName;
  const UserFullNameUserName({
    super.key,
    required this.fullName,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            fullName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            userName,
            style: const TextStyle(
              color: Color(0xff6D6F7E),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}