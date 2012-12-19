//
//  GeoLoqalTestViewController.h
//  GeoLoqalTest
//
//  Created by user on 30/10/12.
//  Copyright (c) 2012 GeoLoqal LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "GeoLoqalTestAppDelegate.h"

@interface GeoLoqalTestViewController : UIViewController<GeoLoqalDelegate,UIPickerViewDelegate,MKMapViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIApplicationDelegate>

@property(nonatomic)CLLocationCoordinate2D _locationCordinate;
@property(nonatomic,strong)GeoLoqalTestAppDelegate *_geoLoqalTestAppDelegate;

-(void)createTestCaseAlert;
-(void)createTriggerAlert;
-(void)drawPointOnMap;

@end
