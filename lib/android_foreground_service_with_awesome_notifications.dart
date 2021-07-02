/// Provides mechanisms to start and stop and Android foreground service,
/// while utilizing [awesome_notifications PushNotification](https://pub.dev/documentation/awesome_notifications/latest/awesome_notifications/PushNotification-class.html).
library android_foreground_service_with_awesome_notifications;

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

/// Static helper class that contains various Android related constants
/// and provides methods to start and stop a foreground service.
///
/// AFSWAN is an abbreviation for android_foreground_service_with_awesome_notifications.
class AFSWAN {
  /// Corresponds to [`Service.START_STICKY_COMPATIBILITY`](https://developer.android.com/reference/android/app/Service#START_STICKY_COMPATIBILITY).
  static const startStickyCompatibility = 0;

  /// Corresponds to [`Service.START_STICKY`](https://developer.android.com/reference/android/app/Service#START_STICKY).
  static const startSticky = 1;

  /// Corresponds to [`Service.START_NOT_STICKY`](https://developer.android.com/reference/android/app/Service#START_NOT_STICKY).
  static const startNotSticky = 2;

  /// Corresponds to [`Service.START_REDELIVER_INTENT`](https://developer.android.com/reference/android/app/Service#START_REDELIVER_INTENT).
  static const startRedeliverIntent = 3;

  /// Corresponds to [`ServiceInfo.FOREGROUND_SERVICE_TYPE_MANIFEST`](https://developer.android.com/reference/android/content/pm/ServiceInfo#FOREGROUND_SERVICE_TYPE_MANIFEST).
  static const int foregroundServiceTypeManifest = -1;

  /// Corresponds to [`ServiceInfo.FOREGROUND_SERVICE_TYPE_NONE`](https://developer.android.com/reference/android/content/pm/ServiceInfo#FOREGROUND_SERVICE_TYPE_NONE).
  static const int foregroundServiceTypeNone = 0;

  /// Corresponds to [`ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC`](https://developer.android.com/reference/android/content/pm/ServiceInfo#FOREGROUND_SERVICE_TYPE_DATA_SYNC).
  static const int foregroundServiceTypeDataSync = 1;

  /// Corresponds to [`ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PLAYBACK`](https://developer.android.com/reference/android/content/pm/ServiceInfo#FOREGROUND_SERVICE_TYPE_MEDIA_PLAYBACK).
  static const int foregroundServiceTypeMediaPlayback = 2;

  /// Corresponds to [`ServiceInfo.FOREGROUND_SERVICE_TYPE_PHONE_CALL`](https://developer.android.com/reference/android/content/pm/ServiceInfo#FOREGROUND_SERVICE_TYPE_PHONE_CALL).
  static const int foregroundServiceTypePhoneCall = 4;

  /// Corresponds to [`ServiceInfo.FOREGROUND_SERVICE_TYPE_LOCATION`](https://developer.android.com/reference/android/content/pm/ServiceInfo#FOREGROUND_SERVICE_TYPE_LOCATION).
  static const int foregroundServiceTypeLocation = 8;

  /// Corresponds to [`ServiceInfo.FOREGROUND_SERVICE_TYPE_CONNECTED_DEVICE`](https://developer.android.com/reference/android/content/pm/ServiceInfo#FOREGROUND_SERVICE_TYPE_CONNECTED_DEVICE).
  static const int foregroundServiceTypeConnectedDevice = 16;

  /// Corresponds to [`ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PROJECTION`](https://developer.android.com/reference/android/content/pm/ServiceInfo#FOREGROUND_SERVICE_TYPE_MEDIA_PROJECTION).
  static const int foregroundServiceTypeMediaProjection = 32;

  /// Corresponds to [`ServiceInfo.FOREGROUND_SERVICE_TYPE_CAMERA`](https://developer.android.com/reference/android/content/pm/ServiceInfo#FOREGROUND_SERVICE_TYPE_CAMERA).
  static const int foregroundServiceTypeCamera = 64;

  /// Corresponds to [`ServiceInfo.FOREGROUND_SERVICE_TYPE_MICROPHONE`](https://developer.android.com/reference/android/content/pm/ServiceInfo#FOREGROUND_SERVICE_TYPE_MICROPHONE).
  static const int foregroundServiceTypeMicrophone = 128;

  static const MethodChannel _channel = const MethodChannel('eu.epnw.afswan');

  /// Starts the foreground service with the given `notification`, whichs content must not be `null`.
  ///
  /// The notification can be updated by simply calling this method multiple times.
  ///
  /// Information on selecting a appropriate `startType` for your app's usecase should be taken from the
  /// official Android documentation, check [`Service.onStartCommand`](https://developer.android.com/reference/android/app/Service#onStartCommand(android.content.Intent,%20int,%20int)).
  ///
  /// The [`notifcation.content.locked`](https://pub.dev/documentation/awesome_notifications/latest/awesome_notifications/NotificationContent/locked.html)
  /// property will be forced to `true` to achive an ongoing
  /// notificaiton suitable for a foreground service. Also, [`notification.schedule`](https://pub.dev/documentation/awesome_notifications/latest/awesome_notifications/PushNotification/schedule.html)
  /// will be cleared, since the notifcation needs to be shown right away when the foreground service is started.
  ///
  /// If `foregroundServiceType` is set, [`Service.startForeground(int id, Notification notification, int foregroundServiceType)`](https://developer.android.com/reference/android/app/Service#startForeground(int,%20android.app.Notification,%20int))
  /// will be invoked , else  [`Service.startForeground(int id, Notification notification)`](https://developer.android.com/reference/android/app/Service#startForeground(int,%20android.app.Notification)) is used.
  /// On devices older than [`Build.VERSION_CODES.Q`](https://developer.android.com/reference/android/os/Build.VERSION_CODES#Q), `foregroundServiceType` will be ignored.
  /// Multiple type flags can be ORed together (using the `|` operator).
  /// Note that `foregroundServiceType` must be a subset of the `android:foregroundServiceType` defined in your `AndroidManifest.xml`!
  ///
  /// **IMPORTANT**: If [`notification.content.icon`](https://pub.dev/documentation/awesome_notifications/latest/awesome_notifications/NotificationContent/icon.html)
  /// is not set or not valid, the notification will appear, but will look very strange.
  /// Make sure to always specify an valid icon.
  static Future<void> startForeground(
      {required PushNotification notification,
      int startType = startSticky,
      int? foregroundServiceType}) async {
    NotificationContent? content = notification.content;
    if (content == null) {
      throw new ArgumentError('The content of notification must not be null!');
    }
    notification.schedule = null;
    content.locked = true;
    await _channel.invokeMethod('startForeground', {
      'notificationData': notification.toMap(),
      'startType': startType,
      'hasForegroundServiceType': foregroundServiceType != null,
      'foregroundServiceType': foregroundServiceType ?? 0
    });
  }

  /// Stops a foreground service.
  ///
  /// If the foreground service was not started, this function
  /// will do nothing.
  ///
  /// It is sufficient to call this method once to stop the
  /// foreground service, even if [startForeground] was called
  /// multiple times.
  static Future<void> stopForeground() async {
    await _channel.invokeMethod('stopForeground');
  }

  /// The constructor is hidden since this class should not be instantiated.
  const AFSWAN._();
}
