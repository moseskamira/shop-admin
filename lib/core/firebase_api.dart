import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: ${fCMToken}');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    ///fr-gF9OoSK-4bxKIE9c_Q0:APA91bEMT91bCXN68QVNvwE1WGeUHZNVz1mZGKQAYByREXl3Js6tKEq3_FkXhVGfioQuaQ5JVEf_bLjbuhu7sMVXQmqaYARuswxVzfQhW5cilzK3Ir7FmvQ
  }
}
