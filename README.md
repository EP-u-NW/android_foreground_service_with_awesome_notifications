# android_foreground_service_with_awesome_notifications

There are already serveral packages on pub that allow you to create an Android foreground service. Since an Android foreground service always needs an Android notification, most of the plugins come with an own notification system.
On the other hand, the most used notification system for flutter is [awesome_notifications](https://pub.dev/packages/awesome_notifications), and chances are that your app already uses it.
The problem is now that you don't want to have two API's for notifications: one for the foreground service and one for `awesome_notifications`.
So this package provides a foreground service that uses [awesome_notifications PushNotification](https://pub.dev/documentation/awesome_notifications/latest/awesome_notifications/PushNotification-class.html) class, and also uses it's java side algorithms to convert that dart object into an Android notification.
That is possible because in flutter you can import java classes from other packages.

## Configuration
While the [foreground service permission](https://developer.android.com/reference/android/Manifest.permission#FOREGROUND_SERVICE) is automatically added by this plugin, you have to add the ``<service>` tag manually to your `AndroidManifest.xml`. Theoretically, the service could have been declarded by this plugin, too, but you might wan't to use other parameters, so we opted to let you add it. Inside your `<application>` tag add
```xml
 <service   android:name="eu.epnw.afswan.ForegroundService"
            android:enabled="true"            
            android:exported="false"
            android:stopWithTask="true"
            android:foregroundServiceType=As you like
></service>
 ```
 While the `android:name` must exactly match this value, you can configure the other parameters as you like, although it is recommended to copy the values for `android:enabled`, `android:exported` and `android:stopWithTask`. Suitable values for `foregroundServiceType` can be found [here](https://developer.android.com/reference/android/app/Service#startForeground(int,%20android.app.Notification,%20int)).

 ## IMPORTANT
 If the icon of the notification is not set or not valid, the notification will appear, but will look very strange. Make sure to always specify an valid icon. If you need help with this, take a look at [awesome_notifications examples](https://github.com/rafaelsetragni/awesome_notifications/tree/master/example).

 ## About this plugins name
 Yes, `android_foreground_service_with_awesome_notifications` is a very long plugin name, but on the other hand very precise and tells you what this plugin does, just by reading the title. In some places we use `AFSWAN` as abbreviation.