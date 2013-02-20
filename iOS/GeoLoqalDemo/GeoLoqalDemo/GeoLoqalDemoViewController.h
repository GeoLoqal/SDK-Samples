//
//  GeoLoqalDemoViewController.h
//  GeoLoqalDemo
//
//  Created by GeoLoqal Inc. on 06/02/13.
//  Copyright (c) 2013 GeoLoqal Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "GeoLoqalDemoAppDelegate.h"
#import <QuartzCore/CALayer.h>

@interface GeoLoqalDemoViewController : UIViewController<GeoLoqalDelegate,UIPickerViewDelegate,MKMapViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIApplicationDelegate>

@property(nonatomic)CLLocationCoordinate2D _locationCordinate;
@property(nonatomic,strong)GeoLoqalDemoAppDelegate *_geoLoqalTestAppDelegate;

-(void)createTestCaseAlert;
-(void)createTriggerAlert;
-(void)drawPointOnMap;
-(void)notificationToShow:(NSString*)code;
-(void)notificationShow:(NSString*)code;
-(void)timeIntervalForDirectionPoint;
-(void)invalidateTimer;
-(void)createTriggerGroupsAlert;
-(void)createLayersAlert;
-(void)createPublicLayersAlert;
@end
