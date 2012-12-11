package com.geoloqal.com;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geoloqal.com.data.ApplicationInfo;
import com.geoloqal.com.data.GLLocation;
import com.geoloqal.com.data.LocationData;
import com.geoloqal.com.data.TestcaseData;
import com.geoloqal.com.data.TriggerData;
import com.geoloqal.com.webservice.XMLPullParserResult;
import com.geoloqal.com.webservice.RetrieveJsonArrayWS;
import com.geoloqal.com.webservice.RetrieveJsonObjectWS;
import com.geoloqal.com.webservice.WebAddress;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.location.Location;
import android.os.CountDownTimer;
import android.telephony.TelephonyManager;
import android.widget.Toast;

public class GLLocationManager {
	
	private Context context = null;
	
	private String apiKey = null;
	private String outPutType = null;
	private String unit=null;
	private  int speed = 0;
	private  int frequency = 0;
	
	private static String triggerStatus = "false";
	
	private static int count;
	private int nextCount = 0;
	
	private  RetrieveJsonObjectWS _retriveJsonWs = null;
	private  RetrieveJsonArrayWS _retriveJsonArrayWs = null;
	
	private JSONObject errorMessageObj = null;
	private  JSONObject _testTypeJsonObject = null;
	private  JSONObject _getPointJsonObject = null;
	private  JSONObject _getNextPointJsonObject = null;
	private  JSONObject _getDirectionJsonObject = null;
	private  JSONObject _getTriggerStatusJsonObject = null;
	
	public  JSONArray _gettriggerJsonArray = null;
	public  JSONArray _testcasesJsonArray = null;
	
	public  ArrayList<String> _alltestcaseName = null;
	public  ArrayList<TestcaseData> _alltestCaseData=null;
	public ArrayList<GLLocation> locationArray = null;
	
	private GLLocation locationdata = null;
	private XMLPullParserResult xmlData = null;
	
	public ArrayList<TriggerData> triggerDataArray = null;
	
	
	public GLLocationManager(Context context){
		
		 this.context = context;
		_retriveJsonWs= new RetrieveJsonObjectWS(context);
		_retriveJsonArrayWs = new RetrieveJsonArrayWS(context);
		
		 locationArray = new ArrayList<GLLocation>();
		 triggerDataArray = new ArrayList<TriggerData>();
		 
	    _alltestcaseName = new ArrayList<String>();
		 
		 xmlData = new XMLPullParserResult(context);
		 
	}
	
    public GLLocation registration(String testCaseName){	
    	
    		 getTestCaseType(testCaseName);
    	
    	return locationdata;
		
	}
    
    private void showDialog(String message){
    	
    	AlertDialog.Builder _alertDialog = new AlertDialog.Builder(context);
    	_alertDialog.setTitle("Message");
    	_alertDialog.setMessage(message);
    	_alertDialog.setPositiveButton("Ok", new DialogInterface.OnClickListener(){

			@Override
			public void onClick(DialogInterface dialog, int which) {
				// TODO Auto-generated method stub
				
			}});
    	
    	_alertDialog.create().show();
    	
    }
	
