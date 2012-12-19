//
//  GeoLoqalTestAppDelegate.m
//  GeoLoqalTest
//
//  Created by user on 30/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GeoLoqalTestAppDelegate.h"

#import "GeoLoqalTestViewController.h"

#import "GLLocationManager.h"

@implementation GeoLoqalTestAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize coordinate;

CLLocation *location;
CLLocation *_oldLocation;
CLLocation *_newLocation;
CLLocationManager *_locationManager;
NSTimer *_locationTimer;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    sleep(1);
    
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; 
    _locationManager.distanceFilter = 50.0;
    
     location = [_locationManager location];
     coordinate = [location coordinate];
     NSLog(@"coordinate %f",coordinate.latitude);
    
//    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus]!=kCLAuthorizationStatusDenied) {
//        [self startUpdateLocation];
//    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[GeoLoqalTestViewController alloc] initWithNibName:@"GeoLoqalTestViewController" bundle:nil];
    self.viewController._locationCordinate = coordinate;
    UINavigationController *_nav = [[UINavigationController alloc]initWithRootViewController:self.viewController];
    self.window.rootViewController = _nav;
    [self.window makeKeyAndVisible];
    
            //set API key here
    [GLLocationManager setApiKey:@"INSERT YOUR API KEY HERE"];
    
    
    return YES;
}
-(void)startUpdateLocation{
    
    NSLog(@"startUpdateLocation");
    
    if ((_newLocation.coordinate.latitude == _oldLocation.coordinate.latitude || _newLocation.coordinate.longitude == _oldLocation.coordinate.longitude)) {
        NSLog(@"in same place");
        [_locationManager stopUpdatingLocation];
        [_locationManager stopMonitoringSignificantLocationChanges];
        [_locationTimer invalidate];
    } 

}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    _oldLocation = oldLocation;
    _newLocation  = newLocation;
    //for testing
    NSDate *_time = newLocation.timestamp;
    NSTimeInterval _timeInteval = [_time timeIntervalSinceNow];
    NSLog(@"_timeInteval %d--%f",abs(_timeInteval),newLocation.horizontalAccuracy);
    
//    if((newLocation.horizontalAccuracy > 100) || (abs(_timeInteval) > 500)){
//        
//        NSLog(@"stopUpdatingLocation");
//        [_locationManager stopUpdatingLocation];
//     }
    
    _locationTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(startUpdateLocation) userInfo:nil repeats:NO];
    
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    
    NSLog(@"applicationWillResignActive");
    [_locationManager stopUpdatingLocation];
    [_locationManager startMonitoringSignificantLocationChanges];

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    NSLog(@"applicationDidEnterBackground");
    [_locationManager stopUpdatingLocation];
    [_locationManager startMonitoringSignificantLocationChanges];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    NSLog(@"applicationWillEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    NSLog(@"applicationDidBecomeActive"); 
    [_locationManager stopMonitoringSignificantLocationChanges];
    [_locationManager startUpdatingLocation];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    NSLog(@"applicationWillTerminate");
}

@end
