//
//  PointsOnMap.m
//  GeoLoqalTest
//
//  Created by GeoLoqal LLC on 31/10/12.
//  Copyright (c) 2012 GeoLoqal LLC. All rights reserved.
//

#import "PointsOnMap.h"


@implementation PointsOnMap

@synthesize _locationCordinate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

NSString *_destLati;
NSString *_destLongi;
MKMapView *_mapView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _mapView = [[MKMapView alloc]initWithFrame:self.view.frame];
    _mapView.delegate = self;
    _mapView.zoomEnabled = YES;
    _mapView.scrollEnabled = YES;
    _mapView.mapType = MKMapTypeStandard;
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
    
    NSLog(@"_location %f--%f",_locationCordinate.latitude,_locationCordinate.longitude);
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=0.2;
    span.longitudeDelta=0.2;
    region.span=span;
    region.center=_locationCordinate;
    [_mapView setRegion:region animated:TRUE];
    [_mapView regionThatFits:region];
    
    MKPointAnnotation *_pointAnnotation = [[MKPointAnnotation alloc]init];
    _pointAnnotation.coordinate = _locationCordinate;
    [_mapView addAnnotation:_pointAnnotation];
    
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    NSLog(@"_location %f--%f",_locationCordinate.latitude,_locationCordinate.longitude);
    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"pin"]; 
    pinView.pinColor = MKPinAnnotationColorRed; 
    pinView.canShowCallout = YES;
    pinView.animatesDrop = YES;
    return pinView;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
