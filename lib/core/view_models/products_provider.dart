import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_owner_app/core/models/product_model.dart';
import 'package:shop_owner_app/core/services/api.dart';
import 'package:shop_owner_app/core/view_models/picture_provider.dart';

class ProductsProvider extends ChangeNotifier {
  final Api _api = Api(path: 'products');

  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;
  final pictureProvider = PicturesProvider();
 






  List<ProductModel> searchQuery(String query) => _products
      .where(
          (element) => element.name.toLowerCase().contains(query.toLowerCase()))
      .toList();

  List<ProductModel> findByCategory(String categoryTitle) => _products
      .where((element) =>
          element.category.toLowerCase().contains(categoryTitle.toLowerCase()))
      .toList();

  Stream<QuerySnapshot> fetchProductsAsStream() {
    return _api.streamDataCollection();
  }

  Future<ProductModel> getProductById(String id) async {
    var doc = await _api.getDocumentById(id);
    return ProductModel.fromJson(jsonDecode(doc.data().toString()));
  }

  Future removeProduct(
      {required String id,
      required List<String> imageUrlsOnFirebaseStorage}) async {
    await _api.removeDocument(id);
    pictureProvider.deletePictures(picturePaths: imageUrlsOnFirebaseStorage);

    notifyListeners();
    return;
  }

  Future updateProduct(ProductModel data, String id) async {
    await _api.updateDocument(data.toJson(), id);
    notifyListeners();
    return;
  }

  Future addProduct(ProductModel data) async {
    await _api.addDocument(productModel: data).whenComplete(() {
      notifyListeners();
    });
    return;
  }
}
