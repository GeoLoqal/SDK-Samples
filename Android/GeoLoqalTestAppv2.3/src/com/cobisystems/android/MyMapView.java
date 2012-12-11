package com.cobisystems.android;


import android.content.Context;
import android.util.AttributeSet;
import android.view.MotionEvent;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapView;

public class MyMapView extends MapView
{	
	
	public interface OnChangeListener
	{
		public void onChange(MapView view, GeoPoint newCenter, GeoPoint oldCenter, int newZoom, int oldZoom);
	}
	
	private MyMapView mThis;
	private long mEventsTimeout = 250L; 	
	private boolean mIsTouched = false;
	private GeoPoint mLastCenterPosition;
	private int mLastZoomLevel;
	private MyMapView.OnChangeListener mChangeListener = null;
	
	
	private Runnable mOnChangeTask = new Runnable()
	{
		@Override
		public void run()
		{
			if (mChangeListener != null) mChangeListener.onChange(mThis, getMapCenter(), mLastCenterPosition, getZoomLevel(), mLastZoomLevel);
			mLastCenterPosition = getMapCenter();
			mLastZoomLevel = getZoomLevel();			
		}
	};
	
	
	public MyMapView(Context context, String apiKey)
	{
		super(context, apiKey);
		init();
	}
	
	public MyMapView(Context context, AttributeSet attrs)
	{
		super(context, attrs);
		init();
	}
	
	public MyMapView(Context context, AttributeSet attrs, int defStyle)
	{
		super(context, attrs, defStyle);
		init();
	}
	
	private void init()
	{
		mThis = this;
		mLastCenterPosition = this.getMapCenter();
		mLastZoomLevel = this.getZoomLevel();
	}
	
		
	public void setOnChangeListener(MyMapView.OnChangeListener l)
	{
		mChangeListener = l;
	}

	
	
	@Override
	public boolean onTouchEvent(MotionEvent ev)
	{		
		// Set touch internal
		mIsTouched = (ev.getAction() != MotionEvent.ACTION_UP);

		return super.onTouchEvent(ev);
	}
	
	@Override
	public void computeScroll()
	{
		super.computeScroll();
		// Check for change
		if (isSpanChange() || isZoomChange())
		{
			resetMapChangeTimer();
		}
	}

	
	
	private void resetMapChangeTimer()
	{
		MyMapView.this.removeCallbacks(mOnChangeTask);
		MyMapView.this.postDelayed(mOnChangeTask, mEventsTimeout);
	}
	
	private boolean isSpanChange()
	{
		return !mIsTouched && !getMapCenter().equals(mLastCenterPosition);
	}
	
	private boolean isZoomChange()
	{
		return (getZoomLevel() != mLastZoomLevel);
	}
	
}