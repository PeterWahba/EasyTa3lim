import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class AwesomeNotifcationService {
  static const channelKeys = {
    'user_notifications': 'user_notifications',
  };

  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: channelKeys['user_notifications'],
          channelKey: channelKeys['user_notifications'],
          channelName: 'user_notifications',
          channelDescription: 'App Notifications',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: true,
          playSound: true,
          criticalAlerts: true,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: channelKeys['user_notifications'].toString(),
          channelGroupName: 'Group 1',
        )
      ],
      debug: true,
    );

    await AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) async {
        if (!isAllowed) {
          await AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  /// Use this method to detect when a new notification or a schedule is created
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationCreatedMethod');
  }

  /// Use this method to detect every time that a new notification is displayed
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationDisplayedMethod');
  }

  /// Use this method to detect if the user dismissed a notification
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onDismissActionReceivedMethod');
  }

  /// Use this method to detect when the user taps on a notification or action button
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    try {
      debugPrint('onActionReceivedMethod');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> showNotification({
    required final String title,
    required final String body,
    required final String chanelKay,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? category,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final int? id,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id!,
        channelKey: chanelKay,
        title: title,
        body: body,
        actionType: actionType,
        notificationLayout: notificationLayout,
        summary: summary,
        category: category,
        payload: payload,
        bigPicture: bigPicture,
        wakeUpScreen: true,
        groupKey: 'chat_messages',
      ),
      actionButtons: actionButtons,
    );
  }

  static Future<void> handleNotification(RemoteMessage message) async {
    try {
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        await showNotification(
          chanelKay: 'user_notifications',
          title: notification.title ?? 'No Title',
          body: notification.body ?? 'No Body',
          id: Random().nextInt(1000000),
        );
      } else {
        debugPrint('Notification is null');
      }
    } catch (e) {
      debugPrint('Error handling notification: $e');
    }
  }
}
