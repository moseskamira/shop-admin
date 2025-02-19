import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:shop_owner_app/core/models/user_model.dart';
import 'package:shop_owner_app/core/view_models/picture_provider.dart';
import 'package:shop_owner_app/core/view_models/user_data_provider.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  bool get isLoggedIn =>
      _firebaseAuth.currentUser != null &&
      !_firebaseAuth.currentUser!.isAnonymous;

  Future<void> signUp({
    required String email,
    required String password,
    required UserModel userModel,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      userModel.id = _firebaseAuth.currentUser?.uid ?? '';
      if (userModel.imageUrl.isNotEmpty) {
        final imageUploader = PicturesProvider();
        final imageUrl = await imageUploader.uploadSinglePicture(
          fileLocationinDevice: userModel.imageUrl,
        );
        userModel.imageUrl = imageUrl;
        notifyListeners();
      }

      await UserDataProvider().uploadUserData(userModel);
      notifyListeners();
    } finally {
      notifyListeners();
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> googleSignIn() async {
    try {
      final googleAccount = await _googleSignIn.signIn();
      if (googleAccount != null) {
        final googleAuth = await googleAccount.authentication;
        if (googleAuth.accessToken != null && googleAuth.idToken != null) {
          final credential = GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

          final userCredential =
              await _firebaseAuth.signInWithCredential(credential);
          final user = userCredential.user;

          if (user != null) {
            final userDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

            if (!userDoc.exists) {
              UserModel userModel = UserModel(
                id: user.uid,
                email: user.email ?? '',
                fullName: user.displayName ?? '',
                imageUrl: user.photoURL ?? '',
                phoneNumber: user.phoneNumber ?? '',
                createdAt: Timestamp.now(),
                joinedAt:
                    DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
              );

              // Upload user data only if the document doesn't exist
              await UserDataProvider()
                  .uploadUserData(userModel)
                  .then((_) => print('Done Uploading'));
            } else {
              print('User already exists. No need to upload data.');
            }

            notifyListeners();
          }
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(
          email: email.trim().toLowerCase());
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      if (!kIsWeb) {
        if (await _googleSignIn.isSignedIn()) {
          await _googleSignIn.disconnect();
        }
      }
      await _firebaseAuth.signOut().then((_) {
        notifyListeners();
      });
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      notifyListeners();
    }
  }
}
