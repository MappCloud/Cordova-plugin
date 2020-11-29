package com.mapp.cordova.plugin;

import android.content.SharedPreferences;

import com.appoxee.push.PushData;
import com.appoxee.push.PushDataReceiver;

import org.json.JSONObject;

public class MappPushListener extends PushDataReceiver {

    public static PushDataListener listener;
    private static final String TAG = "MappPushListener";


    @Override
    public void onPushReceived(PushData pushData) {
        if (listener != null)
            listener.onPushReceived(pushData);
        JSONObject payloadJson = MappPlugin.getPushMessageToJSon(pushData);
        SharedPreferences sp = MappPlugin.getAppoxeeCordovaSharedPrefs(context);
        sp.edit().putString(MappPlugin.APX_LAST_PUSH_KEY, payloadJson.toString()).apply();
        super.onPushReceived(pushData);

    }

    @Override
    public void onPushOpened(PushData pushData) {
        if (listener != null)
            listener.onPushOpened(pushData);
        super.onPushOpened(pushData);
    }

    @Override
    public void onPushDismissed(PushData pushData) {
        if (listener != null)
            listener.onPushDismissed(pushData);
        super.onPushDismissed(pushData);
    }

    @Override
    public void onSilentPush(PushData pushData) {
        if (listener != null)
            listener.onSilentPush(pushData);
        super.onSilentPush(pushData);
    }

    public void setOnSmsReceivedListener(PushDataListener context) {
        this.listener = context;
    }

}
