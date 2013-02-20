//
//  GeoLoqalDemoAppDelegate.h
//  GeoLoqalDemo
//
//  Created by GeoLoqal Inc. on 06/02/13.
//  Copyright (c) 2013 GeoLoqal Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class GeoLoqalDemoViewController;

@interface GeoLoqalDemoAppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) GeoLoqalDemoViewController *viewController;

@property (nonatomic)CLLocationCoordinate2D coordinate;

@end
