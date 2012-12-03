package com.cobisystems.geolocalsdk;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geoloqal.com.GLLocationManager;
import com.geoloqal.com.data.ApplicationInfo;
import com.geoloqal.com.data.GLLocation;
import com.geoloqal.com.data.TriggerData;



import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;

import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.Window;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.Spinner;
import android.widget.AdapterView.OnItemSelectedListener;

public class MainActivity extends Activity {

	private GLLocationManager _locationManager = null;
	
	private LinearLayout _spinnerLayout = null;
	private LinearLayout _triggerSpinnerLayout = null;
	private LinearLayout _spinnerLinearLayout = null;
	
	private Spinner _spinner = null;
	private Spinner _triggerSpinner = null;
	
	private Button _testCaseButton = null;
	private Button _showOnMapButton = null;
	private Button _showStatus = null;
	
	private ArrayList<String> _alltestCases;
	private ArrayList<TriggerData> _allTrigger;
	private ArrayList<String> _alltriggerName ;
	
	private int speed=0;
	private int frequency = 0;
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_main);
        
        getComponent();
       
    }
    
    private void getComponent(){
    	
    	speed = 10;
    	frequency = 10;
    	
    	_spinnerLinearLayout=(LinearLayout)findViewById(R.id.spinnerLinearLayout);
    	
    	_spinnerLayout = (LinearLayout)findViewById(R.id.spinnerLayout);
    	_spinner = (Spinner)findViewById(R.id.spinner);
    	
    	_testCaseButton = (Button)findViewById(R.id.showButton);
    	_showOnMapButton = (Button)findViewById(R.id.mapButton);
    	_showStatus = (Button)findViewById(R.id.triggerCustombackbutton);
    	
    	_triggerSpinnerLayout = (LinearLayout)findViewById(R.id.triggerSpinnerLayout);
    	_triggerSpinner = (Spinner)findViewById(R.id.triggerSpinner);
    	
    	_locationManager = new GLLocationManager(MainActivity.this);
    	_locationManager.setApiKey("INSERT YOUR API KEY HERE");
    	_locationManager.setUnit("kph");
    	_locationManager.setOutPutType("json");
    	_locationManager.setSpeed(speed);
    	
    	 _alltriggerName = new ArrayList<String>();
    	
    	_testCaseButton.setOnClickListener(new ClickListener());
    	_showOnMapButton.setOnClickListener(new ClickListener());
    	_showStatus.setOnClickListener(new ClickListener());
    }
    
    private class ClickListener implements OnClickListener,OnItemSelectedListener{

		

		public void onItemSelected(AdapterView<?> arg0, View arg1, int position,
				long arg3) {
			// TODO Auto-generated method stub
			
			
			GLLocation location = _locationManager.registration("INSERT YOUR API KEY HERE",_alltestCases.get(position));
//		    _locationManager.getTestCaseType(_alltestCases.get(position));
		    
		    
//		    _locationManager.getPoints(GLLocationManager.getTestType(),_alltestCases.get(position));
	        
		   _locationManager.checkGeoTrigger(_alltriggerName.get(position),location.getLatitude(), location.getLongitude());
			
		}

		public void onNothingSelected(AdapterView<?> arg0) {
			// TODO Auto-generated method stub
			
		}

		public void onClick(View v) {
			// TODO Auto-generated method stub
			if(v == _testCaseButton){
				 
//				 _locationManager.registration("INSERT YOUR API KEY HERE");
				 _alltestCases=_locationManager.getTestCases();
				 _allTrigger=_locationManager.getTriggers();
				 
				 for(int i = 0;i<_allTrigger.size();i++){
					 
					 if(_allTrigger.get(i).getTriggerName() != null){
						 
						 _alltriggerName.add(_allTrigger.get(i).getTriggerName());
					 }
					
				 }
		          setSpinnerData();
				  setTriggerData();
			}
			else if(v == _showOnMapButton){
				
				Intent _intent = new Intent(MainActivity.this,ShowOnMap.class);
				startActivity(_intent);
			}
			else if(v == _showStatus){
				
				String status=ApplicationInfo.triggerStatus;
				showDialog(status);
			}
			
		}

    }
    
    private void setSpinnerData(){
    	
    	_spinnerLinearLayout.setVisibility(View.VISIBLE);
        
    	if(_alltestCases.size() != 0 && _alltriggerName.size() != 0){
    		ArrayAdapter<String> _adapter = new ArrayAdapter<String>(MainActivity.this,android.R.layout.simple_spinner_item,_alltestCases);
            _adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
            _spinner.setAdapter(_adapter);
            
            _spinner.setOnItemSelectedListener(new ClickListener());
    	}
    	 
    }
    
    private void setTriggerData(){
    	
        	_spinnerLinearLayout.setVisibility(View.VISIBLE);
        	if( _alltriggerName.size() != 0 && _alltestCases.size() != 0){
        		
	        	ArrayAdapter<String> _adapter = new ArrayAdapter<String>(MainActivity.this,android.R.layout.simple_spinner_item,_alltriggerName);
	            _adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
	            _triggerSpinner.setAdapter(_adapter);
	            
	            _triggerSpinner.setOnItemSelectedListener(new ClickListener());
	            
        	} 
        }
    private void showDialog(String status){
	   	
	    AlertDialog.Builder _builder = new AlertDialog.Builder(MainActivity.this);
	    _builder.setTitle("Status");
	    _builder.setMessage(status);
	    _builder.setPositiveButton("Ok", new DialogInterface.OnClickListener(){
	   		
	   		public void onClick(DialogInterface arg0, int arg1) {
	   		}
	   	});	 
	   	_builder.show();
	 } 
}
