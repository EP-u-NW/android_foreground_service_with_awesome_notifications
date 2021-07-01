package eu.epnw.afswan;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

public class StartParameter implements Serializable {

    public final static String EXTRA = "eu.epnw.afswan.StartParameter";

    // Explicitly use HashMap here since it is serializable
    public final HashMap<String, Object> notificationData;
    public final int startMode;
    public final boolean hasForegroundServiceType;
    public final int foregroundServiceType;

    public StartParameter(Map<String, Object> notificationData, int startMode, boolean hasForegroundServiceType, int foregroundServiceType) {
        if (notificationData instanceof HashMap) {
            this.notificationData = (HashMap<String, Object>) notificationData;
        } else {
            this.notificationData = new HashMap<String, Object>(notificationData);
        }
        this.startMode = startMode;
        this.hasForegroundServiceType = hasForegroundServiceType;
        this.foregroundServiceType = foregroundServiceType;
    }

    @Override
    public String toString() {
        return "StartParameter{" +
                "notificationData=" + notificationData +
                ", startMode=" + startMode +
                ", hasForegroundServiceType=" + hasForegroundServiceType +
                ", foregroundServiceType=" + foregroundServiceType +
                '}';
    }
}
