package com.geoloqal.android;


import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.os.Bundle;
import android.os.Handler;
import android.view.Window;

public class SpalshScreen extends Activity {
	
	
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.homepage);
       
       
       
		new Handler().postDelayed(new Runnable(){

			@Override
			public void run() {
				// TODO Auto-generated method stub
				
					Intent _intent = new Intent(SpalshScreen.this,CurrentLocationActivity.class);
					startActivity(_intent);
					SpalshScreen.this.finish();
				
				
			}
			
		}, 2000);
    }
}