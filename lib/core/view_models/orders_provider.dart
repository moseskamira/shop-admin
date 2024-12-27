import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shop_owner_app/core/models/orders_model.dart';
import '../models/user_model.dart';

class OrdersProvider with ChangeNotifier {
  final Map<String, UserModel> _userCache = {};

  Stream<List<Map<String, dynamic>>> get ordersWithUsers {
    return FirebaseFirestore.instance.collection('orders').snapshots().asyncMap(
      (snapshot) async {
        List<Map<String, dynamic>> ordersWithUsers = [];
        for (var doc in snapshot.docs) {
          OrdersModel order = OrdersModel.fromJson(doc);

          UserModel user;
          if (_userCache.containsKey(order.customerId)) {
            user = _userCache[order.customerId]!;
          } else {
            DocumentSnapshot<Map<String, dynamic>> userDoc =
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(order.customerId)
                    .get();
            user = userDoc.exists
                ? UserModel.fromFirestore(userDoc)
                : UserModel.loading();
            _userCache[order.customerId] = user;
          }

          ordersWithUsers.add({'order': order, 'user': user});
        }
        return ordersWithUsers;
      },
    );
  }
}
