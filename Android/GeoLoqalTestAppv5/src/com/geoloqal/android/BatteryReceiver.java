package com.geoloqal.android;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.BatteryManager;
import android.util.Log;
import android.widget.Toast;

public class BatteryReceiver extends BroadcastReceiver {

	@Override
	public void onReceive(Context context, Intent intent) {
		// TODO Auto-generated method stub
		   context.unregisterReceiver(this);
		if (intent.getAction().equals(Intent.ACTION_BATTERY_CHANGED)){
			
			int level = intent.getIntExtra(BatteryManager.EXTRA_LEVEL, 0);
	        int scale = intent.getIntExtra(BatteryManager.EXTRA_SCALE, 100);
	        int percent = (level*100)/scale;

	        final String text = String.valueOf(percent) + "%";
	        
	        Toast.makeText(context, "Battery Level "+text, Toast.LENGTH_LONG).show();
		}

	}

}
