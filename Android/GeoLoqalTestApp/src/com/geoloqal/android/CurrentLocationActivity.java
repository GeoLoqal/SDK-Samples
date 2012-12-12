package com.geoloqal.android;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Point;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.Toast;

import com.android.wheelpicker.ArrayWheelAdapter;
import com.android.wheelpicker.OnWheelChangedListener;
import com.android.wheelpicker.OnWheelScrollListener;
import com.android.wheelpicker.WheelView;
import com.geoloqal.com.GLLocationManager;
import com.geoloqal.com.data.GLLocation;
import com.geoloqal.com.data.TriggerData;
import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapActivity;
import com.google.android.maps.MapController;
import com.google.android.maps.MapView;
import com.google.android.maps.Overlay;

public class CurrentLocationActivity extends MapActivity implements LocationListener{
	
	private GLLocationManager _locationManager = null;
	private MapView _mapView =null;
	private LinearLayout _geoLocationTabLayout = null;
	private LinearLayout _geoTargetingTabLayout = null;
	private LinearLayout _startTestTabLayout = null;
	
	private ArrayList<String> _alltestCases;
	private ArrayList<TriggerData> _allTrigger;
	private ArrayList<String> _alltriggerName ;
	public  ArrayList<String> _alltestcaseName = null;
	
	public  JSONArray _testcasesJsonArray = null;
	
	private LocationManager _locationocationManager=null;
	private MapController mapController=null;
	private GeoPoint _geoPoint=null;
	
	private String testCaseName = null;
	private String triggerName =null;
	private String showallTestcases[]=null;
	private String showallTriggers[]=null;
	
	private static final int speed=10;
	
	private boolean wheelScrolled = false;
	private double _latitude;
	private double _longitude;
	
	private GLLocation location = null;
	
	private static int nextPointCount = 0;
	
	private Dialog dialog = null;
	
	
	@Override
	protected void onCreate(Bundle icicle) {
		// TODO Auto-generated method stub
		super.onCreate(icicle);
			requestWindowFeature(Window.FEATURE_NO_TITLE);
			setContentView(R.layout.location_service);
			getComponent();
		
	}
	
	private void getComponent(){
		
		 
		_geoLocationTabLayout = (LinearLayout)findViewById(R.id.geoLocationButton);
		_geoLocationTabLayout.setOnClickListener(new ClickListener());
    	
    	_startTestTabLayout = (LinearLayout)findViewById(R.id.startTestButton);
    	_startTestTabLayout.setOnClickListener(new ClickListener());

    	_startTestTabLayout.setEnabled(false);
    	
    	_geoTargetingTabLayout = (LinearLayout)findViewById(R.id.geoTargetingButton);
    	_geoTargetingTabLayout.setOnClickListener(new ClickListener());
    	
    	_alltestCases=new ArrayList<String>();
    	_allTrigger=new ArrayList<TriggerData>();
		
    	_alltestcaseName=new ArrayList<String>();
		 _alltriggerName = new ArrayList<String>();
		
		_mapView= (MapView) findViewById(R.id.theMap);
		_mapView.setClickable(true);
		_mapView.setBuiltInZoomControls(true);
		_mapView.setSatellite(false);
		_mapView.setStreetView(false);
		 mapController = _mapView.getController();
		 mapController.setZoom(15);
		 
		 _locationManager = new GLLocationManager(CurrentLocationActivity.this);
	     _locationManager.setApiKey("INSERT YOUR API KEY HERE");
	     _locationManager.setUnit("kph");
	     _locationManager.setOutPutType("json");
	     _locationManager.setSpeed(speed);

         
        _locationocationManager = (LocationManager) getSystemService(LOCATION_SERVICE);
        _locationocationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 1000, 100, this);
         getCurrentLocation();
        _geoPoint =new GeoPoint((int) (_latitude * 1E6),(int) (_longitude * 1E6));
         mapController.setCenter(_geoPoint);
        
