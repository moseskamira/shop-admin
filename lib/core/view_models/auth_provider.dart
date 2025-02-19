import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:shop_owner_app/core/models/user_model.dart';
import 'package:shop_owner_app/core/view_models/picture_provider.dart';

import '../../ui/routes/route_name.dart';
import '../../ui/utils/ui_tools/my_alert_dialog.dart';
import '../enums/app_enums.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final _googleSignIn = GoogleSignIn();
  AuthStates _authState = AuthStates.idle;

  bool get isLoggedIn =>
      _firebaseAuth.currentUser != null &&
      !_firebaseAuth.currentUser!.isAnonymous;

  get authState => _authState;

  Future<void> signUp({
    required String email,
    required String password,
    required UserModel userModel,
    required BuildContext ctx,
  }) async {
    try {
      _authState = AuthStates.signupLoading;
      notifyListeners();
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      userModel.id = userCredential.user?.uid ?? '';
      if (userModel.imageUrl.isNotEmpty) {
        final imageUploader = PicturesProvider();
        userModel.imageUrl = await imageUploader.uploadSinglePicture(
          fileLocationinDevice: userModel.imageUrl,
        );
      }
      final formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
      userModel.joinedAt = formattedDate;
      userModel.createdAt = Timestamp.now();
      await _fireStore
          .collection('adminUsers')
          .doc(userModel.id)
          .set(userModel.toJson());
      if (ctx.mounted) {
        _authState = AuthStates.signupSuccess;
        Navigator.of(ctx).pushNamedAndRemoveUntil(
          RouteName.bottomBarScreen,
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      _authState = AuthStates.signupError;
      if (ctx.mounted) {
        if (e.code.contains('email-already-in-use')) {
          _authState = AuthStates.signupEmailExists;
        } else if (e.code.contains('email')) {
          MyAlertDialog.error(ctx, "Invalid email format.");
        } else if (e.code.contains('network')) {
          MyAlertDialog.connectionError(ctx);
        } else {
          MyAlertDialog.error(
              ctx, e.message ?? "Signup failed. Please try again.");
        }
      }
    } catch (error) {
      _authState = AuthStates.signupError;
      if (ctx.mounted) {
        MyAlertDialog.error(ctx, error.toString());
      }
    } finally {
      notifyListeners();
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
    required BuildContext ctx,
  }) async {
    _authState = AuthStates.loginLoading;
    notifyListeners();
    await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((_) {
      _authState = AuthStates.loginSuccess;
      if (ctx.mounted) {
        Navigator.of(ctx).pushNamedAndRemoveUntil(
          RouteName.bottomBarScreen,
          (Route<dynamic> route) => false,
        );
      }
    }).onError((e, stackStress) {
      _authState = AuthStates.loginError;
      if (ctx.mounted) {
        if (e.toString().contains('wrong-password') ||
            e.toString().contains('user-not-found')) {
          _authState = AuthStates.wrongCreds;
        } else if (e.toString().toLowerCase().contains('network')) {
          MyAlertDialog.connectionError(ctx);
        } else {
          MyAlertDialog.error(ctx, e.toString());
        }
      }
    }).whenComplete(() {
      notifyListeners();
    });
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
