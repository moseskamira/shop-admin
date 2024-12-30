import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shop_owner_app/core/models/user_model.dart';
import 'package:shop_owner_app/ui/routes/route_name.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shop_owner_app/core/view_models/user_data_provider.dart';
import 'package:sizer/sizer.dart';

class MyUsersScreen extends StatelessWidget {
  const MyUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: StreamBuilder<List<UserModel>>(
        stream: Provider.of<UserDataProvider>(context).usersStream,
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error state
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error occurred. Please try again later.'),
            );
          }

          // Data state
          if (snapshot.hasData) {
            final users = snapshot.data!;
            if (users.isEmpty) {
              return const Center(
                child: Text('No users found.'),
              );
            }
            users.sort((a, b) => a.fullName.compareTo(b.fullName));
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      RouteName.userDetailsScreen,
                      arguments: {'user': user},
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Hero(
                            tag: user.imageUrl,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: user.imageUrl.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: user.imageUrl,
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    )
                                  : Container(
                                      height: 10.h,
                                      width: 30.w,
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.person,
                                        size: 30,
                                        color: Colors.grey,
                                      ),
                                    ),
                            ),
                          ),
                          const Gap(10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Name: ${user.fullName}'),
                              Text('Email: ${user.email}'),
                              Text('Mobile: ${user.phoneNumber}'),
                              Text('Addr: ${user.address}'.truncate(45)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          // No data fallback
          return const Center(
            child: Text('No users found.'),
          );
        },
      ),
    );
  }
}

extension on String {
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$suffix';
  }
}
