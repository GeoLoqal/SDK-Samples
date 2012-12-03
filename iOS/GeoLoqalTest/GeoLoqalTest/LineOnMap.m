//
//  LineOnMap.m
//  GeoLoqalTest
//
//  Created by GeoLoqal LLC on 05/11/12.
//  Copyright (c) 2012 GeoLoqal LLC. All rights reserved.
//

#import "LineOnMap.h"
#import "NVPolylineAnnotationView.h"


@implementation LineOnMap

@synthesize _routeLine,_routeLineView,_latArray,_lonArray,mapView;
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
MKMapRect _routeRect;
NSMutableArray *_points;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    mapView = [[MKMapView alloc]initWithFrame:self.view.frame];
    mapView.delegate = self;
    mapView.zoomEnabled = YES;
    mapView.scrollEnabled = YES;
    mapView.mapType = MKMapTypeStandard;
    mapView.showsUserLocation = YES;
    [self.view addSubview:mapView];
    
    _points = [[NSMutableArray alloc]init];
    for (int i=0; i<_latArray.count; i++) {
        
    NSLog(@"drawLineOnMap ewwe%@-- %@",[_latArray objectAtIndex:i],[_lonArray objectAtIndex:i]);
//        CLLocation *_pointLocation = [[CLLocation alloc]initWithLatitude:[[_latArray objectAtIndex:i] doubleValue] longitude:[[_lonArray objectAtIndex:i] doubleValue]];
//        [_points addObject:_pointLocation];
//        MKCoordinateRegion region;
//        MKCoordinateSpan span;
//        span.latitudeDelta=0.1;
//        span.longitudeDelta=0.1;
//        region.span=span;
//        region.center=_pointLocation.coordinate;
//        [mapView setRegion:region animated:TRUE];
//        [mapView regionThatFits:region];
//
//        MKPointAnnotation *_pointAnnotation = [[MKPointAnnotation alloc]init];
//        _pointAnnotation.coordinate = _pointLocation.coordinate;
//        [mapView addAnnotation:_pointAnnotation];
        
    }
//    MKCoordinateRegion region;
//	region.span.longitudeDelta = 0.219727;
//	region.span.latitudeDelta = 0.221574;
//	region.center.latitude = 45.452424;
//	region.center.longitude = -73.662643;
//	[mapView setRegion:region];

//    NVPolylineAnnotation *annotation = [[NVPolylineAnnotation alloc] initWithPoints:_points mapView:mapView];
//    [mapView addAnnotation:annotation];
        [self drawLineOnMap];
    
}
-(void)drawLineOnMap{
    
    CLLocationCoordinate2D coords[_latArray.count];
    for (int i=0; i<_latArray.count; i++) {
        NSLog(@"drawLineOnMap1");
        
        coords[i].latitude = [[_latArray objectAtIndex:i] doubleValue];
        coords[i].longitude = [[_lonArray objectAtIndex:i] doubleValue];

        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta=0.1;
        span.longitudeDelta=0.1;
        region.span=span;
        region.center=coords[i];
        [mapView setRegion:region animated:TRUE];
        [mapView regionThatFits:region];
        
        MKPointAnnotation *_pointAnnotation = [[MKPointAnnotation alloc]init];
        _pointAnnotation.coordinate = coords[i];
        [mapView addAnnotation:_pointAnnotation];
    }
    MKPolyline* line = [MKPolyline polylineWithCoordinates:coords count:_latArray.count];
    [mapView addOverlay:line];
   
    
}
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id )overlay
{
    NSLog(@":");
//    MKOverlayView* overlayView = nil;
//    
//    if(overlay == self._routeLine)
//    {
//        if(self._routeLineView == nil)
//        {
//            self._routeLineView = [[MKPolylineView alloc] initWithPolyline:self._routeLine];
//            self._routeLineView.fillColor = [UIColor redColor];
//            self._routeLineView.strokeColor = [UIColor redColor];
//            self._routeLineView.lineWidth = 3;
//        }        
//        overlayView = self._routeLineView;
//    }
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    
    polylineView.strokeColor = [UIColor blueColor];
    
    polylineView.lineWidth = 3.0;
    return polylineView;
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"pin"]; 
    pinView.pinColor = MKPinAnnotationColorPurple; 
    pinView.canShowCallout = YES;
    pinView.animatesDrop = YES;
    return pinView;
    
//    if ([annotation isKindOfClass:[NVPolylineAnnotation class]]) {
//		return [[NVPolylineAnnotationView alloc] initWithAnnotation:annotation mapView:mapView];
//	}
//    return nil;
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
