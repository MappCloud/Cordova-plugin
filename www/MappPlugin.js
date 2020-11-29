/*
 * Created by Aleksandar Marinkovic on 1/30/19.
 * Copyright (c) 2019 MAPP.
 */

var exec = require('cordova/exec');

function MappPlugin() {
}

/* proxy method for execution */

MappPlugin.callMappPlugin = function (successCallback, errorCallback, nativeFunctionName, args) {
    exec(
        successCallback,
        errorCallback,
        'MappPlugin',
        nativeFunctionName,
        args
    );
}

/* Initialization */

/*
 * Call this method as soon as possible in your app initialization procces in order to register the device and recieve push.
 * Method is required to be called on every app launch.
 * Notification methods (pushMessageReceived, richMessageReceived) we only be available after calling this method.
 * @param {string} sdkID - The SDK ID for your account.
 * @param {string} googleProjectId - The googleProjectId for your account.
 * @param {string} cepURL - The cepURL for your account.
 * @param {string} appID - The appID for you account.
 * @param {string} tenantID - The tenantID for your account.
 * @callback {string} successCallback - A json string with a response for this operation with information.
 * @callback {string} errorCallback - A json string with a response for this operation with information.
 */
MappPlugin.prototype.engage = function (sdkID, googleProjectId, server, appID, tenantID, successCallback, errorCallback) {

    MappPlugin.callMappPlugin(successCallback, errorCallback, 'engage', [sdkID, googleProjectId, server, appID, tenantID]);
}

/*
 * Get if the feature is enabled.
 * @callback {string} successCallback - A json string with a response for this operation with information.
 * @callback {string} errorCallback - A json string with a response for this operation with information.
 */
MappPlugin.prototype.isReady = function (successCallback, errorCallback) {

    MappPlugin.callMappPlugin(successCallback, errorCallback, 'isAppoxeeReadyCordova', []);
}

/* Alias */

/*
 * Set device alias.
 * @param {string} alias - A String to be identified as as the device alias
 * @callback {string} successCallback - A json string with a response for this operation with information.
 * @callback {string} errorCallback - A json string with a response for this operation with information.
 */
MappPlugin.prototype.setDeviceAlias = function (alias, successCallback, errorCallback) {

    MappPlugin.callMappPlugin(successCallback, errorCallback, 'setDeviceAliasWithCompletionHandlerCordova', [alias]);
}

/*
 * Get device alias.
 * @callback {string} successCallback - A json string with a response for this operation with information.
 * @callback {string} errorCallback - A json string with a response for this operation with information.
 */
MappPlugin.prototype.getAlias = function (successCallback, errorCallback) {

    MappPlugin.callMappPlugin(successCallback, errorCallback, 'getDeviceAliasWithCompletionHandlerCordova', []);
}

/*
 * Remove the alias associated with this device.
 * @callback {string} successCallback - A json string with a response for this operation with information.
 * @callback {string} errorCallback - A json string with a response for this operation with information.
 * TODO This is only for iOS
 */

MappPlugin.prototype.removeDeviceAlias = function (successCallback, errorCallback) {

    MappPlugin.callMappPlugin(successCallback, errorCallback, 'removeDeviceAliasWithCompletionHandlerCordova', []);
}

/* Device API */

/*
 * Get information assoiciated with this device.
 * @callback {string} successCallback - A json string with a response for this operation with information.
 * @callback {string} errorCallback - A json string with a response for this operation with information.
 */
MappPlugin.prototype.deviceInformation = function (successCallback, errorCallback) {

    MappPlugin.callMappPlugin(successCallback, errorCallback, 'deviceInformationWithCompletionHandlerCordova', []);
}

/* Inbox API */

/*
 * Get rich messages for this device.
 * @callback {string} successCallback - A json string with a response for this operation with information.
 * @callback {string} errorCallback - A json string with a response for this operation with information.
 */
MappPlugin.prototype.getRichMessages = function (successCallback, errorCallback) {

    MappPlugin.callMappPlugin(successCallback, errorCallback, 'getRichMessagesWithHandlerCordova', []);
}

/*
 * Delete a Rich Message.
 * @param {string} msgID - A string representing the message ID.
 * @callback {string} successCallback - A json string with a response for this operation with information.
 * @callback {string} errorCallback - A json string with a response for this operation with information.
 * TODO This is only for iOS
 */
MappPlugin.prototype.deleteRichMessage = function (msgID, successCallback, errorCallback) {

    MappPlugin.callMappPlugin(successCallback, errorCallback, 'deleteRichMessageWithHandlerCordova', [msgID]);
}

/*
 * Sync inbox messages with Appoxee Servers.
 * @callback {string} successCallback - A json string with a response for this operation with information.
 * @callback {string} errorCallback - A json string with a response for this operation with information.
 * TODO This is only for iOS
 */
MappPlugin.prototype.refreshInbox = function (successCallback, errorCallback) {

    MappPlugin.callMappPlugin(successCallback, errorCallback, 'refreshInboxWithCompletionHandlerCordova', []);
}



/* Tags API */

