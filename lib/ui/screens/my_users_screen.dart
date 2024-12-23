import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shop_owner_app/core/models/user_model.dart';
import 'package:shop_owner_app/ui/routes/route_name.dart';
import 'package:cached_network_image/cached_network_image.dart';
 
class MyUsersScreen extends StatelessWidget {
  const MyUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<UserModel>>(context);
    final isLoading = users.length == 1 && users.first.id.isEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : users.isEmpty
              ? const Center(
                  child: Text('No users found.'),
                )
              : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            RouteName.userDetailsScreen,
                            arguments: {
                              'user':  user,
                            },
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
                                            height: 40,
                                            width: 40,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          )
                                        : Container(
                                            height: 40,
                                            width: 40,
                                            color: Colors.grey[
                                                300], // Optional background color
                                            child: const Icon(
                                              Icons
                                                  .person, // Use an icon representing a human face
                                              size: 30,
                                              color: Colors.grey, // Icon color
                                            ),
                                          ),
                                  ),
                                ),
                                const Gap(10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user.fullName),
                                    Text(user.email)
                                  ],
                                )
                              ],
                            ),
                          ),
                        ));
                  },
                ),
    );
  }
}
