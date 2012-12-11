//
//  GeoLoqalTestViewController.h
//  GeoLoqalTest
//
//  Created by user on 30/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface GeoLoqalTestViewController : UIViewController<GeoLoqalDelegate,UIPickerViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate,UIAlertViewDelegate,UIActionSheetDelegate>

@property(nonatomic)CLLocationCoordinate2D _locationCordinate;

-(void)createTestCaseAlert;
-(void)createTriggerAlert;
-(void)drawPointOnMap;

@end
