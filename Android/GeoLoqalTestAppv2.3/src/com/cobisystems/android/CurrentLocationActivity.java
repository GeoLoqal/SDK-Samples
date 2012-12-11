package com.cobisystems.android;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.view.View;
import android.view.Window;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.Toast;
import android.widget.ZoomButtonsController;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.ZoomButtonsController.OnZoomListener;

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
	private MyMapView _mapView =null;
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
	
	private int speed=0;
	private boolean wheelScrolled = false;
	private double _latitude;
	private double _longitude;
	
	private GLLocation location = null;
	
	private static int nextPointCount = 0;
	private int zoomlevel;
	
	private Dialog dialog = null;
	
//	private static final int TEST_CASES=1;
//	private static final int LATLONGSTATUS=2;
//	private static final int GETTRIGGER=3;
//	private static final int CHECKTRIGGER=4;
	
	
	@Override
	protected void onCreate(Bundle icicle) {
		// TODO Auto-generated method stub
		super.onCreate(icicle);
			requestWindowFeature(Window.FEATURE_NO_TITLE);
			setContentView(R.layout.location_service);
			getComponent();
		
	}
	
	private void getComponent(){
		
		 speed = 10;
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
		
		_mapView= (MyMapView) findViewById(R.id.theMap);
		_mapView.setClickable(true);
		_mapView.setBuiltInZoomControls(true);
		_mapView.setSatellite(false);
		_mapView.setStreetView(false);
//		_mapView.setTraffic(true);
		 mapController = _mapView.getController();
		 mapController.setZoom(15);
		 
		 
		 _mapView.setOnChangeListener(new MapViewChangeListener());
		 
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

	@Override
	protected boolean isRouteDisplayed() {
		// TODO Auto-generated method stub
		return false;
	}
	
	private class MapViewChangeListener implements MyMapView.OnChangeListener
	{

		@Override
		public void onChange(MapView view, GeoPoint newCenter, GeoPoint oldCenter, int newZoom, int oldZoom)
		{
			
		 if (newZoom != oldZoom)
			{
			    System.out.println("newZoom  "+newZoom +"old zoom "+oldZoom);
			    
			    mapController.setZoom(newZoom);
			    
				Toast.makeText(CurrentLocationActivity.this, "Map Zoom", Toast.LENGTH_SHORT).show();
//				Toast.makeText(CurrentLocationActivity.this, "newCenter"+newCenter, Toast.LENGTH_SHORT).show();
			}
		}	
	}
	private void showPointsonMap(GLLocation location){
		
		if(location!=null){
		     _geoPoint = new GeoPoint(
		             (int) (location.getLatitude() * 1E6), 
		             (int) (location.getLongitude() * 1E6));
		     mapController.setCenter(_geoPoint);
		     
		     MapOverlay mapOverlay = new MapOverlay();
		     List<Overlay> listOfOverlays = _mapView.getOverlays();
		     listOfOverlays.clear();
		     listOfOverlays.add(mapOverlay);  
		     _mapView.invalidate();
		}
		
		else{
			Toast.makeText(CurrentLocationActivity.this, "Unable to find location", Toast.LENGTH_LONG).show();
		}
		
	}
	private void getCurrentLocation() {
    	Location location =	_locationocationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);
    	if(location!=null){
    		_latitude=location.getLatitude();
    		_longitude= location.getLongitude();
			String message = String.format(
					"Current location \n Latitude: %1$s \n Longitude: %2$s",
					location.getLatitude(), location.getLongitude()
					);
	        _geoPoint = new GeoPoint(
		             (int) (location.getLatitude() * 1E6), 
		             (int) (location.getLongitude() * 1E6));
	        System.out.println("GeoPoint===="+_geoPoint);
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
				
				_alltestCases.clear();
				
//				 _mapView.setOnChangeListener(new MapViewChangeListener());
				_startTestTabLayout.setEnabled(true);
				 
				_geoLocationTabLayout.setBackgroundColor(Color.parseColor("#000000"));
				_startTestTabLayout.setBackgroundResource(R.drawable.custombottom);
				_geoTargetingTabLayout.setBackgroundResource(R.drawable.custombottom);
				
				_alltestCases=_locationManager.getTestCases();
				System.out.println("_alltestCases"+_alltestCases);
				showallTestcases = _alltestCases.toArray(new String[_alltestCases.size()]);
				showTestCaseDialog();
				initWheelforTestcases(R.id.optionswheel);
				
				
				
			}
           else if(v == _startTestTabLayout){
//        	   _mapView.setOnChangeListener(new MapViewChangeListener());
        	   
        	  
//    		   _startTestTabLayout.setBackgroundColor(Color.parseColor("#000000"));
        	   _geoLocationTabLayout.setBackgroundResource(R.drawable.custombottom);
   			   _geoTargetingTabLayout.setBackgroundResource(R.drawable.custombottom);
   			   _locationManager.setNextCount(nextPointCount);
   			   
   			   if(testCaseName != null && triggerName == null){
   				   
   				location = _locationManager.registration(testCaseName);
    			   
   			    showPointsonMap(location);
   			    nextPointCount++;
   			   }
   			   else if(triggerName != null && testCaseName == null){
			    	
			    	showDialog("You have to associate a test case with this trigger");
			    }
   			   else if(testCaseName != null && triggerName != null){
   				   
   				     location = _locationManager.registration(testCaseName);
   				     showPointsonMap(location);
     			     nextPointCount++;
   			    	
   			    	String status = _locationManager.checkGeoTrigger(triggerName, location.getLatitude(), location.getLongitude());
   			    	
   			    	if(status.equals("true")){
   			    		
   			    		showDialog("Trigger Matched");
   			    	}
   			    	
   			    }
           }
			else if(v == _geoTargetingTabLayout){
				
				_allTrigger.clear();
				
				_startTestTabLayout.setEnabled(true);
				_geoTargetingTabLayout.setBackgroundColor(Color.parseColor("#000000"));	
				_geoLocationTabLayout.setBackgroundResource(R.drawable.custombottom);
				_startTestTabLayout.setBackgroundResource(R.drawable.custombottom);
				
				
				_allTrigger=_locationManager.getTriggers();
				for(int i = 0;i<_allTrigger.size();i++){
					 
					 if(_allTrigger.get(i).getTriggerName() != null){
						 
						 _alltriggerName.add(_allTrigger.get(i).getTriggerName());
						 showallTriggers= _alltriggerName.toArray(new String[_alltriggerName.size()]);
					 }
					
				 }
				showTriggerDialog();
				initWheelforTrigger(R.id.optionswheel);
				
			}
		}

		
	}
	