/*
 * Add and remove tags from device.
 * @param {Array} toAdd - An array of Strings ,that represent tags, to be added.
 * @param {Array} toRemove - An array of Strings, that represents tags, to be removed.
 * @callback {string} successCallback - A json string with a response for this operation with information.
 * @callback {string} errorCallback - A json string with a response for this operation with information.
 * TODO This is only for iOS
 */
MappPlugin.prototype.addTagsToDeviceAndRemove = function (toAdd, toRemove, successCallback, errorCallback) {

    MappPlugin.callMappPlugin(successCallback, errorCallback, 'addTagsToDeviceAndRemoveWithCompletionHandlerCordova', [toAdd, toRemove]);
}

/*
 * Remove a tag from device.
 * @param {Array} toRemove - An array of Strings ,that represent tags, to be removed.
 * @callback {string} successCallback - A json string with a response for this operation with information.
 * @callback {string} errorCallback - A json string with a response for this operation with information.
 */
MappPlugin.prototype.removeTagsFromDevice = function (toRemove, successCallback, errorCallback) {

    MappPlugin.callMappPlugin(successCallback, errorCallback, 'removeTagsFromDeviceWithCompletionHandlerCordova', [toRemove]);
}

/*
 * Add a tag to device.
 * @param {Array} toAdd - An array of Strings ,that represent tags, to be added.
 * @callback {string} successCallback - A json string with a response for this operation with information.
 * @callback {string} errorCallback - A json string with a response for this operation with information.
 */
MappPlugin.prototype.addTagsToDevice = function (toAdd, successCallback, errorCallback) {

    MappPlugin.callMappPlugin(successCallback, errorCallback, 'addTagsToDeviceWithCompletionHandlerCordova', [toAdd]);
}

/*
 * Get tags which are 'ON' for this device.
 * @callback {string} successCallback - A json string with a response for this operation with information.
 * @callback {string} errorCallback - A json string with a response for this operation with information.
 */
MappPlugin.prototype.fetchDeviceTags = function (successCallback, errorCallback) {

    MappPlugin.callMappPlugin(successCallback, errorCallback, 'fetchDeviceTagsCordova', []);
}

/*
 * Get the application tags defined at Appoxee. Note that only 'application tags' can be added as 'device tags'.
 * @callback {string} successCallback - A json string with a response for this operation with information.
 * @callback {string} errorCallback - A json string with a response for this operation with information.
 */
MappPlugin.prototype.fetchApplicationTags = function (successCallback, errorCallback) {

    MappPlugin.callMappPlugin(successCallback, errorCallback, 'fetchApplicationTagsCordova', []);
}

/* Push API */

/*
 * Get if the feature is enabled.
 * @callback {string} successCallback - A json string with a response for this operation with information.
 * @callback {string} errorCallback - A json string with a response for this operation with information.
 */
MappPlugin.prototype.isPushEnabled = function (successCallback, errorCallback) {

    MappPlugin.callMappPlugin(successCallback, errorCallback, 'isPushEnabledCordova', []);
}

/*
 * Method will disable / enable the feature.
 * @param {string} disable - a string with a value of "true" or "false".
 * @callback {string} successCallback - A json string with a response for this operation with information.
 * @callback {string} errorCallback - A json string with a response for this operation with information.
 */
MappPlugin.prototype.disablePushNotifications = function (disable, successCallback, errorCallback) {

    MappPlugin.callMappPlugin(successCallback, errorCallback, 'disablePushNotificationsWithCompletionHandlerCordova', [disable]);
}

/*
 * Method will show / hide notification when app is in foreground. Available for ios10 and above.
 * @param {string} show - a string with a value of "true" or "false".
 * @callback {string} successCallback - A json string with a response for this operation with information.
 * @callback {string} errorCallback - A json string with a response for this operation with information.
 * TODO this is only for iOS
 */
MappPlugin.prototype.showNotificationsOnForeground = function (show, successCallback, errorCallback) {

    MappPlugin.callMappPlugin(successCallback, errorCallback, 'showNotificationsOnForegroundCordova', [show]);
}

/*
 * Method sets the application badge number on iOS only, and only if notifications are approved.
 * @param {string} badgeNumber - a string with a value of an Integer, to set as the application badge number.
 * @callback {string} successCallback - A json string with a response for this operation with information.
 * @callback {string} errorCallback - A json string with a response for this operation with information.
 * TODO this is only for iOS
 */
MappPlugin.prototype.setApplicationBadgeNumber = function (badgeNumber, successCallback, errorCallback) {

    MappPlugin.callMappPlugin(successCallback, errorCallback, 'setApplicationBadgeNumberCordova', [badgeNumber]);
}

/* Custom Fields API */

/*
 * Set a date value for a key.
 * @param {string} key - A key to be paired with the value.
 * @param {string} value - A value which conforms 'yyyy-MM-dd hh:mm:ss'.
 * @callback {string} successCallback - A json string with a response for this operation with information.
 * @callback {string} errorCallback - A json string with a response for this operation with information.
 */
MappPlugin.prototype.setDateField = function (key, value, successCallback, errorCallback) {

    MappPlugin.callMappPlugin(successCallback, errorCallback, 'setDateFieldWithCompletionHandlerCordova', [key, value]);
}

