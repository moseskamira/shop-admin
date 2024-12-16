import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shop_owner_app/core/models/orders_model.dart';

class OrdersProvider with ChangeNotifier {
  

Stream<List<OrdersModel>> get orders {
  return FirebaseFirestore.instance.collection('orders').snapshots().map(
        (snapshot) => snapshot.docs.map((doc) {
          return OrdersModel.fromJson(doc);
        }).toList(),
      );
}
}