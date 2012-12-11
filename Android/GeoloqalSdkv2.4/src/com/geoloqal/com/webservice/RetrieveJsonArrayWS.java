package com.geoloqal.com.webservice;


import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import org.json.JSONArray;
import android.content.Context;
import android.util.Log;

public class RetrieveJsonArrayWS {
	
	private Context _context;
	private JSONArray _jobj;
	
	public RetrieveJsonArrayWS(Context _context){
		
		this._context = _context;
	}
	public JSONArray getJsonArrayData(String webMethod,String data) {
		// TODO Auto-generated method stub
		String _url = WebAddress.WEBADDRESS + webMethod+data;
		_url = _url.replace(" ", "+");
		
		Log.i("URL ", ""+_url);
		JSONArray json = null;
		
		try{
			
			json = getJSONfromURL(_url);
			System.out.println("json data "+json);
		}
		catch (Exception e) {
			// TODO: handle exception
			Log.e("log_tag", "Error in json"+e.toString());
			e.printStackTrace();
		}
		
		return json;
	}
	
	
	
	public static JSONArray getJSONfromURL(String data){

		InputStream is = null;
		String result = "";
		JSONArray jArray = null;
		int httpRC = 0;

		try{
			System.out.println("webservice url"+data);
			URL url = new URL(data);	
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
				
				jArray = new JSONArray(result);
				
				System.out.println("array length ::"+jArray.length());
			}
			

		}catch(Exception e){
			Log.e("log_tag", "Error in http connection "+e.toString());
		}

		return jArray;
	}

	
	

}

