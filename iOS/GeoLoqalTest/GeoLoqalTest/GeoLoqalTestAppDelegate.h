//
//  GeoLoqalTestAppDelegate.h
//  GeoLoqalTest
//
//  Created by user on 30/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class GeoLoqalTestViewController;

@interface GeoLoqalTestAppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) GeoLoqalTestViewController *viewController;

@property (nonatomic)CLLocationCoordinate2D coordinate;

-(void)startUpdateLocation;

@end
