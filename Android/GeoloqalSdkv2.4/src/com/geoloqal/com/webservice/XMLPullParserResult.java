package com.geoloqal.com.webservice;

import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;

import javax.net.ssl.HttpsURLConnection;

import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserFactory;

import com.geoloqal.com.data.GLLocation;
import com.geoloqal.com.data.TestcaseData;
import com.geoloqal.com.data.TriggerData;

import android.content.Context;

public class XMLPullParserResult {
	
	private Context _context;
	private ArrayList<String> testCaseNameArray = null;
	private ArrayList<TriggerData> allTriggerDataArray = null;
	private ArrayList<GLLocation> locationDataArray = null;
	private String testCaseType = null;
	private TriggerData triggerDataObj = null;
	private GLLocation location = null;
	
	public XMLPullParserResult(Context _context) {
		
		this._context = _context;
		testCaseNameArray = new ArrayList<String>();
		allTriggerDataArray = new ArrayList<TriggerData>();
		locationDataArray = new ArrayList<GLLocation>();
	}
	
	public ArrayList<String> parseTestCasesXMLFile(String url){
		
		String _startTag = "";
		String _endTag = "";
		String _nodeValue = "";
		
		HttpURLConnection _httpconn = null;
		
		try{
			URL xmlurl = new URL(url);
			_httpconn = (HttpURLConnection)xmlurl.openConnection();
			_httpconn.setDoInput(true);
			_httpconn.setDoOutput(true);
			_httpconn.connect();
			
			int httpRC = _httpconn.getResponseCode();
			
			if(httpRC == HttpsURLConnection.HTTP_OK){
				
				
				XmlPullParserFactory x = XmlPullParserFactory.newInstance();
				x.setNamespaceAware(false);
				XmlPullParser p = x.newPullParser();
				p.setInput(new InputStreamReader(_httpconn.getInputStream()));
				boolean status = true;
				
				while(status){
					
				 
					int next = p.next();
					
					switch (next) {
					case XmlPullParser.START_TAG:
						_startTag = p.getName();
						break;
						
					case XmlPullParser.END_TAG:
						_endTag = p.getName();
						
						if(_startTag.equalsIgnoreCase("testcasename") && _endTag.equalsIgnoreCase("testcasename")){
							
							testCaseNameArray.add(_nodeValue);
						}
						else if(_startTag.equalsIgnoreCase("test_type") && _endTag.equalsIgnoreCase("test_type")){
							
						}
						
						break;
						
					case XmlPullParser.TEXT:
						_nodeValue = p.getText();
						break;
						
					case XmlPullParser.END_DOCUMENT:
						status = false;
						break;
					}
					
				}
			}
			
		}
		catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		return testCaseNameArray;
	}
	
public String parseTestCaseTypeXMLFile(String url){
		
		String _startTag = "";
		String _endTag = "";
		String _nodeValue = "";
		
		HttpURLConnection _httpconn = null;
		
		try{
			URL xmlurl = new URL(url);
			_httpconn = (HttpURLConnection)xmlurl.openConnection();
			_httpconn.setDoInput(true);
			_httpconn.setDoOutput(true);
			_httpconn.connect();
			
			int httpRC = _httpconn.getResponseCode();
			
			if(httpRC == HttpsURLConnection.HTTP_OK){
				
				
				XmlPullParserFactory x = XmlPullParserFactory.newInstance();
				x.setNamespaceAware(false);
				XmlPullParser p = x.newPullParser();
				p.setInput(new InputStreamReader(_httpconn.getInputStream()));
				boolean status = true;
				
				while(status){
					
				 
					int next = p.next();
					
					switch (next) {
					case XmlPullParser.START_TAG:
						_startTag = p.getName();
						break;
						
					case XmlPullParser.END_TAG:
						_endTag = p.getName();
						
						if(_startTag.equalsIgnoreCase("test_type") && _endTag.equalsIgnoreCase("test_type")){
							
							testCaseType = _nodeValue;
						}
						
						break;
						
					case XmlPullParser.TEXT:
						_nodeValue = p.getText();
						break;
						
					case XmlPullParser.END_DOCUMENT:
						status = false;
						break;
					}
					
				}
			}
			
		}
		catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		return testCaseType;
	}

public ArrayList<TriggerData> parseGetTriggerXMLFile(String url){
	
	String _startTag = "";
	String _endTag = "";
	String _nodeValue = "";
	
	HttpURLConnection _httpconn = null;
	
	try{
		allTriggerDataArray.clear();
		URL xmlurl = new URL(url);
		_httpconn = (HttpURLConnection)xmlurl.openConnection();
		_httpconn.setDoInput(true);
		_httpconn.setDoOutput(true);
		_httpconn.connect();
		
		int httpRC = _httpconn.getResponseCode();
		
		if(httpRC == HttpsURLConnection.HTTP_OK){
			
			
			XmlPullParserFactory x = XmlPullParserFactory.newInstance();
			x.setNamespaceAware(false);
			XmlPullParser p = x.newPullParser();
			p.setInput(new InputStreamReader(_httpconn.getInputStream()));
			boolean status = true;
			
			while(status){
				
			   triggerDataObj = new TriggerData();
				int next = p.next();
				
				switch (next) {
				case XmlPullParser.START_TAG:
					_startTag = p.getName();
					break;
					
				case XmlPullParser.END_TAG:
					_endTag = p.getName();
					
					if(_startTag.equalsIgnoreCase("testcasename") && _endTag.equalsIgnoreCase("testcasename")){
						
						triggerDataObj.setTriggerName(_nodeValue);
					}
					else if(_startTag.equalsIgnoreCase("trigger_type") && _endTag.equalsIgnoreCase("trigger_type")){
						triggerDataObj.setTriggerType(_nodeValue);
					}
					
					allTriggerDataArray.add(triggerDataObj);
					break;
					
				case XmlPullParser.TEXT:
					_nodeValue = p.getText();
					break;
					
				case XmlPullParser.END_DOCUMENT:
					status = false;
					break;
				}
				
				
			}
		}
		
	}
	catch (Exception e) {
		// TODO: handle exception
		e.printStackTrace();
	}
	
	return allTriggerDataArray;
}

public String parseCheckGeoTriggerXMLFile(String url){
	
	String _startTag = "";
	String _endTag = "";
	String _nodeValue = "";
	String triggerStatus = "";
	
	HttpURLConnection _httpconn = null;
	
	try{
		URL xmlurl = new URL(url);
		_httpconn = (HttpURLConnection)xmlurl.openConnection();
		_httpconn.setDoInput(true);
		_httpconn.setDoOutput(true);
		_httpconn.connect();
		
		int httpRC = _httpconn.getResponseCode();
		
		if(httpRC == HttpsURLConnection.HTTP_OK){
			
			
			XmlPullParserFactory x = XmlPullParserFactory.newInstance();
			x.setNamespaceAware(false);
			XmlPullParser p = x.newPullParser();
			p.setInput(new InputStreamReader(_httpconn.getInputStream()));
			boolean status = true;
			
			while(status){
				
			 
				int next = p.next();
				
				switch (next) {
				case XmlPullParser.START_TAG:
					_startTag = p.getName();
					break;
					
				case XmlPullParser.END_TAG:
					_endTag = p.getName();
					
					if(_startTag.equalsIgnoreCase("status") && _endTag.equalsIgnoreCase("status")){
						
						triggerStatus = _nodeValue;
					}
					
					break;
					
				case XmlPullParser.TEXT:
					_nodeValue = p.getText();
					break;
					
				case XmlPullParser.END_DOCUMENT:
					status = false;
					break;
				}
				
			}
		}
		
	}
	catch (Exception e) {
		// TODO: handle exception
		e.printStackTrace();
	}
	
	return triggerStatus;
}
public GLLocation parseGetGeoPointXMLFile(String url){
	
	String _startTag = "";
	String _endTag = "";
	double _nodeValue = 0;
	
	HttpURLConnection _httpconn = null;
	location = new GLLocation();
	
	try{
		URL xmlurl = new URL(url);
		_httpconn = (HttpURLConnection)xmlurl.openConnection();
		_httpconn.setDoInput(true);
		_httpconn.setDoOutput(true);
		_httpconn.connect();
		
		int httpRC = _httpconn.getResponseCode();
		
		if(httpRC == HttpsURLConnection.HTTP_OK){
			
			
			XmlPullParserFactory x = XmlPullParserFactory.newInstance();
			x.setNamespaceAware(false);
			XmlPullParser p = x.newPullParser();
			p.setInput(new InputStreamReader(_httpconn.getInputStream()));
			boolean status = true;
			
			while(status){
				
				int next = p.next();
				
				switch (next) {
				case XmlPullParser.START_TAG:
					_startTag = p.getName();
					break;
					
				case XmlPullParser.END_TAG:
					_endTag = p.getName();
					
					if(_startTag.equalsIgnoreCase("latitude") && _endTag.equalsIgnoreCase("latitude")){
						
						location.setLatitude(_nodeValue);
						
					}
					else if(_startTag.equalsIgnoreCase("longitude") && _endTag.equalsIgnoreCase("longitude")){
						
						location.setLongitude(_nodeValue);
					}
					
					break;
					
				case XmlPullParser.TEXT:
					_nodeValue = Double.parseDouble(p.getText());
					break;
					
				case XmlPullParser.END_DOCUMENT:
					status = false;
					break;
				}
			}
		}
		
	}
	catch (Exception e) {
		// TODO: handle exception
		e.printStackTrace();
	}
	
	return location;
}
public ArrayList<GLLocation> parseGetDirectionPointXMLFile(String url){
	
	String _startTag = "";
	String _endTag = "";
	double _nodeValue = 0;
	
	HttpURLConnection _httpconn = null;
	
	
	try{
		URL xmlurl = new URL(url);
		_httpconn = (HttpURLConnection)xmlurl.openConnection();
		_httpconn.setDoInput(true);
		_httpconn.setDoOutput(true);
		_httpconn.connect();
		
		int httpRC = _httpconn.getResponseCode();
		
		if(httpRC == HttpsURLConnection.HTTP_OK){
			
			
			XmlPullParserFactory x = XmlPullParserFactory.newInstance();
			x.setNamespaceAware(false);
			XmlPullParser p = x.newPullParser();
			p.setInput(new InputStreamReader(_httpconn.getInputStream()));
			boolean status = true;
			
			while(status){
				
				location = new GLLocation();
				int next = p.next();
				
				switch (next) {
				case XmlPullParser.START_TAG:
					_startTag = p.getName();
					break;
					
				case XmlPullParser.END_TAG:
					_endTag = p.getName();
					
					if(_startTag.equalsIgnoreCase("latitude") && _endTag.equalsIgnoreCase("latitude")){
						
						location.setLatitude(_nodeValue);
						
					}
					else if(_startTag.equalsIgnoreCase("longitude") && _endTag.equalsIgnoreCase("longitude")){
						
						location.setLongitude(_nodeValue);
					}
					
					locationDataArray.add(location);
					break;
					
				case XmlPullParser.TEXT:
					_nodeValue = Double.parseDouble(p.getText());
					break;
					
				case XmlPullParser.END_DOCUMENT:
					status = false;
					break;
				}
			}
		}
		
	}
	catch (Exception e) {
		// TODO: handle exception
		e.printStackTrace();
	}
	
	return locationDataArray;
}

}
