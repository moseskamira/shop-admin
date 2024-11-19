import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/view_models/user_data_provider.dart';

class MyUsersScreen extends StatelessWidget {
  const MyUsersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserDataProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: FutureBuilder(
        future: userProvider.fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading users'));
          } else {
            return Consumer<UserDataProvider>(
              builder: (context, userProvider, child) {
                if (userProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: userProvider.users.length,
                  itemBuilder: (context, index) {
                    final user = userProvider.users[index];
                    return ListTile(
                      title: Text(user.fullName),
                      subtitle: Text(user.email),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
