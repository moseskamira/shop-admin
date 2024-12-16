import 'package:flutter/material.dart';

import '../../core/models/customer_model.dart';

class UserDetails extends StatefulWidget {
  final CustomerModel user;
  const UserDetails({super.key, required this.user});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details of the user'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name: ${widget.user.name}'),
          Text('Email: ${widget.user.name}'),
          Text('Phone Number: ${widget.user.name}'),
          Text('Formatted Address ${widget.user.name}'),
        ],
      ),
    );
  }
}
