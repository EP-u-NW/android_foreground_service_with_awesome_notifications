package eu.epnw.afswan;

import android.app.Notification;
import android.app.Service;
import android.content.Intent;
import android.os.Build;
import android.os.IBinder;

import me.carda.awesome_notifications.notifications.exceptions.AwesomeNotificationException;
import me.carda.awesome_notifications.notifications.models.PushNotification;
import me.carda.awesome_notifications.notifications.NotificationBuilder;

public class ForegroundService extends Service {

    private final NotificationBuilder builder;

    public ForegroundService() {
        super();
        this.builder = new NotificationBuilder();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        StartParameter parameter = (StartParameter) intent.getSerializableExtra(StartParameter.EXTRA);
        PushNotification pushNotification = new PushNotification().fromMap(parameter.notificationData);
        int notificationId = pushNotification.content.id;
        Notification notification;
        try {
            notification = builder.createNotification(this, pushNotification);
        } catch (AwesomeNotificationException e) {
            throw new RuntimeException(e);
        }
        if (parameter.hasForegroundServiceType && Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            startForeground(notificationId, notification, parameter.foregroundServiceType);
        } else {
            startForeground(notificationId, notification);
        }
        return parameter.startMode;
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}
