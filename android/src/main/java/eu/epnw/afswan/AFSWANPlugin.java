package eu.epnw.afswan;

import android.content.Context;
import android.content.Intent;
import android.os.Build;

import androidx.annotation.NonNull;

import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * AndroidForegroundServiceWithAwesomeNotificationsPlugin
 */
public class AFSWANPlugin implements FlutterPlugin, MethodCallHandler {
    private MethodChannel channel;
    private Context context;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        context = flutterPluginBinding.getApplicationContext();
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "eu.epnw.afswan");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("startForeground")) {
            Map<String, Object> notificationData = call.<Map<String, Object>>argument("notificationData");
            Integer startType = call.<Integer>argument("startType");
            Boolean hasForegroundServiceType = call.<Boolean>argument("hasForegroundServiceType");
            Integer foregroundServiceType = call.<Integer>argument("foregroundServiceType");
            if (notificationData != null && startType != null && hasForegroundServiceType != null && foregroundServiceType != null) {
                StartParameter parameter = new StartParameter(notificationData, startType, hasForegroundServiceType, foregroundServiceType);
                Intent intent = new Intent(context, ForegroundService.class);
                intent.putExtra(StartParameter.EXTRA, parameter);
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    context.startForegroundService(intent);
                } else {
                    context.startService(intent);
                }
                result.success(null);
            } else {
                result.error("ARGUMENT_ERROR", "An argument passed to startForeground was null!", null);
            }
        } else if (call.method.equals("stopForeground")) {
            context.stopService(new Intent(context, ForegroundService.class));
            result.success(null);
        } else {
            result.notImplemented();
        }

    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
