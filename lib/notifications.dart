import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'dart:async';

class FlutterLocalNotification {
  FlutterLocalNotification._();

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// 알림 초기화 함수
  static Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // 알림 채널 생성
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'channel_id',
      'channel_name',
      description: 'channel description',
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
  }

  static void printCurrentTime() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    print('현재 시간: ${now.toString()}');
  }

  /// 알림 권한 요청 함수 (Android 13 이상)
  static Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  static Future<void> showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel_id', 'channel_name',
            channelDescription: 'channel description',
            importance: Importance.max,
            priority: Priority.max,
            showWhen: false);

    const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: DarwinNotificationDetails(badgeNumber: 1));

    await flutterLocalNotificationsPlugin.show(
      0,
      'Code Ground',
      '코딩 공부 할 시간!! Code Ground에 접속하세요!',
      notificationDetails,
    );
  }

  /// 오후 7시를 감지하는 함수
  static void scheduleDailyCheck() {
    void checkTime() {
      final now = tz.TZDateTime.now(tz.local);
      print('현재 시간: ${now.hour}:${now.minute}:${now.second}');

      if (now.hour == 7 && now.minute == 00) {
        showNotification();
      }

      // 1분 후에 다시 체크
      Future.delayed(const Duration(seconds: 60), checkTime);
    }

    checkTime(); // 처음 호출
  }
}
