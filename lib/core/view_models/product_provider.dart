// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:ecommerce_admin_app/core/models/product_model.dart';
//  import 'package:uuid/uuid.dart';
//
// class ProductProvider with ChangeNotifier {
//   List<ProductModel> _products = [];
//
//   List<ProductModel> get products => _products;
//
//   List<ProductModel> get popularProducts{
//     _products.where((element) => element.isPopular).toList();
//     notifyListeners();
//     return _products;
//
//   }
//
//
//   ProductModel findById(String id) =>
//       _products.firstWhere((element) => element.id == id);
//
//   List<ProductModel> findByCategory(String categoryTitle) => _products
//       .where((element) =>
//           element.category.toLowerCase().contains(categoryTitle.toLowerCase()))
//       .toList();
//
//   List<ProductModel> searchQuery(String query) => _products
//       .where(
//           (element) => element.name.toLowerCase().contains(query.toLowerCase()))
//       .toList();
//
//   Future<void> uploadProduct(ProductModel productModel) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//        productModel.id = Uuid().v4();
//         await FirebaseFirestore.instance
//             .collection('products')
//             .doc(productModel.id)
//             .set(productModel.toJson());
//     }
//   }
//
//   Future<void> fetchProducts() async {
//     _products.clear();
//      await FirebaseFirestore.instance
//         .collection('products')
//         .get()
//         .then((snapshot) => {
//               snapshot.docs.forEach((element) {
//                _products.add(ProductModel.fromJson(element.data()));
//               })
//             })
//         .catchError((e) {
//       print('FETCH PRODUCTS ERROR: ${e.message}');
//     });
//     }
//
//   Future<void> deleteProduct({required String productId}) async{
//
//     await FirebaseFirestore.instance
//         .collection('products').doc(productId).delete().then((value)async{
//       await fetchProducts();
//       });
//
//         notifyListeners();
//   }
//
//
// }
