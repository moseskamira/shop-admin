import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String fullName;
  String imageUrl;
  String address;
  String phoneNumber;
  String email;
  String joinedAt;
  Timestamp? createdAt;
  String addressLine1;
  String addressLine2;
  String city;
  String state;
  String postalCode;
  String country;
  String latitude;
  String longitude;

  UserModel({
    this.id = '',
    this.fullName = '',
    this.address = '',
    this.phoneNumber = '',
    this.imageUrl = '',
    this.email = '',
    this.joinedAt = '',
    this.createdAt,
    this.addressLine1 = '',
    this.addressLine2 = '',
    this.city = '',
    this.state = '',
    this.postalCode = '',
    this.country = '',
    this.latitude = '',
    this.longitude = '',
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        fullName = json['fullName'],
        email = json['email'],
        phoneNumber = json['phoneNumber'],
        imageUrl = json['imageUrl'],
        address = json['address'],
        joinedAt = json['joinedAt'],
        createdAt = json['createdAt'],
        addressLine1 = json['addressLine1'],
        addressLine2 = json['addressLine2'],
        city = json['city'],
        state = json['state'],
        postalCode = json['postalCode'],
        country = json['country'],
        latitude = json['latitude'].toString(),
        longitude = json['longitude'].toString();

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'imageUrl': imageUrl,
        'address': address,
        'joinedAt': joinedAt,
        'createdAt': createdAt,
        'addressLine1': addressLine1,
        'addressLine2': addressLine2,
        'city': city,
        'state': state,
        'postalCode': postalCode,
        'country': country,
        'latitude': latitude,
        'longitude': longitude,
      };

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserModel(
      id: data['id'] ?? '',
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      address: data['address'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      joinedAt: data['joinedAt'] ?? '',
      createdAt: data['createdAt'] ?? '',
      addressLine1: data['addressLine1'] ?? '',
      addressLine2: data['addressLine2'] ?? '',
      city: data['city'] ?? '',
      state: data['state'] ?? '',
      postalCode: data['postalCode'] ?? '',
      country: data['country'] ?? '',
      latitude: data['latitude'].toString(),
      longitude: data['longitude'].toString(),
    );
  }

  factory UserModel.loading() {
    return UserModel(
      id: '',
      fullName: '',
      imageUrl: '',
      phoneNumber: '',
      email: '',
      joinedAt: '',
      address: '',
      createdAt: null,
    );
  }
}
