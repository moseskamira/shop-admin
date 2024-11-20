import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String fullName;
  String imageUrl;
  // String address;
  String phoneNumber;
  String email;
  String joinedAt;
  Timestamp? createdAt;

  UserModel({
    this.id = '',
    this.fullName = '',
    // this.address = '',
    this.phoneNumber = '',
    this.imageUrl = '',
    this.email = '',
    this.joinedAt = '',
    this.createdAt,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        fullName = json['fullName'],
        email = json['email'],
        phoneNumber = json['phoneNumber'],
        imageUrl = json['imageUrl'],
        joinedAt = json['joinedAt'],
        createdAt = json['createdAt'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'imageUrl': imageUrl,
        'joinedAt': joinedAt,
        'createdAt': createdAt,
      };

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserModel(
      id: data['id'] ?? '',
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      joinedAt: data['joinedAt'] ?? '',
      createdAt: data['createdAt'] ?? '',
    );
  }

  factory UserModel.empty() {
    return UserModel(
      id: '',
      fullName: '',
      imageUrl: '',
      phoneNumber: '',
      email: '',
      joinedAt: '',
      createdAt: null,
    );
  }
}


