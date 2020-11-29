package com.mapp.cordova.plugin;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.appoxee.Appoxee;
import com.appoxee.AppoxeeOptions;
import com.appoxee.DeviceInfo;
import com.appoxee.internal.inapp.model.APXInboxMessage;
import com.appoxee.internal.inapp.model.ApxInAppExtras;
import com.appoxee.internal.inapp.model.InAppInboxCallback;
import com.appoxee.push.PushData;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;


public class MappPlugin extends CordovaPlugin {

    private static final String TAG = "AppoxeeCordovaPlugin";
    private boolean runningQOrLater = Build.VERSION.SDK_INT >= 29;
    private static final String APPOXEE_CORDOVA_SHARED_PREFS = "ApxCordovaPlugin";
    public static final String APX_LAST_PUSH_KEY = "MappPlugin.APX_LAST_PUSH_KEY";
    private MappPushListener mappPushListener;
    private CallbackContext callbackContextAction;
    private static final int MY_PERMISSIONS_ACCESS_FINE_LOCATION = 1 << 3;
    private static final int MY_PERMISSIONS_ACCESS_FINE_AND_BACKGROUND_LOCATION = 1 << 4;

    public MappPlugin() {
        //for reflection{


    }

    @Override
    public void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        String string = intent.getStringExtra("action");

        Uri uri = intent.getData();
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.put("action", string);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        if (uri != null) {
            String link = uri.getQueryParameter("link");
            String messageId = uri.getQueryParameter("message_id");

            try {
                jsonObject.put("messageId", messageId);
                jsonObject.put("link", link);
                jsonObject.put("uri", uri);
            } catch (JSONException e) {
                e.printStackTrace();
            }


        }


