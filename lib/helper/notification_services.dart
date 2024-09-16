import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';

class NotificationServices {
  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  //
  // void requestNotificationPermission() async {
  //   NotificationSettings settings = await messaging.requestPermission(
  //     alert: true,
  //     announcement: true,
  //     badge: true,
  //     criticalAlert: true,
  //     provisional: true,
  //     sound: true,
  //   );
  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     print('user granted');
  //   } else if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     print('user granted provision permission');
  //   } else {
  //     print('user denied permission');
  //   }
  // }
  //
  // Future<String> getdevicetoken() async {
  //   String? token = await messaging.getToken();
  //   return token!;
  // }
  //
  //
  // void initMessaging() async {
  //   flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //       AndroidFlutterLocalNotificationsPlugin>()
  //       ?.requestNotificationsPermission();
  //   NotificationSettings settings = await messaging.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );
  //
  //   debugPrint('User granted permission: ${settings.authorizationStatus}');
  //   FirebaseMessaging.onMessageOpenedApp.listen((event) {
  //     debugPrint('${event.data}');
  //   });
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     debugPrint('Got a message whilst in the foreground!');
  //     debugPrint('Message data: ${message.notification!.toMap()}');
  //     // flutterLocalNotificationsPlugin.show(id, title, body, notificationDetails)
  //     flutterLocalNotificationsPlugin.show(
  //         1,
  //         message.notification!.title,
  //         message.notification!.body,
  //         const NotificationDetails(
  //             android: AndroidNotificationDetails("1", "noti")));
  //   });
  //
  //   // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //   AndroidInitializationSettings(
  //     '@mipmap/ic_launcher',
  //   );
  //   final InitializationSettings initializationSettings =
  //   InitializationSettings(android: initializationSettingsAndroid);
  //   flutterLocalNotificationsPlugin.initialize(
  //     initializationSettings,
  //     onDidReceiveNotificationResponse: (details) {
  //       // details.
  //     },
  //   );
  //   // channel();
  //   // initDynamicLinks();
  //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // }
  //
  // Future<void> _firebaseMessagingBackgroundHandler(
  //     RemoteMessage message) async {
  //   // you need to initialize firebase first
  //   await Firebase.initializeApp();
  //
  //   // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //   // await setupFlutterNotifications();
  //   // showFlutterNotification(message);
  //   // If you're going to use other Firebase services in the background, such as Firestore,
  //   // make sure you call initializeApp before using other Firebase services.
  //   // debugPrint('Handling a background message ${message.messageId}');
  // }
  //initialising firebase message plugin

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  //initialising firebase message plugin

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future forgroundMessages() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      sound: true,
      provisional: true,
      criticalAlert: true,
      carPlay: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User Granted Permisison");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User Granted Permisison");
    } else {
      print("User Did Not Granted Permisison");
    }
  }

  //function to initialise flutter local notification plugin to show notifications for android when app is active
  void initLocalNotification(
      BuildContext context, RemoteMessage message) async {
    var androidInitialization =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSetting = InitializationSettings(
      android: androidInitialization,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {});
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if (Platform.isIOS) {
        forgroundMessages();
      }
      if (Platform.isAndroid) {
        print('Received FCM message: ${message.data}');
        initLocalNotification(context, message);
        showNotification(message);
      }
    });
  }

  // function to show visible notification when app is active
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(10000).toString(),
      message.notification!.android!.channelId.toString(),
      importance: Importance.max,
      showBadge: true,
      playSound: true,
      enableVibration: (message.data["vibration"] == "true"),
      vibrationPattern: Int64List.fromList([0, 1000, 500, 1000, 500, 1000]),
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'Your Channel',
      priority: Priority.high,
      importance: Importance.high,
      ticker: 'ticker',
      playSound: true,
      enableVibration: (message.data["vibration"] == "true"),
      vibrationPattern: Int64List.fromList([0, 1000, 500, 1000, 500, 1000]),
      sound: null,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification?.title!.toString(),
          message.notification?.body.toString(),
          notificationDetails);
    });
  }

  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    try {
      await Firebase.initializeApp();

      if (kDebugMode) {
        print("Handling a background message: ${message.messageId}");
        print('Message data: ${message.data}');
        print('Message notification: ${message.notification?.title}');
        print('Message notification: ${message.notification?.body}');
      }
    } catch (e) {
      print('Error background message handle $e');
    }
  }
}
