package com.geoloqal.android;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapView;
import com.google.android.maps.Overlay;

public class MyOverlay extends Overlay
{	
	
	public interface OnTapListener
	{
		public void onTap(MapView v, GeoPoint geoPoint);
	}
	
	public void setOnTapListener(OnTapListener listener)
	{
		mTapListener = listener;
	}

	
	private OnTapListener mTapListener;
	
	@Override
	public boolean onTap(GeoPoint geoPoint, MapView mapView)
	{
		mTapListener.onTap(mapView, geoPoint);
		return super.onTap(geoPoint, mapView);
	}
}