import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel with ChangeNotifier {
  String id;
  String name;
  double price;
  String brand;
  String description;
  List<String>? imageUrls;
  String category;
  int quantity;
   bool isPopular;

  ProductModel(
      {this.id = '',
      this.name = '',
      this.price = 0,
      this.brand = '',
      this.description = '',
      this.imageUrls,
      this.category = '',
      this.quantity = 0,
       this.isPopular = false,
       });
        ProductModel.loading()
      : id = '',
        name = 'Loading...',
        price = 0,
        brand = 'Loading...',
        description = 'Loading...',
        imageUrls = [],
        category = 'Loading...',
        quantity = 0,
        isPopular = false;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductModelToJson(this);


factory ProductModel.fromFirestore(DocumentSnapshot doc) {
  final data = doc.data() as Map<String, dynamic>;
  return ProductModel(
    id: data['id'] ?? '',
    name: data['name'] ?? '',
    price: (data['price'] is num) ? (data['price'] as num).toDouble() : 0.0,
    brand: data['brand'] ?? '',
    description: data['description'] ?? '',
    imageUrls: (data['imageUrls'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    category: data['category'] ?? '',
    quantity: data['quantity'] ?? 0,
    isPopular: data['isPopular'] ?? false,
  );
}

}
