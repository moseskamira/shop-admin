import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shop_owner_app/core/models/product_model.dart';

class SearchProvider with ChangeNotifier {
  SearchProvider() {
    fetchProducts();
  }

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  final List<ProductModel> _products = [];

  List<ProductModel> get products => _products;

  List<ProductModel> searchQuery(String query) => _products
      .where((element) =>
          element.name.toLowerCase().contains(query.toLowerCase()) ||
          element.category.toLowerCase().contains(query.toLowerCase()) ||
          element.brand.toLowerCase().contains(query.toLowerCase()))
      .toList();

  Future<void> fetchProducts() async {
    await _fireStore.collection('products').get().then((snapshot) {
      for (var element in snapshot.docs) {
        _products.insert(0, ProductModel.fromJson(element.data()));
      }
      notifyListeners();
    });
  }
}