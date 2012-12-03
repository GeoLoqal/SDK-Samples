package com.cobisystems.geolocalsdk;

import java.util.ArrayList;
import java.util.List;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.Point;
import android.os.Bundle;
import android.view.Window;

import com.geoloqal.com.data.ApplicationInfo;
import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapActivity;
import com.google.android.maps.MapController;
import com.google.android.maps.MapView;
import com.google.android.maps.Overlay;
import com.google.android.maps.Projection;

public class ShowOnMap extends MapActivity{
	
	private MapView _mapview = null;
	private MapController _controller = null;
	private GeoPoint _point = null;
	
	private ArrayList<GeoPoint> _geopoints = null;
	
	@Override
	protected void onCreate(Bundle icicle) {
		// TODO Auto-generated method stub
		super.onCreate(icicle);
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		setContentView(R.layout.map_layout);
		
		getComponent();
	}
	
	private void getComponent(){
		
		_geopoints = new ArrayList<GeoPoint>();
		
		_mapview = (MapView)findViewById(R.id.mapview);
		_mapview.setClickable(true);
		_mapview.setEnabled(true);
		_mapview.setSatellite(false);
		_mapview.setStreetView(true);
		_mapview.setTraffic(true);
	    _mapview.setBuiltInZoomControls(true);
		 
		_controller = _mapview.getController();
		
		
		System.out.println("ApplicationInfo.locationData.size() "+ApplicationInfo.locationData.size());
		
		for(int i = 0;i< ApplicationInfo.locationData.size();i++){
			
			_point = new GeoPoint((int)(ApplicationInfo.locationData.get(i).getLatitude()*1e6),(int)(ApplicationInfo.locationData.get(i).getLongitude()*1e6));
			
			_geopoints.add(_point);
		}
		System.out.println("_geopoints.size() "+_geopoints.size());
		 MyOverLay _overlay = new MyOverLay();
		 List<Overlay> _listOverlay =_mapview.getOverlays();
		_listOverlay.add(_overlay);
		
		for(int i = 0;i<_geopoints.size();i++){
			
			_controller.animateTo(_geopoints.get(i));
		}
		_controller.setZoom(12);
		 _mapview.invalidate();
	}
	
	private class MyOverLay extends Overlay{
		
   	 @Override
        public boolean draw(Canvas canvas, MapView mapView, boolean shadow,
                long when) {
            super.draw(canvas, mapView, false);
                
                Paint mPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        		mPaint.setDither(true);
        		mPaint.setColor(0xFF5AA100);
        		mPaint.setStyle(Paint.Style.STROKE);
        		mPaint.setStrokeJoin(Paint.Join.MITER);
                mPaint.setStrokeCap(Paint.Cap.ROUND);
                mPaint.setStrokeWidth(3);
                mPaint.setStrokeMiter((float)0.0);
        		
        		Paint nPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        		nPaint.setDither(true);
        		nPaint.setColor(0x40A5CC75);
        		nPaint.setStyle(Paint.Style.FILL);
        		nPaint.setStrokeJoin(Paint.Join.MITER);
                mPaint.setStrokeCap(Paint.Cap.ROUND);

        		Path path = new Path();
        		
        		if(_geopoints.size() >= 1) {
        			for (int i = 0; i < _geopoints.size(); i++) 
        			{
        				GeoPoint gP1 = _geopoints.get(i);
        				Point currentScreenPoint = new Point();

        				Projection proj = _mapview.getProjection();
        				proj.toPixels(gP1, currentScreenPoint);
        				
        				Bitmap bmp = BitmapFactory.decodeResource(getResources(), R.drawable.pushpin_icon);
                      
                        canvas.drawBitmap(bmp, currentScreenPoint.x, currentScreenPoint.y - 24, null);

        				if (i == 0) {
        					path.moveTo(currentScreenPoint.x-24, currentScreenPoint.y-24);
        				}
        				else {
        					path.lineTo(currentScreenPoint.x-24, currentScreenPoint.y-24);
        				}
        				
        			}
        			 
        		}
//        		canvas.drawPath(path, nPaint);
        		canvas.drawPath(path, mPaint);
        		return true;
        	}
            
            
        }
   

	@Override
	protected boolean isRouteDisplayed() {
		// TODO Auto-generated method stub
		return false;
	}

}
