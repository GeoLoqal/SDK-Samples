package com.geoloqal.com;


import java.util.ArrayList;

import com.geoloqal.com.data.ApplicationInfo;
import com.geoloqal.com.data.LocationData;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.IBinder;
import android.util.Log;
import android.widget.Toast;

public class GPSTracker extends Service implements LocationListener{
	
	private final Context context;
	 
    boolean isGPSEnabled = false;
 
    boolean isNetworkEnabled = false;
 
    boolean canGetLocation = false;
    Location location; 
    double latitude; 
    double longitude; 
 
    private static final long MIN_DISTANCE_CHANGE_FOR_UPDATES = 10;
 
    private static final long MIN_TIME_BW_UPDATES = 1000 * 60 * 1;
 
    protected LocationManager locationManager;
    
    private ArrayList<LocationData> locationDataArray = null;
 
    
	public GPSTracker(Context context){
		
		this.context = context;
		
		locationDataArray = new ArrayList<LocationData>();
	}

	public Location getLocation() {
		
        try {
            locationManager = (LocationManager)context.getSystemService(LOCATION_SERVICE);
                    
 
            isGPSEnabled = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER);
                    
 
            isNetworkEnabled = locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER);
                    
 
            if (!isGPSEnabled && !isNetworkEnabled) {
            	
                // no network provider is enabled
            	Toast.makeText(context, "No network Available", Toast.LENGTH_LONG).show();
            } 
            else {
                this.canGetLocation = true;
                
                if (isNetworkEnabled) {
                	
                    locationManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER,MIN_TIME_BW_UPDATES,MIN_DISTANCE_CHANGE_FOR_UPDATES, this);
                            
                    Log.d("Network", "Network");
                    
                    if (locationManager != null) 
                       {
                        location = locationManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER);
                                
                        if (location != null) {
                        	
                            latitude = location.getLatitude();
                            longitude = location.getLongitude();
                            System.out.println("latitude ::"+latitude+"longitude ::"+longitude);
                            
                        }
                    }
                }
                // if GPS Enabled get lat/long using GPS Services
                if (isGPSEnabled) {
                	
                    if (location == null) {
                    	
                        locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER,MIN_TIME_BW_UPDATES, MIN_DISTANCE_CHANGE_FOR_UPDATES, this);
                               
                        Log.d("GPS Enabled", "GPS Enabled");
                        
                        if (locationManager != null) {
                            location = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);
                                    
                            if (location != null) {
                                latitude = location.getLatitude();
                                longitude = location.getLongitude();
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
 
        return location;
    }
	
	@Override
	public IBinder onBind(Intent intent) {
		// TODO Auto-generated method stub
		return null;
	}

	public void onLocationChanged(Location location) {
		// TODO Auto-generated method stub
		
		
		latitude = location.getLatitude();
		longitude = location.getLongitude();
		
		
//		Toast.makeText(context, "Location Info  "+latitude+"  "+longitude, Toast.LENGTH_LONG).show();
		
		
		
	}

	public void onProviderDisabled(String provider) {
		// TODO Auto-generated method stub
		
	}

	public void onProviderEnabled(String provider) {
		// TODO Auto-generated method stub
		
	}

	public void onStatusChanged(String provider, int status, Bundle extras) {
		// TODO Auto-generated method stub
		
	}
	
	


}
