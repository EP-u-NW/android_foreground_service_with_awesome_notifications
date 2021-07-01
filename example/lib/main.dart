import 'package:flutter/material.dart';
import 'package:android_foreground_service_with_awesome_notifications/android_foreground_service_with_awesome_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await createNotificationChannel();
  runApp(MyApp());
}

const String basicChannelKey = 'basic_channel';
const int notifcationId = 1;

Future<void> createNotificationChannel() async {
  await AwesomeNotifications().initialize(
      'resource://drawable/ic_launcher',
      [
        NotificationChannel(
            channelKey: basicChannelKey,
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white),
      ],
      debug: true);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  void _startForeground() {
    AFSWAN.startForeground(
        notification: new PushNotification(
            content: new NotificationContent(
                icon: 'resource://drawable/ic_launcher',
                id: notifcationId,
                body: 'Foreground service running!',
                title: 'ASFWAN',
                channelKey: basicChannelKey)));
  }

  void _stopForeground() {
    AFSWAN.stopForeground();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('AFSWAN Example'),
          ),
          body: new Container(
            alignment: Alignment.center,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: _startForeground,
                    child: const Text('Start Foreground Service')),
                ElevatedButton(
                    onPressed: _stopForeground,
                    child: const Text('Stop Foreground Service'))
              ],
            ),
          )),
    );
  }
}
