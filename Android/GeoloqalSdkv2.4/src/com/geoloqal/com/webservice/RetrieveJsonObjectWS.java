package com.geoloqal.com.webservice;


import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import org.json.JSONObject;
import android.content.Context;
import android.util.Log;

public class RetrieveJsonObjectWS {
	
	private Context _context;
	static JSONObject jobj = null;
	
	public RetrieveJsonObjectWS(Context _context){
		
		this._context = _context;
	}
	
	public JSONObject getJsonObjectData(String webMethod ,String data){
		System.out.println("Inside Get JSONOBJECTDATA");
		
		String _url = WebAddress.WEBADDRESS+webMethod+data;
		System.out.println("web_url ::"+_url);
		_url = _url.replace(" ", "+");
		
		Log.i("URL ", ""+_url);
		JSONObject json = null;
		
		try{
			
			json = getJSONfromURL(_url);
			System.out.println("JSON :: "+json.length());
			
		}
		catch (Exception e) {
			// TODO: handle exception
			Log.e("log_tag", "Error in json"+e.toString());
		}
		
		return json;
		
	}
	
	
	public static JSONObject getJSONfromURL(String _url){

		InputStream is = null;
		String result = "";
		
		int httpRC = 0;

		try{
			
			URL url = new URL(_url);	
			HttpURLConnection httpconn;
			httpconn = (HttpURLConnection) url.openConnection();
			httpconn.setDoInput(true);
			httpconn.connect();
			httpRC = httpconn.getResponseCode();	
			is= httpconn.getInputStream();
			
			if(httpRC ==  HttpURLConnection.HTTP_OK){
				
				BufferedReader reader = new BufferedReader(new InputStreamReader(is,"iso-8859-1"),8);
				StringBuilder sb = new StringBuilder();
				String line = null;
				while ((line = reader.readLine()) != null) {
					sb.append(line + "\n");
				}
				is.close();
				result=sb.toString();
				System.out.println("result ::"+result);
				
				jobj = new JSONObject(result);
				System.out.println("jobj ::"+jobj);
				
			}
			

		}catch(Exception e){
			Log.e("log_tag", "Error in http connection "+e.toString());
		}

		return jobj;
	}

	
	

}

