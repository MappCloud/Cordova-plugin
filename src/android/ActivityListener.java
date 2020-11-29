package com.mapp.cordova.plugin;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;

import com.appoxee.Appoxee;

public class ActivityListener extends Activity {


    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Intent intent = getIntent();
        Intent launchIntent = getDefaultActivityIntent();
        intent.putExtra("action", intent.getAction());
        launchIntent.setData(intent.getData());
        launchIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
        Appoxee.handleRichPush(this,intent);
        startActivity(launchIntent);
        finish();
    }


    private Intent getDefaultActivityIntent() {
        PackageManager packageManager = getPackageManager();
        return packageManager.getLaunchIntentForPackage(getPackageName());
    }

    @Override
    protected void onNewIntent(Intent intent) {
        Appoxee.handleRichPush(this,intent);
        super.onNewIntent(intent);
    }
}