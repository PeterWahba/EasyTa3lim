import 'package:firebase_messaging/firebase_messaging.dart';

import 'awesome_notifcation_service.dart';

class FirebaseMessagingService {

  static Future<void> initializeFirebaseMessaging() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onBackgroundMessage(
        FirebaseMessagingService.firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage
        .listen(AwesomeNotifcationService.handleNotification);
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await AwesomeNotifcationService.initializeNotification();
    AwesomeNotifcationService.handleNotification(message);
  }

  static Future<void> subscribeToTopic(String topic) async {
    try {
      await FirebaseMessaging.instance.subscribeToTopic(topic);
      // print('Successfully subscribed to topic: $topic');
    } catch (e) {
      // print('Error subscribing to topic $topic: $e');
    }
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
      // print('Successfully unsubscribed from topic: $topic');
    } catch (e) {
      // print('Error unsubscribing from topic $topic: $e');
    }
  }

}