        if (callbackContextAction != null) {
            callbackContextAction.success(jsonObject);
        }


    }


    @Override
    public void onStart() {

    }

    @Override
    public void onStop() {
        super.onStop();
    }

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        cordova.getActivity().getIntent();
    }

    CallbackContext callbackContext;

    @Override
    public boolean execute(final String actionName, final JSONArray args, final CallbackContext callbackContext) throws JSONException {

        final MappAction action = MappAction.getActionByName(actionName);
        if (action == null) {   //invalid action
            return false;
        }
        Log.d(TAG, "action: " + actionName);
        String strParam1 = null;
        String strParam2 = null;
        boolean booleanParam = false;
        ArrayList<String> tags = null;
        int intParam = 0;

        //extract fields
        try {
            switch (action) {

                //2 strings (continue to next case on purpose!)
                case INIT:
                case SET_CUSTOM_DATE_FIELD:
                case SET_CUSTOM_STRING_FIELD:
                    strParam2 = args.getString(1);

                    //1 string
                case SET_ALIAS:
                case GET_CUSTOM_FIELD:
                    strParam1 = args.getString(0);
                    break;
                case ADD_TAGS:
                case REMOVE_TAGS:
                    JSONArray strArrayJson = args.getJSONArray(0);
                    tags = toStringArray(strArrayJson);
                    break;
                case SET_CUSTOM_NUMERIC_FIELD:
                    strParam1 = args.getString(0);
                    intParam = args.getInt(1);
                    break;
                case DISABLE_PUSH:
                    booleanParam = args.getBoolean(0);
                    break;
                //no params
                case GET_ALIAS:
                case GET_DEVICE_INFO:
                case GET_INBOX_MESSAGES:
                case IS_PUSH_ENABLED:
                case GET_TAGS:
                case GET_APP_TAGS:
                case GET_LAST_PUSH:
                case IS_READY:

                    break;
                case SET_IN_APP_EVENT:
                    strParam1 = args.getString(0);
                    break;
            }
        } catch (JSONException e) {
            Log.e(TAG, "illegal params");
            e.printStackTrace();
            return false;
        }

        switch (action) {
            case IS_READY: {
                boolean isReady = isReady();
                callbackContext.success(Boolean.toString(isReady));
                break;
            }

            case INIT: {
                final String sdkKey = strParam1;
                final String sdkSecret = strParam2;
                final Activity activity = cordova.getActivity();
                final String activityName = activity.getClass().getName();


                // MappPlugin.PluginCallback observer = new MappPlugin.PluginCallback(callbackContext);


                //  MappPlugin.PluginCallback observer = new MappPlugin.PluginCallback(callbackContext);
                AppoxeeOptions appoxeeOptions = new AppoxeeOptions();
                appoxeeOptions.sdkKey = strParam1;
                appoxeeOptions.googleProjectId = strParam2;
                appoxeeOptions.server = AppoxeeOptions.Server.valueOf(args.getString(2));
                appoxeeOptions.appID = args.getString(3);
                appoxeeOptions.tenantID = args.getString(4);
                appoxeeOptions.cepURL = "https://jamie-test.shortest-route.com";
                Appoxee.engage(cordova.getActivity().getApplication(), appoxeeOptions);
                Appoxee.instance().setReceiver(MappPushListener.class);
                //    Appoxee.onStart();
//                if (isReady()) {
//                    callbackContext.success();
//                }
                Appoxee.instance().addInitListener(new Appoxee.OnInitCompletedListener() {
                    @Override
                    public void onInitCompleted(boolean b, Exception e) {
                        if (b)
                            callbackContext.success();
                        else
                            callbackContext.error("Initialization failed");
                    }
                });
                break;
            }

            case ON_PUSH_MESSAGE: {

                this.callbackContext = callbackContext;
                mappPushListener = new MappPushListener();
                mappPushListener.setOnSmsReceivedListener(new PushDataListener() {

                    @Override
                    public void onPushReceived(PushData pushData) {
                        if (callbackContext != null) {
                            JSONObject jsonObject = getPushMessageToJSon(pushData);
                            try {
                                jsonObject.put("messageHandlerType", "onPushReceived");
                            } catch (Exception e) {
                                e.printStackTrace();
                            }

                            callbackContext.success(jsonObject);
                        }

                    }

                    @Override
                    public void onPushOpened(PushData pushData) {
                        if (callbackContext != null) {
                            JSONObject jsonObject = getPushMessageToJSon(pushData);
                            try {
                                jsonObject.put("messageHandlerType", "onPushOpened");
                            } catch (Exception e) {
                                e.printStackTrace();
                            }

                            callbackContext.success(jsonObject);
                        }
                    }

                    @Override
                    public void onPushDismissed(PushData pushData) {
                        if (callbackContext != null) {
                            JSONObject jsonObject = getPushMessageToJSon(pushData);
                            try {
                                jsonObject.put("messageHandlerType", "onPushDismissed");
                            } catch (Exception e) {
                                e.printStackTrace();
                            }

                            callbackContext.success(jsonObject);
                        }
                    }

                    @Override
                    public void onSilentPush(PushData pushData) {
                        if (callbackContext != null) {
                            JSONObject jsonObject = getPushMessageToJSon(pushData);
                            try {
                                jsonObject.put("messageHandlerType", "onSilentPush");
                            } catch (Exception e) {
                                e.printStackTrace();
                            }

                            callbackContext.success(jsonObject);
                        }
                    }
                });


                break;
            }

            case SET_CUSTOM_NUMERIC_FIELD: {
                Appoxee.instance().setAttribute(strParam1, intParam);
                break;
            }
            case SET_CUSTOM_DATE_FIELD:

                //Cheking for space character and creating a new date string with 'T' to match ISODate.
                int index = strParam2.indexOf(' ');
                String dateAsString = "";
                if (index != -1) {
                    dateAsString = strParam2.substring(0, index) + "T" + strParam2.substring(index + 1);
                } else {
                    dateAsString = strParam2;
                }

                final String pattern = "yyyy-MM-dd'T'HH:mm:ss";
                final SimpleDateFormat sdf = new SimpleDateFormat(pattern);
                Date d = null;
                try {
                    d = sdf.parse(dateAsString);
                    Log.d(TAG, "String is Date formatted");
                } catch (Exception e) {
                    Log.d(TAG, "String is Not Date formatted");
                    e.printStackTrace();
                }
                if (d != null) {
                    Appoxee.instance().setAttribute(strParam1, dateAsString);
                }
                d = null;
                break;

            case SET_CUSTOM_STRING_FIELD:
                Appoxee.instance().setAttribute(strParam1, strParam2);
                break;
            case ADD_TAGS: {
                JSONArray messagesJson = new JSONArray();
                if (tags != null) {
                    for (String msg : tags) {
                        Appoxee.instance().addTag(msg);
                        messagesJson.put(msg);
                    }
                }
                callbackContext.success(messagesJson);
                break;
            }
            case REMOVE_TAGS: {
                JSONArray messagesJson = new JSONArray();
                if (tags != null) {
                    for (String msg : tags) {
                        Appoxee.instance().removeTag(msg);
                        messagesJson.put(msg);
                    }
                }
                callbackContext.success(messagesJson);
                break;
            }
            case DISABLE_PUSH: {
                Appoxee.instance().setPushEnabled(!booleanParam);
                break;
            }
            case GET_ALIAS: {
                String alias = Appoxee.instance().getAlias();
                callbackContext.success(alias);
                break;
            }
            case GET_INBOX_MESSAGES: {
                Appoxee.instance().fetchInboxMessages(cordova.getActivity());

                InAppInboxCallback inAppInboxCallback = new InAppInboxCallback();
                inAppInboxCallback.addInAppInboxMessagesReceivedCallback(new InAppInboxCallback.onInAppInboxMessagesReceived() {
                    @Override
                    public void onInAppInboxMessages(List<APXInboxMessage> richMessages) {
                        Log.d("messages", "messages = " + richMessages.get(0).getContent());
                        JSONArray messagesJson = new JSONArray();

                        for (APXInboxMessage msg : richMessages) {
                            messagesJson.put(messageToJson(msg));
                        }
                        callbackContext.success(messagesJson);


                        //DataStore.getInstance().getUser().setApxInboxMessageArrayList(richMessages);

                    }

                    @Override
                    public void onInAppInboxMessage(final APXInboxMessage message) {
                        JSONObject jsonObject = messageToJson(message);
                        try {
                            jsonObject.put("messageHandlerType", "singleMessage");
                        } catch (Exception e) {
                            e.printStackTrace();
                        }

                        callbackContext.success(jsonObject);
                    }
                });


                break;
            }

            case IS_PUSH_ENABLED: {
                boolean isPushEnabled = Appoxee.instance().isPushEnabled();
                callbackContext.success(Boolean.toString(isPushEnabled));
                break;
            }

            case GET_TAGS: {
                Set<String> deviceTags = Appoxee.instance().getTags();
                JSONArray tagsJson = new JSONArray();
                if (deviceTags != null) {
                    for (String tag : deviceTags) {
                        tagsJson.put(tag);
                    }
                }
                callbackContext.success(tagsJson);
                break;
            }
            case GET_APP_TAGS: {
                Set<String> appTags = Appoxee.instance().getTags();
                JSONArray tagsJson = new JSONArray();
                if (appTags != null) {
                    for (String tag : appTags) {
                        tagsJson.put(tag);
                    }
                }
                callbackContext.success(tagsJson);
                break;
            }
            case GET_CUSTOM_FIELD: {
                ArrayList<String> attr = new ArrayList<String>();
                attr.add(strParam1);
                String fieldValue = Appoxee.instance().getAttributeStringValue(strParam1);
                if (fieldValue != null) {
                    callbackContext.success(fieldValue);
                } else {
                    callbackContext.error("no such field");
                }
                break;
            }
            case GET_DEVICE_INFO: {
                JSONObject deviceInfo = getDeviceInfoJson(Appoxee.instance().getDeviceInfo());
                callbackContext.success(deviceInfo);
                break;
            }

            case GET_LAST_PUSH: {
                callbackContext.success(getLastPushPayloadCordova(cordova.getActivity()));
                break;
            }


            case SET_IN_APP_EVENT: {
                Appoxee.instance().triggerDMCCallInApp(cordova.getActivity(), strParam1);
                callbackContext.success();
                break;
            }
            case LOCK_SCREEN_ORIENTATION: {
                try {
                    int param = args.getInt(0);
                    if (param > -2 && param < 14) {
                        Appoxee.setOrientation(cordova.getActivity().getApplication(), param);
                        callbackContext.success();
                    } else {
                        callbackContext.error("Bad config");
                    }
                } catch (Exception e) {
                    callbackContext.error(e.getMessage());
                }
            }

            case SET_ALIAS: {
                Appoxee.instance().setAlias(strParam1 /* alias */);
                break;
            }
            case ON_ACTION_LISTENER: {
                callbackContextAction = callbackContext;
            }
            break;
            case REMOVE_BADGE_NUMBER: {
                Appoxee.removeBadgeNumber(cordova.getActivity().getApplication());
            }
            break;
            case ENABLE_LOCATION: {
                startGeo();
            }
            break;
            case DISABLE_LOCATION: {
                Appoxee.instance().stopGeoFencing();
            }
            break;
            default:
                Log.d("Appoxee SDK", "bad action");
        }


        return true;
    }

    private String getLastPushPayloadCordova(Context context) {

        SharedPreferences sharedPrefs = getAppoxeeCordovaSharedPrefs(context);
        String lastPush = sharedPrefs.getString(APX_LAST_PUSH_KEY, "");
        sharedPrefs.edit().putString(APX_LAST_PUSH_KEY, "").apply();
        return lastPush;
    }

    private boolean isReady() {
        if (Appoxee.instance() != null)
            return Appoxee.instance().isReady();
        return false;
    }

    private JSONObject messageToJson(APXInboxMessage msg) {
        JSONObject msgJson = new JSONObject();

        try {
            msgJson.put("templateId", msg.getTemplateId());
            msgJson.put("title", msg.getContent());
            msgJson.put("eventId", msg.getEventId());
            msgJson.put("expirationDate", msg.getExpirationDate().toString());
            if (msg.getIconUrl() != null)
                msgJson.put("iconURl", msg.getIconUrl());
            if (msg.getStatus() != null)
                msgJson.put("status", msg.getStatus());
            if (msg.getSubject() != null)
                msgJson.put("subject", msg.getSubject());
            if (msg.getSummary() != null)
                msgJson.put("summary", msg.getSummary());
            if (msg.getContent() != null)
                msgJson.put("content", msg.getContent());
            if (msg.getExtras() != null)
                for (ApxInAppExtras apxInAppExtras : msg.getExtras())
                    msgJson.put(apxInAppExtras.getName(), apxInAppExtras.getValue());


        } catch (JSONException e) {
            e.printStackTrace();
        }

        return msgJson;
    }

    private void nop() {
        Log.i(TAG, "No Operation");
    }

    private ArrayList<String> toStringArray(JSONArray strArrayJson) {
        ArrayList<String> stringArray = new ArrayList<String>();
        if (strArrayJson == null) {
            return stringArray;
        }

        int length = strArrayJson.length();
        for (int i = 0; i < length; i++) {
            stringArray.add(strArrayJson.optString(i));
        }
        return stringArray;
    }

    private JSONObject getDeviceInfoJson(DeviceInfo deviceInfoList) {
        JSONObject deviceInfo = new JSONObject();
        try {
            deviceInfo.put("id", deviceInfoList.id);
            deviceInfo.put("appVersion", deviceInfoList.appVersion);
            deviceInfo.put("sdkVersion", deviceInfoList.sdkVersion);
            deviceInfo.put("locale", deviceInfoList.locale);
            deviceInfo.put("timezone", deviceInfoList.timezone);
            deviceInfo.put("deviceModel", deviceInfoList.deviceModel);
            deviceInfo.put("manufacturer", deviceInfoList.manufacturer);
            deviceInfo.put("osVersion", deviceInfoList.osVersion);
            deviceInfo.put("resolution", deviceInfoList.resolution);
            deviceInfo.put("density", deviceInfoList.density);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return deviceInfo;
    }


    public static JSONObject getPushMessageToJSon(PushData pushData) {
        JSONObject deviceInfo = new JSONObject();
        try {
            deviceInfo.put("id", pushData.id);
            deviceInfo.put("title", pushData.title);
            deviceInfo.put("bigText", pushData.bigText);
            deviceInfo.put("sound", pushData.sound);
            if (pushData.actionUri != null)
                deviceInfo.put("actionUri", pushData.actionUri.toString());
            deviceInfo.put("collapseKey", pushData.collapseKey);
            deviceInfo.put("badgeNumber", pushData.badgeNumber);
            deviceInfo.put("silentType", pushData.silentType);
            deviceInfo.put("silentData", pushData.silentData);
            deviceInfo.put("category", pushData.category);
            if (pushData.extraFields != null)
                for (Map.Entry<String, String> entry : pushData.extraFields.entrySet()) {
                    String key = entry.getKey();
                    String value = entry.getValue();
                    deviceInfo.put(key, value);
                    // do what you have to do here
                    // In your case, another loop.
                }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return deviceInfo;
    }

    public static SharedPreferences getAppoxeeCordovaSharedPrefs(Context context) {
        return context.getSharedPreferences(APPOXEE_CORDOVA_SHARED_PREFS, Context.MODE_PRIVATE);
    }


    private void startGeo() {
        if (isGeoPermissionGranted()) {
            Appoxee.instance().startGeoFencing();
        } else {
            if (runningQOrLater) {
                askForGeoPermissionWithBackgroundLocation();
            } else {
                askForGeoPermission();
            }
        }
    }

    private boolean isGeoPermissionGranted() {
        if (runningQOrLater) {
            return ContextCompat.checkSelfPermission(this.cordova.getActivity(), Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED
                    && ContextCompat.checkSelfPermission(this.cordova.getActivity(), Manifest.permission.ACCESS_BACKGROUND_LOCATION) == PackageManager.PERMISSION_GRANTED;
        } else {
            return ContextCompat.checkSelfPermission(this.cordova.getActivity(), Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED;
        }
    }

    private void askForGeoPermission() {
        cordova.requestPermissions(this,MY_PERMISSIONS_ACCESS_FINE_LOCATION, new String[]{
                        Manifest.permission.ACCESS_FINE_LOCATION,
                }
        );
    }

    private void askForGeoPermissionWithBackgroundLocation() {
        boolean permissionAccessFineLocationApproved =
                ContextCompat.checkSelfPermission(this.cordova.getActivity(), Manifest.permission.ACCESS_FINE_LOCATION)
                        == PackageManager.PERMISSION_GRANTED;

        if (permissionAccessFineLocationApproved) {
            boolean backgroundLocationPermissionApproved =
                    ContextCompat.checkSelfPermission(this.cordova.getActivity(),
                            Manifest.permission.ACCESS_BACKGROUND_LOCATION)
                            == PackageManager.PERMISSION_GRANTED;

            if (backgroundLocationPermissionApproved) {

            } else {
                cordova.requestPermissions(this,MY_PERMISSIONS_ACCESS_FINE_AND_BACKGROUND_LOCATION, new String[]{
                        Manifest.permission.ACCESS_BACKGROUND_LOCATION}
                );
            }
        } else {
            cordova.requestPermissions(this,MY_PERMISSIONS_ACCESS_FINE_AND_BACKGROUND_LOCATION, new String[]{
                            Manifest.permission.ACCESS_FINE_LOCATION,
                            Manifest.permission.ACCESS_BACKGROUND_LOCATION
                    }
            );
        }
    }

    @Override
    public void onRequestPermissionResult(int requestCode, String[] permissions, int[] grantResults) throws JSONException {

        if (MY_PERMISSIONS_ACCESS_FINE_LOCATION == requestCode) {
            if (grantResults.length > 0
                    && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                Appoxee.instance().startGeoFencing();
                // Log.w("MainActivity", "startGeoFencing()");
            }

        } else if (MY_PERMISSIONS_ACCESS_FINE_AND_BACKGROUND_LOCATION == requestCode) {
            if (grantResults.length > 0 && permissions.length == 1 && permissions[0].contains("android.permission.ACCESS_BACKGROUND_LOCATION")
                    && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                Appoxee.instance().startGeoFencing();
                //  Log.w("MainActivity", "startGeoFencing()with background");
            } else if (grantResults.length > 0 && permissions.length == 1 && permissions[0].contains("android.permission.ACCESS_BACKGROUND_LOCATION")
                    && grantResults[0] == PackageManager.PERMISSION_DENIED) {
                Appoxee.instance().startGeoFencing();
                //   Log.w("MainActivity", "startGeoFencing()with foreground");
            } else if (grantResults.length > 0 && permissions.length == 2 && grantResults[1] == PackageManager.PERMISSION_GRANTED) {
                Appoxee.instance().startGeoFencing();
                //  Log.w("MainActivity", "startGeoFencing() with background");
            } else if (grantResults.length > 0 && permissions.length == 2 && grantResults[0] == PackageManager.PERMISSION_GRANTED &&
                    grantResults[1] == PackageManager.PERMISSION_DENIED) {
                Appoxee.instance().startGeoFencing();
                //   Log.w("MainActivity", "startGeoFencing() with foreground");
            }

        }

    }


}

