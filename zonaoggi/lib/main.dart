import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:zonaoggi/home/HomePage.dart';
import 'package:zonaoggi/utils/AppColors.dart';
import 'package:intl/date_symbol_data_local.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'zonaoggi_channel',
  'Notifiche Zona Oggi',
  'Questo channel è utilizzato per inviare le notifiche',
  importance: Importance.high,
  enableVibration: true,
  playSound: true,
  showBadge: true,
  ledColor: AppColors.accent
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true
  );
  print("Token: " + await FirebaseMessaging.instance.getToken());
  initializeDateFormatting('it_IT', null).then((_) => runApp(App()));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage message) {
      /*if (message != null) {
        Navigator.pushNamed(context, '/message',
            arguments: MessageArguments(message, true));
      }*/
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      print(notification.title + " " + notification.body);

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              icon: 'ic_launcher',
              color: const Color.fromARGB(255, 255, 0, 0),
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      /*Navigator.pushNamed(context, '/message',
          arguments: MessageArguments(message, true));*/
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZONAOGGI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: AppColors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: "Montserrat"
      ),
      home: HomePage(),
    );
  }
}
