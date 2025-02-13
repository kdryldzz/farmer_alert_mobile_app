import 'package:farmer_alert/services/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}

Future<void> scheduleNotification(
    String title, String body, DateTime dateTime) async {
  tz.initializeTimeZones();
  final tz.TZDateTime scheduledDate = tz.TZDateTime.from(dateTime, tz.local);

  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'irrigation_alerts',
    'Irrigation Alerts',
    channelDescription: 'Notifications for irrigation scheduling',
    importance: Importance.high,
    priority: Priority.high,
  );

  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    title,
    body,
    scheduledDate,
    notificationDetails,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: "https://hwmxguixxkipefgccero.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh3bXhndWl4eGtpcGVmZ2NjZXJvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUzODk1MTYsImV4cCI6MjA1MDk2NTUxNn0.hVAC9curfyvPSxxSgAWQb8Kis3XsnI32iLPW9l_XWkM");
  await initializeNotifications(); // Bildirimleri başlat
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AuthGate(),
    );
  }
}