	private String  getDeviceId(){
		
		TelephonyManager manager=(TelephonyManager)context.getSystemService(Context.TELEPHONY_SERVICE);
		String deviceid=manager.getDeviceId();
		
		return deviceid;
	}
	public ArrayList<String>  getTestCases(){
		
		count = 0;
		
		String _urlData = "api_key="+getApiKey()+"&device_type=Android"+"&output_type="+getOutPutType();
		
		if(getOutPutType() == "json"){
			
			try{
				_alltestcaseName.clear();
   				
   			
   				_testcasesJsonArray= _retriveJsonArrayWs.getJsonArrayData(WebAddress.GET_TESTCASES,_urlData);
   				
   				_alltestcaseName=new ArrayList<String>();
				
				_alltestCaseData=new ArrayList<TestcaseData>();
				
				if(_testcasesJsonArray != null && _testcasesJsonArray.length() != 1){
					
					for(int count=0;count<_testcasesJsonArray.length();count++){
						try {
							JSONObject _jsonObject=_testcasesJsonArray.getJSONObject(count);
							TestcaseData _testcaseData=new TestcaseData();
							_testcaseData.setTestcaseName(_jsonObject.getString("testcase_name"));
							_testcaseData.setTestcaseType(_jsonObject.getString("test_type"));
							_alltestcaseName.add(_jsonObject.getString("testcase_name"));
							_alltestCaseData.add(_testcaseData);
						} catch (JSONException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
				}
			}catch (Exception e) {
				
				e.printStackTrace();
			}
		}else if(getOutPutType()== "xml"){
			
			String url = WebAddress.WEBADDRESS+WebAddress.GET_TESTCASES+_urlData;
			url.replace(" ", "+");
			
			_alltestcaseName = xmlData.parseTestCasesXMLFile(url);
			
		}
		else{
			
			errorMessageObj = _retriveJsonWs.getJsonObjectData(WebAddress.GET_TESTCASES,_urlData);
			
			if(errorMessageObj != null){
				
				showDialog("OutputType must be there");
			}
			
		}
				
		return _alltestcaseName;
	}
	public void getTestCaseType(final String testcase){
        
		String _urlData ="api_key="+getApiKey()+"&testcase_name="+testcase+"&device_type=Android"+"&output_type="+getOutPutType();
		if(getOutPutType()== "json"){
			
               try{
				
				_testTypeJsonObject = _retriveJsonWs.getJsonObjectData(WebAddress.TEST_CASE_TYPE, _urlData);
				
				if(_testTypeJsonObject != null){
					
                       String testType = _testTypeJsonObject.getString("test_type")	;				
                       
                       getPoints(testType,testcase);
				}
			    
			}catch (Exception e) {
				// TODO: handle exception
				
				e.printStackTrace();
			}
		}else if(getOutPutType()== "xml" ){
			
			
			String url = WebAddress.WEBADDRESS+WebAddress.TEST_CASE_TYPE+_urlData;
			url.replace(" ", "+");
			
			
			String testCaseType = xmlData.parseTestCaseTypeXMLFile(url);
			getPoints(testCaseType,testcase);
		}
		else{
			
			
//			errorMessageObj = _retriveJsonWs.getJsonObjectData(WebAddress.TEST_CASE_TYPE,_urlData);
//			
//			if(errorMessageObj != null){
//				
//				showDialog("Output Type must be there");
//			}
		}
					
			
	}
	
public  void getPoints(final String testCaseType,final String testcasename){
	
		
		if(testCaseType.equals("By Polyline") || testCaseType.equals("By Circle") || testCaseType.equals("By Polygon")){
			
			 getGeoPoints(testcasename);
		}
		else if(testCaseType.equals("By Sequential Polyline")){
			
			 getNextPoints(testcasename);
		}
		else if(testCaseType.equals("By Address")){
					
				getAddressPoints(testcasename);
			}
		
	}
	
  public  void getGeoPoints(final String testcasename) {
	  
	    Date date = new Date(); 
		SimpleDateFormat sdf; 
		sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
        
		try {
			if(getDeviceId() != null){
				
               if(getDeviceId().equals("000000000000000")){
            	   String _urlData ="api_key="+getApiKey()+"&device_type=Android"+"&date_time="+sdf.format(date).replace(" ", "%20")+"&testcase_name="+testcasename+"&output_type="+getOutPutType();
            	   
            	   if(getOutPutType()== "json"){
            	    	
    	    			_getPointJsonObject = _retriveJsonWs.getJsonObjectData(WebAddress.GETGEOPOINT, _urlData);
    	    			
    	    			locationArray.clear();;
    	    			if(_getPointJsonObject != null){
    	    					
    	    				double latitude = _getPointJsonObject.getDouble("latitude");
    	    		    	double longitude = _getPointJsonObject.getDouble("longitude");
    	    		    	
    	    		    	locationdata= new GLLocation();
    	    		    	locationdata.setLatitude(latitude);
    	    		    	locationdata.setLongitude(longitude);
    	    		    	locationArray.add(locationdata);
    	    			}
    	    			
    	    			ApplicationInfo.locationData = locationArray;
    	    			
            	    }else if(getOutPutType()== "xml"){
            	    	
            	    	locationArray.clear();
            	    	
            	    	
            			String url = WebAddress.WEBADDRESS+WebAddress.GETGEOPOINT+_urlData;
            			url.replace(" ", "+");
            			
            			locationdata= xmlData.parseGetGeoPointXMLFile(url);
            			locationArray.add(locationdata);
            			
            			ApplicationInfo.locationData = locationArray;
            			
            	    }
            	    else{
            	    	
//            	    	errorMessageObj = _retriveJsonWs.getJsonObjectData(WebAddress.GETGEOPOINT,_urlData);
//            			
//            			if(errorMessageObj != null){
//            				
//            				showDialog("Output Type must be there");
//            			}
            	    	
            	    }
	    			
	    			
				}
				
				else{
					
					GPSTracker _gpsTraker = new GPSTracker(context);
					
					Location location = _gpsTraker.getLocation();
					
					double locationLatitude = location.getLatitude();
					double locationLongitude = location.getLongitude();
					
					locationdata= new GLLocation();
    		    	locationdata.setLatitude(locationLatitude);
    		    	locationdata.setLongitude(locationLongitude);
				    
	    		    
	    		    ApplicationInfo.locationData.clear();
	    		    ApplicationInfo.locationData.add(locationdata);
	    		    
	    		    context.stopService(new Intent(context, GPSTracker.class));
				}
			}
	    		
	    		
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
    		
    	}
	
	public  GLLocation getNextPoints(final String testcasename) {
		
		try {
	    		
	    		if(getDeviceId() != null){
	    			
	    			if(getDeviceId().equals("000000000000000")){
	    				
	    				String _urlData = "api_key="+getApiKey()+"&&testcase_name="+testcasename+"&device_type="+"Android"+"&step="+getNextCount()+"&output_type="+getOutPutType();
		    			
		    			if(getOutPutType()== "json"){
		    				
		    				
			    			_getNextPointJsonObject = _retriveJsonWs.getJsonObjectData(WebAddress.GETNEXTGEOPOINT, _urlData);
			    			 locationArray.clear();
			    			 
			    			if(_getNextPointJsonObject != null){
			    	    			
			    	    			double latitude = _getNextPointJsonObject.getDouble("latitude");
				    	    		double longitude = _getNextPointJsonObject.getDouble("longitude");
				    	    			
			    	    			locationdata= new GLLocation();
				    		    	locationdata.setLatitude(latitude);
				    		    	locationdata.setLongitude(longitude);
								
								    locationArray.add(locationdata);
			    			}   
			    			
			    			ApplicationInfo.locationData = locationArray;
		    			}
		    			else if(getOutPutType()== "xml"){
		    				
	            			String url = WebAddress.WEBADDRESS+WebAddress.GETNEXTGEOPOINT+_urlData;
	            			url.replace(" ", "+");
	            			
	            			
	            			locationdata= xmlData.parseGetGeoPointXMLFile(url);
	            			locationArray.add(locationdata);;
	            			
	            			ApplicationInfo.locationData=locationArray;
	            			
		    			}
		    			else{
		    				
//		    				errorMessageObj = _retriveJsonWs.getJsonObjectData(WebAddress.GETNEXTGEOPOINT,_urlData);
//	            			
//	            			if(errorMessageObj != null){
//	            				
//	            				showDialog("Output Type must be there");
//	            			}
	            	    	
		    			}
		    			
		    			
					}
					
					else{
						
						GPSTracker _gpsTraker = new GPSTracker(context);
						
						Location location = _gpsTraker.getLocation();
						
						double locationLatitude = location.getLatitude();
						double locationLongitude = location.getLongitude();
						
						locationdata= new GLLocation();
	    		    	locationdata.setLatitude(locationLatitude);
	    		    	locationdata.setLongitude(locationLongitude);
		    		    
		    		    ApplicationInfo.locationData.clear();
		    		    ApplicationInfo.locationData.add(locationdata);
		    		    
		    		    context.stopService(new Intent(context, GPSTracker.class));
					}
	    			
	    		}
	    		
	    		
	    		
			
		}catch (Exception e) {
			// TODO: handle exception
		}	
		return locationdata;
	}
	public  void getAddressPoints(final String testcasename){
		
		Date date = new Date(); 
		SimpleDateFormat sdf; 
		sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
		
		try{
			if(getDeviceId() != null){
				
                 if(getDeviceId().equals("000000000000000")){
                	 
                	 String _urlData = "api_key="+getApiKey()+"&testcase_name="+testcasename+"&speed="+getSpeed()+"&unit="+getUnit()+"&step="+count++ +"&device_type=Android"+"&date_time="+sdf.format(date).replace(" ", "%20")+"&output_type="+getOutPutType();
                	 if(getOutPutType()== "json" && getUnit() != null){
                		 
     	    		    _getDirectionJsonObject = _retriveJsonWs.getJsonObjectData(WebAddress.GETDRIVINGDIRECTIONPOINT, _urlData);
     	    		    
     	    		    if(_getDirectionJsonObject != null){
     	    				
     	    				double latitude = _getDirectionJsonObject.getDouble("latitude");
     	    	    		double longitude = _getDirectionJsonObject.getDouble("longitude");
     	    	    		
     	    	    		locationdata= new GLLocation();
     	    		    	locationdata.setLatitude(latitude);
     	    		    	locationdata.setLongitude(longitude);
     	    		    	locationArray.add(locationdata);
     	    		    }	
     	    		    
                	 }
                	 else if(getOutPutType()== "xml" && getUnit()!= null){
                		 
                		    
	            			String url = WebAddress.WEBADDRESS+WebAddress.GETDRIVINGDIRECTIONPOINT+_urlData;
	            			url.replace(" ", "+");
	            			
	            			locationArray = xmlData.parseGetDirectionPointXMLFile(url);
	            			
                	 }
                	 else{
                		 
                		 errorMessageObj = _retriveJsonWs.getJsonObjectData(WebAddress.GETDRIVINGDIRECTIONPOINT,_urlData);
	            			
	            			if(errorMessageObj != null){
	            				
	            				showDialog("OutputType or unit  must be there");
	            			} 
                	 }
	    			
                	 ApplicationInfo.locationData = locationArray;
	    		    
				}
				
				else{
					
					GPSTracker _gpsTraker = new GPSTracker(context);
					
					Location location = _gpsTraker.getLocation();
					
					double locationLatitude = location.getLatitude();
					double locationLongitude = location.getLongitude();
				
					
					locationdata= new GLLocation();
    		    	locationdata.setLatitude(locationLatitude);
    		    	locationdata.setLongitude(locationLongitude);
    		    	ApplicationInfo.locationData.add(locationdata);
    		    	
	    		    context.stopService(new Intent(context, GPSTracker.class));
				}
			}
	    		
			
		}catch (Exception e) {
			// TODO: handle exception
		}
		
	}
	
	public ArrayList<TriggerData> getTriggers(){
		
		try{
			triggerDataArray.clear();
			
			String _urlData = "api_key="+getApiKey()+"&device_type=Android"+"&output_type="+getOutPutType();
			
			if(getOutPutType()== "json"){
				
				_gettriggerJsonArray = _retriveJsonArrayWs.getJsonArrayData(WebAddress.GETTRIGGERNAMES, _urlData);
			    
				if(_gettriggerJsonArray != null && _gettriggerJsonArray.length() != 1){
					
					for(int i = 0;i <_gettriggerJsonArray.length() ;i++){
						
						JSONObject _jsonObject = _gettriggerJsonArray.getJSONObject(i);
						
						String triggerName = _jsonObject.getString("trigger_name");
						String triggerType = _jsonObject.getString("trigger_type");
						
						TriggerData triggerDataObj= new TriggerData();
						triggerDataObj.setTriggerName(triggerName);
						triggerDataObj.setTriggerType(triggerType);
						
						triggerDataArray.add(triggerDataObj);
					}
				
			   }
			}	
			else if(getOutPutType()== "xml"){
				
				String url = WebAddress.WEBADDRESS+WebAddress.GETTRIGGERNAMES+_urlData;
				url.replace(" ", "+");
				
				triggerDataArray = xmlData.parseGetTriggerXMLFile(url);
				
			}
			else{
				
//				errorMessageObj = _retriveJsonWs.getJsonObjectData(WebAddress.GETTRIGGERNAMES,_urlData);
//    			
//    			if(errorMessageObj != null){
//    				
//    				showDialog("Output Type must be there");
//    			} 
				
			}
		    
		}catch (Exception e) {
			// TODO: handle exception
			
			e.printStackTrace();
		}

    return triggerDataArray;
  }
	

	public String checkGeoTrigger(final String triggerName,final double latitude,final double longitude){
				
			try{
				
				String _urlData ="api_key="+getApiKey()+"&trigger_name="+triggerName+"&latitude="+latitude+"&longitude="+longitude+"&output_type="+getOutPutType()+"&device_type=Android";
				
				if(getOutPutType()== "json"){
					
					_getTriggerStatusJsonObject = _retriveJsonWs.getJsonObjectData(WebAddress.CHECKGEOTRIGGER, _urlData);
				    
					if(_getTriggerStatusJsonObject != null){
						
						String status = _getTriggerStatusJsonObject.getString("status");
						
						triggerStatus = status;
						
						ApplicationInfo.triggerStatus=status;
					}
				}
				else if(getOutPutType()== "xml"){
					
					
					String url = WebAddress.WEBADDRESS+WebAddress.CHECKGEOTRIGGER+_urlData;
					url.replace(" ", "+");
					
					
					String status = xmlData.parseCheckGeoTriggerXMLFile(url);
					triggerStatus = status;
					
					ApplicationInfo.triggerStatus=status;
				}
				else{
//					
//					errorMessageObj = _retriveJsonWs.getJsonObjectData(WebAddress.CHECKGEOTRIGGER,_urlData);
//	    			
//	    			if(errorMessageObj != null){
//	    				
//	    				showDialog("Output Type must be there");
//	    			} 
//					
				}
			     
			    
			}catch (Exception e) {
				// TODO: handle exception
				
				e.printStackTrace();
			}
		 
		return triggerStatus;
	}

	public int getSpeed() {
		return speed;
	}

	public void setSpeed(int speed) {
		this.speed = speed;
	}

	public int getFrequency() {
		return frequency;
	}

	public void setFrequency(int frequency) {
		this.frequency = frequency;
	}

	public String getOutPutType() {
		return outPutType;
	}

	public void setOutPutType(String outPutType) {
		this.outPutType = outPutType;
	}

	public String getUnit() {
		return unit;
	}

	public void setUnit(String unit) {
		this.unit = unit;
	}
	
	public String getApiKey() {
		return apiKey;
	}
	public void setApiKey(String apiKey) {
		this.apiKey = apiKey;
	}

	public int getNextCount() {
		return nextCount;
	}

	public void setNextCount(int nextCount) {
		this.nextCount = nextCount;
	}

}
