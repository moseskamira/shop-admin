import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shop_owner_app/core/models/orders_model.dart';
 
class OrdersProvider with ChangeNotifier {
  // Fetch orders with associated user data
  Stream<List<Map<String, dynamic>>> get ordersWithUsers {
    return FirebaseFirestore.instance.collection('orders').snapshots().asyncMap(
      (snapshot) async {
        List<Map<String, dynamic>> ordersWithUsers = [];
        for (var doc in snapshot.docs) {
          // Parse order data
          OrdersModel order = OrdersModel.fromJson(doc);

          // Fetch associated user data
          DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(order.customerId) // Assuming OrdersModel has a `userId` field
              .get();

          // Combine order and user data
          Map<String, dynamic> combinedData = {
            'order': order,
            'user': userDoc.exists ? userDoc.data() : null,
          };

          ordersWithUsers.add(combinedData);
        }
        return ordersWithUsers;
      },
    );
  }
}
