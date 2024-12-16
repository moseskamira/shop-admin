import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_owner_app/core/models/product_model.dart';

class ProductsStreamProvider with ChangeNotifier {
  Stream<List<ProductModel>> get fetchProductsStream {
    return FirebaseFirestore.instance.collection('products').snapshots().map(
          (snapshot) => snapshot.docs.map((doc) {
            return ProductModel.fromFirestore(doc);
          }).toList(),
        );
  }
}
