package com.mapp.cordova.plugin;

import com.appoxee.push.PushData;

/**
 * Created by Aleksandar Marinkovic on 1/21/19.
 * Copyright (c) 2019 MAPP.
 */
public interface PushDataListener {
   void onPushReceived(PushData pushData);
   void onPushOpened(PushData pushData);
   void onPushDismissed(PushData pushData);
   void onSilentPush(PushData pushData);
}
