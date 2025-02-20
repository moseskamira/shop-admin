import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shop_owner_app/core/models/user_model.dart';

class UserDataProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Stream<UserModel> fetchUserData() async* {
    final user = _auth.currentUser;
    if (user != null) {
      final uid = user.uid;
      if (!user.isAnonymous) {
        yield* _fireStore
            .collection('adminUsers')
            .doc(uid)
            .snapshots()
            .map((snapshot) {
          if (snapshot.exists) {
            return UserModel.fromJson(snapshot.data()!);
          } else {
            return UserModel();
          }
        });
      } else {
        yield UserModel();
      }
    } else {
      yield UserModel();
    }
  }

  Future<void> updateUserData(UserModel userModel) async {
    ///TODO fixing update not changing existing user data of shipping address and so on
    try {
      final user = _auth.currentUser;
      userModel.id = user!.uid;
      await _fireStore
          .collection('adminUsers')
          .doc(userModel.id)
          .update(userModel.toJson());
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<UserModel>> get usersStream {
    return FirebaseFirestore.instance.collection('users').snapshots().map(
          (snapshot) => snapshot.docs.map((doc) {
            return UserModel.fromFirestore(doc);
          }).toList(),
        );
  }
}