         MapOverlay mapOverlay = new MapOverlay();
         List<Overlay> listOfOverlays = _mapView.getOverlays();
         listOfOverlays.clear();
         listOfOverlays.add(mapOverlay);  
	}
	
	private void showPointsonMap(GLLocation location){
		
		if(location!=null){
		     _geoPoint = new GeoPoint((int) (location.getLatitude() * 1E6),(int) (location.getLongitude() * 1E6));
		     mapController.setCenter(_geoPoint);
		     
		     MapOverlay mapOverlay = new MapOverlay();
		     List<Overlay> listOfOverlays = _mapView.getOverlays();
		     listOfOverlays.clear();
		     listOfOverlays.add(mapOverlay); 
		     _mapView.invalidate();
		}
		
		else{
			showDialog("Unable to find location");
		}
		
	}
	private void getCurrentLocation() {
		
    	Location location =	_locationocationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);
    	
    	if(location!=null){
    		
    		_latitude=location.getLatitude();
    		_longitude= location.getLongitude();
    		
			 String message = String.format("Current location \n Latitude: %1$s \n Longitude: %2$s",location.getLatitude(), location.getLongitude());
	        _geoPoint = new GeoPoint((int) (location.getLatitude() * 1E6), (int) (location.getLongitude() * 1E6));
	         mapController.setCenter(_geoPoint);
	        
	         MapOverlay mapOverlay = new MapOverlay();
		     List<Overlay> listOfOverlays = _mapView.getOverlays();
		     listOfOverlays.clear();
		     listOfOverlays.add(mapOverlay);  
		     _mapView.invalidate();
    	}

	}
	private class ClickListener implements OnClickListener{

		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub

			if(v == _geoLocationTabLayout){
/*Start-------------------Code block to get all testcases associated with your api-key-------------*/
				_alltestCases.clear();
				
//				 _mapView.setOnChangeListener(new MapViewChangeListener());
				_startTestTabLayout.setEnabled(true);
				
				_alltestCases=_locationManager.getTestCases();
				
				if(_alltestCases.size() != 0){
					
					System.out.println("_alltestCases"+_alltestCases);
					showallTestcases = _alltestCases.toArray(new String[_alltestCases.size()]);
					showTestCaseDialog();
					initWheelforTestcases(R.id.optionswheel);
				}
				else{
					
					showTestCaseDialog();
					
				}
				
				
/*End-------------------Code block to get all testcases associated with your api-key-------------*/	
				
			}
           else if(v == _startTestTabLayout){
        	  
 /*Start-------------------Code block to start test on the map with selected testcase-------------*/
        	  
   			   _locationManager.setNextCount(nextPointCount);
   			   
   			   if(testCaseName != null && triggerName == null){
   				   
   				location = _locationManager.registration(testCaseName);
   				
   				if(location != null){
   					
   					showPointsonMap(location);
   	   			    nextPointCount++;
   				}
    			   
   			    
   			   }
   			   else if(triggerName != null && testCaseName == null){
			    	
			    	showDialog("You have to associate a test case with this trigger");
			    }
   			   else if(testCaseName != null && triggerName != null){
   				   
   				     location = _locationManager.registration(testCaseName);
   				     
   				     if(location != null){
   				    	 
   				    	showPointsonMap(location);
        			     nextPointCount++;
      			    	
      			    	String status = _locationManager.checkGeoTrigger(triggerName, location.getLatitude(), location.getLongitude());
      			    	
      			    	if(status.equals("true")){
      			    		
      			    		showDialog("Trigger Matched");
      			    	}
   				    	 
   				     }
   				     
   			    	
   			    }
 /*End-------------------Code block to start test on the map with selected testcase-------------*/
           }
			else if(v == _geoTargetingTabLayout){
 /*Start-------------------Code block to check triggers----------------------------------*/
				_allTrigger.clear();
				
				_startTestTabLayout.setEnabled(true);
				
				_allTrigger=_locationManager.getTriggers();
				
				if(_allTrigger.size() != 0){
					
					for(int i = 0;i<_allTrigger.size();i++){
						 
						 if(_allTrigger.get(i).getTriggerName() != null){
							 
							 _alltriggerName.add(_allTrigger.get(i).getTriggerName());
							 showallTriggers= _alltriggerName.toArray(new String[_alltriggerName.size()]);
						 }
						
					 }
					showTriggerDialog();
					initWheelforTrigger(R.id.optionswheel);
				}
               else{
					
            	   showTriggerDialog();
					
				}
				
				
			}
		}
		 /*End-------------------Code block to check triggers-------------------------------------------*/
		
	}

	private class MapOverlay extends com.google.android.maps.Overlay
	{
	    @Override
	    public boolean draw(Canvas canvas, MapView mapView, 
	    boolean shadow, long when) 
	    {
	        super.draw(canvas, mapView, shadow);                   

	        Point screenPts = new Point();
	        mapView.getProjection().toPixels(_geoPoint, screenPts);

	        Bitmap bmp = BitmapFactory.decodeResource(
	            getResources(), R.drawable.geoloqal_pushpin);            
	        canvas.drawBitmap(bmp, screenPts.x, screenPts.y-50, null);         
	        return true;
	    }
	} 

	@Override
	public void onLocationChanged(Location location) {
		// TODO Auto-generated method stub
		    int latitude = (int) (location.getLatitude() * 1E6);
	        int longitude = (int) (location.getLongitude() * 1E6);
	        
	        _geoPoint = new GeoPoint(latitude, longitude);
	         mapController.setCenter(_geoPoint);
	        _mapView.invalidate();
		
	}

	@Override
	public void onProviderDisabled(String provider) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onProviderEnabled(String provider) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onStatusChanged(String provider, int status, Bundle extras) {
		// TODO Auto-generated method stub
		
	}
	@Override
	public void onBackPressed() {
		// TODO Auto-generated method stub
		super.onBackPressed();
		CurrentLocationActivity.this.finish();
	}
	
	OnWheelScrollListener scrolledListener = new OnWheelScrollListener()
	{
		@SuppressWarnings("unused")
		public void onScrollStarts(WheelView wheel)
			{
				wheelScrolled = true;
			}

		@SuppressWarnings("unused")
		public void onScrollEnds(WheelView wheel)
			{
				wheelScrolled = false;
			}

		@Override
		public void onScrollingStarted(WheelView wheel) {
			// TODO Auto-generated method stub
			
		}

		@Override
		public void onScrollingFinished(WheelView wheel) {
			// TODO Auto-generated method stub
			
		}
	};

	private final OnWheelChangedListener changedListener = new OnWheelChangedListener()
		{
			public void onChanged(WheelView wheel, int oldValue, int newValue)
				{
					if (!wheelScrolled)
						{
						}
				}
		};
	
	
	
	private void initWheelforTestcases(int id)
		{
			WheelView wheel = (WheelView)dialog.findViewById(id);
			wheel.setViewAdapter(new ArrayWheelAdapter(this,showallTestcases));
			wheel.setVisibleItems(2);
			wheel.setCurrentItem(0);
			wheel.addChangingListener(changedListener);
			wheel.addScrollingListener(scrolledListener);
		}
	
	private void initWheelforTrigger(int id)
	{
		WheelView wheel = (WheelView)dialog.findViewById(id);
		wheel.setViewAdapter(new ArrayWheelAdapter(this,showallTriggers));
		wheel.setVisibleItems(2);
		wheel.setCurrentItem(0);
		wheel.addChangingListener(changedListener);
		wheel.addScrollingListener(scrolledListener);
	}
	
	
	private WheelView getWheel(int id)
	   {
		
		return (WheelView)dialog.findViewById(id);
		
	   }


	@SuppressWarnings("unused")
	private int getWheelValue(int id)
		{
			return getWheel(id).getCurrentItem();
		}
    private void showTestCaseDialog(){
    	
        dialog = new Dialog(CurrentLocationActivity.this);
    	dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
		dialog.setContentView(R.layout.options_dialog);

		Button _setButton = (Button) dialog.findViewById(R.id.saveButton);
		_setButton.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				
//				if((int) getWheel(R.id.optionswheel).getCurrentItem() != 0){
					
					testCaseName = showallTestcases[(int) getWheel(R.id.optionswheel).getCurrentItem()];
//				}
				
				dialog.dismiss();
			}
		});
		Button _cancelButton = (Button) dialog.findViewById(R.id.cancelButton);
		_cancelButton.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				dialog.dismiss();
			}
		});
   
		dialog.show();
	  } 
    
    private void showTriggerDialog() {
		// TODO Auto-generated method stub
		dialog = new Dialog(CurrentLocationActivity.this);
    	dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
		dialog.setContentView(R.layout.options_dialog);

		Button _setButton = (Button) dialog.findViewById(R.id.saveButton);
		_setButton.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
//				if((int) getWheel(R.id.optionswheel).getCurrentItem() != 0){
					
					triggerName = showallTriggers[(int) getWheel(R.id.optionswheel).getCurrentItem()]; 
//				}
				
				dialog.dismiss();
			}
		});
		Button _cancelButton = (Button) dialog.findViewById(R.id.cancelButton);
		_cancelButton.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				dialog.dismiss();
			}
		});
   
		dialog.show();
	  
	}
      private void showDialog(String text){
	   	
	   	
	    AlertDialog.Builder _builder = new AlertDialog.Builder(CurrentLocationActivity.this);
	    _builder.setTitle("Message");
	    _builder.setMessage(text);
	    _builder.setPositiveButton("Ok", new DialogInterface.OnClickListener(){
	   		
	   		public void onClick(DialogInterface arg0, int arg1) {
	   		}
	   	});	 
	   	_builder.show();
	 }

	@Override
	protected boolean isRouteDisplayed() {
		// TODO Auto-generated method stub
		return false;
	}
}
