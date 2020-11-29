package com.mapp.cordova.plugin;

import java.util.HashMap;
import java.util.Map;

/**
 * Used for mapping of actions - js string names to enum.
 * This way we can use switch (and having constants for String names)
 */
public enum MappAction {

    INIT(ActionName.ENGAGE),
    GET_LAST_PUSH(ActionName.GET_LAST_PUSH),
    SET_ALIAS(ActionName.SET_ALIAS),
    GET_ALIAS(ActionName.GET_ALIAS),
    IS_READY(ActionName.IS_READY),
    GET_DEVICE_INFO(ActionName.GET_DEVICE_INFO),
    GET_INBOX_MESSAGES(ActionName.GET_INBOX_MESSAGES),
    ADD_TAGS(ActionName.ADD_TAGS),
    REMOVE_TAGS(ActionName.REMOVE_TAGS),
    GET_TAGS(ActionName.GET_TAGS),
    GET_APP_TAGS(ActionName.GET_APP_TAGS),
    IS_PUSH_ENABLED(ActionName.IS_PUSH_ENABLED),
    DISABLE_PUSH(ActionName.DISABLE_PUSH),
    GET_CUSTOM_FIELD(ActionName.GET_CUSTOM_FIELD),
    SET_CUSTOM_NUMERIC_FIELD(ActionName.SET_CUSTOM_NUMERIC_FIELD),
    SET_CUSTOM_STRING_FIELD(ActionName.SET_CUSTOM_STRING_FIELD),
    ON_PUSH_MESSAGE(ActionName.ON_PUSH_MESSAGE),
    SET_CUSTOM_DATE_FIELD(ActionName.SET_CUSTOM_DATE_FIELD),
    LOCK_SCREEN_ORIENTATION(ActionName.LOCK_SCREEN_ORIENTATION),
    SET_IN_APP_EVENT(ActionName.SET_IN_APP_EVENT),
    ON_ACTION_LISTENER(ActionName.ON_ACTION_LISTENER),
    REMOVE_BADGE_NUMBER(ActionName.REMOVE_BADGE_NUMBER),
    ENABLE_LOCATION(ActionName.ENABLE_LOCATION),
    DISABLE_LOCATION(ActionName.DISABLE_LOCATION);
    //DISABLE_INBOX(ActionName.DISABLE_INBOX),
    //IS_SOUND_ENABLED(ActionName.IS_SOUND_ENABLED),
//  DISABLE_SOUND(ActionName.DISABLE_SOUND),
//  INCREMENT_CUSTOM_NUMERIC_FIELD(ActionName.INCREMENT_CUSTOM_NUMERIC_FIELD),
    //NO-OP:
//    DISABLE_QUITE_TIME(ActionName.DISABLE_QUITE_TIME),
//    REMOVE_ALIAS(ActionName.REMOVE_ALIAS),
//    SHOW_MORE_APPS(ActionName.SHOW_MORE_APPS),
//    SHOW_FEEDBACK(ActionName.SHOW_FEEDBACK),
//    SET_QUITE_TIME(ActionName.SET_QUITE_TIME);

    private static Map<String, MappAction> actionsMapping = new HashMap<String, MappAction>();
    private final String name;

    MappAction(String name) {
        this.name = name;
    }

    //static block
    static {
        for (MappAction action : MappAction.values()) {
            actionsMapping.put(action.name, action);
        }

    }

    public static MappAction getActionByName(String name) {
        return actionsMapping.get(name);
    }

    public static class ActionName {
        public static final String ENGAGE = "engage";
        public static final String GET_LAST_PUSH = "getLastPushPayloadCordova";

        public static final String SET_ALIAS = "setDeviceAliasWithCompletionHandlerCordova";
        public static final String GET_ALIAS = "getDeviceAliasWithCompletionHandlerCordova";


        public static final String IS_READY = "isAppoxeeReadyCordova";
        public static final String GET_DEVICE_INFO = "deviceInformationWithCompletionHandlerCordova";
        public static final String GET_INBOX_MESSAGES = "fetchInboxMessagesCordova";


        public static final String ADD_TAGS = "addTagsToDeviceWithCompletionHandlerCordova";
        public static final String REMOVE_TAGS = "removeTagsFromDeviceWithCompletionHandlerCordova";
        public static final String GET_TAGS = "fetchDeviceTagsCordova";
        public static final String GET_APP_TAGS = "fetchApplicationTagsCordova";
        public static final String IS_PUSH_ENABLED = "isPushEnabledCordova";
        public static final String DISABLE_PUSH = "disablePushNotificationsWithCompletionHandlerCordova";
        public static final String GET_CUSTOM_FIELD = "fetchCustomFieldByKeyWithCompletionHandlerCordova";
        public static final String SET_CUSTOM_NUMERIC_FIELD = "setNumericFieldWithCompletionHandlerCordova";
        public static final String SET_CUSTOM_STRING_FIELD = "setStringFieldWithCompletionHandlerCordova";
        public static final String SET_CUSTOM_DATE_FIELD = "setDateFieldWithCompletionHandlerCordova";
        public static final String ON_PUSH_MESSAGE = "setOnPushMessageListenerCordova";
        public static final String SET_IN_APP_EVENT = "fireInAppEventCordova";
        public static final String LOCK_SCREEN_ORIENTATION = "lockScreenOrientationCordova";
        public static final String ON_ACTION_LISTENER = "onActionListener";
        public static final String REMOVE_BADGE_NUMBER = "removeBadgeNumber";
        public static final String ENABLE_LOCATION = "enableLocationMonitoringCordova";
        public static final String DISABLE_LOCATION = "disableLocationMonitoringCordova";

        //  public static final String DISABLE_INBOX = "disableInboxWithCompletionHandlerCordova";
        //  public static final String IS_SOUND_ENABLED = "isPushSoundEnabledCordova";
        // public static final String DISABLE_SOUND = "disablePushSoundWithCompletionHandlerCordova";
        //public static final String DISABLE_QUITE_TIME = "disableQuietTimeWithCompletionHandlerCordova";
        //public static final String SET_QUITE_TIME = "quietTimeTimeRangeWithCompletionHandlerCordova";
        //public static final String DISABLE_QUITE_TIME = "disableQuietTimeWithCompletionHandlerCordova";
        //public static final String SET_QUITE_TIME = "quietTimeTimeRangeWithCompletionHandlerCordova";
        // public static final String REFRESH_INBOX_MESSAGES = "refreshInboxWithCompletionHandlerCordova";
        // public static final String DELETE_MESSAGE = "deleteRichMessageWithHandlerCordova";
        //public static final String SHOW_MORE_APPS = "showMoreAppsWithCompletionHandlerCordova";
        //public static final String SHOW_FEEDBACK = "showFeedbackWithCompletionHandlerCordova";
    }

}