//	private void getTestCases(){
//		
//		
//		Thread _thread = new Thread(){
//			
//			@Override
//			public void run() {
//				// TODO Auto-generated method stub
//				super.run();
//				
//				Looper.prepare();
//				
//					
//				
//				Message _message = new Message();
//				_message.what=TEST_CASES;
//				_handler.handleMessage(_message);
//				
//			}
//			
//			
//		};
//		Looper.loop();
//		_thread.start();
//		
//	}
//	
//	private Handler _handler = new Handler(){
//		
//		@Override
//		public void handleMessage(Message msg) {
//			// TODO Auto-generated method stub
//			super.handleMessage(msg);
//			
//			switch (msg.what) {
//			case TEST_CASES:
//				
//               
//				
//				break;
//
//			default:
//				break;
//			}
//		}
//	};
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
	            getResources(), R.drawable.geoloqallogo);            
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
				
				testCaseName = showallTestcases[(int) getWheel(R.id.optionswheel).getCurrentItem()]; 
//				 Toast.makeText(CurrentLocationActivity.this, ""+ testCaseName, Toast.LENGTH_SHORT).show();
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
				
				triggerName = showallTriggers[(int) getWheel(R.id.optionswheel).getCurrentItem()]; 
//				 Toast.makeText(CurrentLocationActivity.this, ""+ triggerName, Toast.LENGTH_SHORT).show();
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
}
