/// Provides mechanisms to start and stop an Android foreground service,
/// while utilizing [awesome_notifications `PushNotification`](https://pub.dev/documentation/awesome_notifications/latest/awesome_notifications/PushNotification-class.html).
library android_foreground_service_with_awesome_notifications;

export 'src/constants.dart';
export 'src/awfswan_web.dart' if (dart.library.io) 'src/afswan_io.dart';
