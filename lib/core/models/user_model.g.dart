// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      address: json['address'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      email: json['email'] as String? ?? '',
      joinedAt: json['joinedAt'] as String? ?? '',
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      addressLine1: json['addressLine1'] as String? ?? '',
      addressLine2: json['addressLine2'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      postalCode: json['postalCode'] as String? ?? '',
      country: json['country'] as String? ?? '',
      latitude: json['latitude'] as String? ?? '',
      longitude: json['longitude'] as String? ?? '',
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'imageUrl': instance.imageUrl,
      'address': instance.address,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'joinedAt': instance.joinedAt,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'addressLine1': instance.addressLine1,
      'addressLine2': instance.addressLine2,
      'city': instance.city,
      'state': instance.state,
      'postalCode': instance.postalCode,
      'country': instance.country,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
