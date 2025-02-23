import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shop_owner_app/core/enums/app_enums.dart';
import 'package:shop_owner_app/core/models/user_model.dart';

class ProfileProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  String _updateErrorMsg = '';

  get updateError => _updateErrorMsg;

  ProfileStates _userDataState = ProfileStates.idle;

  get userState => _userDataState;

  Stream<UserModel>? get fetchProfile {
    final user = _auth.currentUser;
    if (user == null || user.isAnonymous) {
      return null;
    }
    final uid = user.uid;
    return _fireStore.collection('adminUsers').doc(uid).snapshots().map(
      (snapshot) {
        return UserModel.fromJson(snapshot.data()!);
      },
    );
  }

  Future<void> updateProfile(UserModel userModel) async {
    _userDataState = ProfileStates.updateLoading;
    notifyListeners();
    final user = _auth.currentUser;
    userModel.id = user!.uid;
    await _fireStore
        .collection('adminUsers')
        .doc(userModel.id)
        .update(userModel.toJson())
        .then((value) {
      _userDataState = ProfileStates.updateSuccess;
    }).onError((error, stackTrace) {
      _userDataState = ProfileStates.updateError;
      _updateErrorMsg = error.toString();
    }).whenComplete(() {
      notifyListeners();
    });
  }

  Stream<List<UserModel>> get usersStream {
    return FirebaseFirestore.instance.collection('users').snapshots().map(
          (snapshot) => snapshot.docs.map((doc) {
            return UserModel.fromFirestore(doc);
          }).toList(),
        );
  }
}
