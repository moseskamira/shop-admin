import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../ui/constants/time_stamp_converter.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  String id;
  String fullName;
  String imageUrl;
  String address;
  String phoneNumber;
  String email;
  String joinedAt;

  @JsonKey(name: 'createdAt')
  @TimestampConverter()
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

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

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
