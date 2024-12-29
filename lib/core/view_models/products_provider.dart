import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_owner_app/core/models/product_model.dart';
import 'package:shop_owner_app/core/services/api.dart';
import 'package:shop_owner_app/core/view_models/picture_provider.dart';

class ProductsProvider extends ChangeNotifier {
  final Api _api = Api(path: 'products');
  final pictureProvider = PicturesProvider();
  Stream<List<ProductModel>> get fetchProductsStream {
    return FirebaseFirestore.instance.collection('products').snapshots().map(
          (snapshot) => snapshot.docs.map((doc) {
            return ProductModel.fromFirestore(doc);
          }).toList(),
        );
  }

  Future deleteProduct(
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
