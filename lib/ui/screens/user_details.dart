import 'package:flutter/material.dart';
import 'package:shop_owner_app/core/models/user_model.dart';

class UserDetails extends StatefulWidget {
  final UserModel user;
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
          Text('Name: ${widget.user.fullName}'),
          Text('imageUrl: ${widget.user.imageUrl}'),
          Text('address: ${widget.user.address}'),
          Text('phoneNumber: ${widget.user.phoneNumber}'),
          Text('email: ${widget.user.email}'),
          Text('joinedAt: ${widget.user.joinedAt}'),
          Text('addressLine1: ${widget.user.addressLine1}'),
          Text('addressLine2: ${widget.user.addressLine2}'),
          Text('city: ${widget.user.city}'),
          Text('state: ${widget.user.state}'),
          Text('postalCode: ${widget.user.postalCode}'),
          Text('country: ${widget.user.country}'),
          Text('latitude: ${widget.user.latitude}'),
           Text('longitude: ${widget.user.longitude}'),
        ],
      ),
    );
  }
}
