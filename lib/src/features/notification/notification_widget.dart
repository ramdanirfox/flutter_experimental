import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationOverlay extends StatelessWidget {
  static final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  const NotificationOverlay({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Notification App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Simple Notification App'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              await _showHelloWorldNotification();
            },
            child: const Text('Show Hello World Notification'),
          ),
        ),
      ),
    );
  }


  Future<void> _showHelloWorldNotification() async {

    // if (Platform.isAndroid) {
   final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          plugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

   final bool? grantedNotificationPermission =
          await androidImplementation?.requestNotificationsPermission();

      // setState(() {
      //   _notificationsEnabled = granted;
      // });
    // }

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your channel id', // Replace with your own channel ID
      'your channel name', // Replace with your own channel name
      channelDescription:
          'your channel description', // Replace with your own channel description
      priority: Priority.defaultPriority,
      importance: Importance.defaultImportance,
      icon: '@mipmap/ic_launcher'
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidNotificationDetails);
    await plugin.show(
      0, // Notification ID (can be unique for each notification)
      'Saatnya Presensi!', // Notification title
      'Tekan notifikasi untuk mengisi presensi.', // Notification body
      platformChannelSpecifics,
      payload: 'simple notification payload', // Optional payload
    );
  }
}
