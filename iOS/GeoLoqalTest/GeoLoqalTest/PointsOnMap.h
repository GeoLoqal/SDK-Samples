//
//  PointsOnMap.h
//  GeoLoqalTest
//
//  Created by GeoLoqal LLC on 31/10/12.
//  Copyright (c) 2012 GeoLoqal LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface PointsOnMap : UIViewController<MKMapViewDelegate>

@property(nonatomic)CLLocationCoordinate2D _locationCordinate;
//@property(nonatomic,strong)NSMutableArray *_latArray;
//@property(nonatomic,strong)NSMutableArray *_lonArray;
//@property(nonatomic,strong)MKPolyline *_routeLine;
//@property(nonatomic,strong)MKPolylineView *_routeLineView;
//
//-(void)drawLineOnMap;

@end
