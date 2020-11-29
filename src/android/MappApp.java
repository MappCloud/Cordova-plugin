package com.mapp.cordova.plugin;

import android.app.Application;

import android.content.pm.ActivityInfo;
import android.util.Log;

import com.appoxee.Appoxee;
import com.appoxee.AppoxeeOptions;
import com.appoxee.DeviceInfo;


public class MappApp extends Application {

    @Override
    public void onCreate() {
        super.onCreate();
        Appoxee.engage(this);
    }

}
