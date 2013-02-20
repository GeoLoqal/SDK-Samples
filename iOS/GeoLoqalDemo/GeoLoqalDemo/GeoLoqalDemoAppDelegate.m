//
//  GeoLoqalDemoAppDelegate.m
//  GeoLoqalDemo
//
//  Created by GeoLoqal Inc. on 06/02/13.
//  Copyright (c) 2013 GeoLoqal Inc.. All rights reserved.
//

#import "GeoLoqalDemoAppDelegate.h"

#import "GeoLoqalDemoViewController.h"

@implementation GeoLoqalDemoAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize coordinate;

CLLocation *location;
CLLocation *_oldLocation;
CLLocation *_newLocation;
CLLocationManager *_locationManager;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    sleep(1);
    
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; 
    _locationManager.distanceFilter = 20.0;
    [_locationManager startUpdatingLocation];
    
    location = [_locationManager location];
    coordinate = [location coordinate];
    
    //set API key here e.g. - 4321563671276 
    [GLLocationManager setApiKey:@"SET YOUR API KEY"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[GeoLoqalDemoViewController alloc] initWithNibName:@"GeoLoqalDemoViewController" bundle:nil];
    self.viewController._locationCordinate = coordinate;
    UINavigationController *_nav = [[UINavigationController alloc]initWithRootViewController:self.viewController];
    self.window.rootViewController = _nav;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    NSLog(@"applicationDidEnterBackground");
    [GLLocationManager applicationDidEnterBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    NSLog(@"applicationDidBecomeActive");
    [GLLocationManager applicationDidEnterForeground];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