/*
 * Set a number value for a key.
 * @param {string} key - A key to be paired with the value.
 * @param {string} value - A value which contains a number, i.e. "34", "34.54".
 * @callback {string} successCallback - A json string with a response for this operation with information.
 * @callback {string} errorCallback - A json string with a response for this operation with information.
 */
MappPlugin.prototype.setNumericField = function (key, value, successCallback, errorCallback) {

    MappPlugin.callMappPlugin(successCallback, errorCallback, 'setNumericFieldWithCompletionHandlerCordova', [key, value]);
}

/*
 * Set a string value for a key.
 * @param {string} key - A key to be paired with the value.
 * @param {string} value - A value which contains string.
 * @callback {string} successCallback - A json string with a response for this operation with information.
 * @callback {string} errorCallback - A json string with a response for this operation with information.
 */
MappPlugin.prototype.setStringField = function (key, value, successCallback, errorCallback) {

    MappPlugin.callMappPlugin(successCallback, errorCallback, 'setStringFieldWithCompletionHandlerCordova', [key, value]);
}

/*
 * Get a key-value pair for a givven key.
 * @param {string} key - A key paired with a value.
 * @callback {string} successCallback - A json string with a response for this operation with information.
 * @callback {string} errorCallback - A json string with a response for this operation with information.
 */
MappPlugin.prototype.fetchCustomFieldByKey = function (key, successCallback, errorCallback) {

    MappPlugin.callMappPlugin(successCallback, errorCallback, 'fetchCustomFieldByKeyWithCompletionHandlerCordova', [key]);
}

/* Notifications */

/*
 * Get last push payload. Method will only return the payload once.
 * @callback {string} successCallback - A json string with a response for this operation with information.
 * @callback {string} errorCallback - A json string with a response for this operation with information.
 */
MappPlugin.prototype.getLastPushPayload = function (successCallback, errorCallback) {

    MappPlugin.callMappPlugin(successCallback, errorCallback, 'getLastPushPayloadCordova', []);
}

/* Inbox Rich Content */

/*
 * Method is called when a rich message is received.
 * @param {string} jsonArg - A json string with the rich message payload.
 */
MappPlugin.prototype.richMessageReceived = function richMessageReceived(jsonArg) {

    console("Rich Message:\n" + jsonArg);

    /* Add your own implementation here. */
}

/*
 * Get last push payload. Method will return on push message event .
 * @callback {string} successCallback - A json string with a response for this operation with information.
 * @callback {string} errorCallback - A json string with a response for this operation with information.
 * TODO Android only
 */
MappPlugin.prototype.setOnPushMessageListener = function (successCallback, errorCallback) {

    MappPlugin.callMappPlugin(successCallback, errorCallback, 'setOnPushMessageListenerCordova', []);
}


/*
 * Set inApp event name.
 * @callback {string} successCallback - A json string with a response for this operation with information.
 * @callback {string} errorCallback - A json string with a response for this operation with information.
 */
MappPlugin.prototype.fireInAppEvent = function(event, successCallback, errorCallback) {

    MappPlugin.callMappPlugin(successCallback, errorCallback, 'fireInAppEventCordova', [event]);
}

/*
 * Orientation id number between -2 and 14 read more in documentation. need to be integer
 * @callback {string} successCallback - A json string with a response for this operation with information.
 * @callback {string} errorCallback - A json string with a response for this operation with information.
 * TODO Android only
 */
MappPlugin.prototype.lockScreenOrientation = function(orientationID, successCallback, errorCallback) {

    MappPlugin.callMappPlugin(successCallback, errorCallback, 'lockScreenOrientationCordova', [orientationID]);
}

/*
 * @callback {string} successCallback - A json string with a response for this operation with information.
 * @callback {string} errorCallback - A json string with a response for this operation with information.
 * TODO Android only
 */
MappPlugin.prototype.onActionListener = function(successCallback, errorCallback) {

    MappPlugin.callMappPlugin(successCallback, errorCallback, 'onActionListener');
}
/*
 * @callback {string} successCallback - A json string with a response for this operation with information.
 * @callback {string} errorCallback - A json string with a response for this operation with information.
 * TODO Android only
 */
MappPlugin.prototype.removeBadgeNumber = function(successCallback, errorCallback) {

    MappPlugin.callMappPlugin(successCallback, errorCallback, 'removeBadgeNumber');
}


/*
*Mapp Location
*
*/
MappPlugin.prototype.startGeo = function(successCallback, errorCallback) {
    MappPlugin.callMappPlugin(successCallback, errorCallback, 'enableLocationMonitoringCordova');
}

MappPlugin.prototype.stopGeo = function(successCallback, errorCallback) {
    MappPlugin.callMappPlugin(successCallback, errorCallback, 'disableLocationMonitoringCordova');
}

MappPlugin.prototype.fetchInboxMessages = function(successCallback, errorCallback){
	MappPlugin.callMappPlugin(successCallback, errorCallback, 'fetchInboxMessagesCordova',[]);
}

module.exports = new MappPlugin();
