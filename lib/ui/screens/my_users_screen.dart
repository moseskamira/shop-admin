import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_owner_app/core/models/user_model.dart';
import 'package:shop_owner_app/ui/routes/route_name.dart';

import '../../core/models/customer_model.dart';

class MyUsersScreen extends StatelessWidget {
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
                      onTap: (){
                        Navigator.of(context).pushNamed(RouteName.userDetailsScreen, arguments: {
                      
                        'user': CustomerModel(name:user.fullName ),
                         
                      },);
                      },
                      child: ListTile(
                        title: Text(user.fullName),
                        subtitle: Text(user.email),
                      ),
                    );
                  },
                ),
    );
  }
}
