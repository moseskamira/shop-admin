import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shop_owner_app/core/models/user_model.dart';

class UserDataProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel _userData = UserModel();
  UserModel get userData => _userData;
   List<UserModel> _users = [];
     bool _isLoading = false;
List<UserModel> get users => _users;
  bool get isLoading => _isLoading;

  set userData(UserModel value) {
    _userData = value;
    notifyListeners();
  }

  Future<UserModel> fetchUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final uid = user.uid;
      if (!user.isAnonymous) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get()
            .then(
                (snapshot) => _userData = UserModel.fromJson(snapshot.data()!))
            .catchError((e) {
          print(e.toString());
        });
      }
      notifyListeners();
      return _userData;
    }
    return UserModel();
  }

  Future<void> uploadUserData(UserModel userModel) async {
    // set user id
    final user = _auth.currentUser;
    userModel.id = user!.uid;

    //set date
    var date = DateTime.now().toString();
    var dateparse = DateTime.parse(date);
    var formattedDate = "${dateparse.day}-${dateparse.month}-${dateparse.year}";
    userModel.joinedAt = formattedDate;
    userModel.createdAt = Timestamp.now();

    // Upload user data to firebase firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.id)
        .set(userModel.toJson());
    notifyListeners();
  }




Stream<List<UserModel>> get usersStream {
  
  return FirebaseFirestore.instance.collection('users').snapshots().map(
        (snapshot) => snapshot.docs.map((doc) {
          return UserModel.fromFirestore(doc);
        }).toList(),
      );
}


Stream<CustomerModelTest?> userStream(String userId) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .snapshots()
      .map((snapshot) {
        // Check if the document exists before attempting to convert it
        if (snapshot.exists) {
          return CustomerModelTest.fromFirestore(snapshot);
        }
        return null; // Return null if the document does not exist
      });
}




}
