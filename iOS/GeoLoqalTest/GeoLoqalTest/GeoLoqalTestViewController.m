//
//  GeoLoqalTestViewController.m
//  GeoLoqalTest
//
//  Created by user on 30/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GeoLoqalTestViewController.h"
#import "GLLocationManager.h"
#import <QuartzCore/QuartzCore.h>

@implementation GeoLoqalTestViewController

@synthesize _locationCordinate;
@synthesize _geoLoqalTestAppDelegate;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

NSMutableArray *_testCaseNameArr;

NSMutableArray *_triggerNameArr;
UIPickerView *_pickerViewTestCase ;
UIPickerView *_pickerViewTrigger ;

UIButton *_showTestCaseBtn;
UIButton *_showTriggerBtn;

NSString *_selectTestCase;
NSString *_selectedTrigger;
NSString *_selectedTestCase;
NSString *_selectTrigger;

GLLocationManager *_glLocationManager;
CLLocationCoordinate2D _location;
NSString *_triggerStatus;
UIButton *_startTestBtn;

MKMapView *_mapView;

UIActionSheet *actionSheetTestCase;
UIActionSheet *actionSheetTrigger;

UIActivityIndicatorView *_searchActivity;;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"GeoLoqal Test";
    
    _glLocationManager = [[GLLocationManager alloc] init];
    _glLocationManager.speed = 100;
    _glLocationManager.outputType = @"json";
    _glLocationManager.delegate = self;
    
    _testCaseNameArr = [[NSMutableArray alloc]init];
    
    _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 385)];
    _mapView.delegate = self;
    _mapView.zoomEnabled = YES;
    _mapView.scrollEnabled = YES;
    _mapView.mapType = MKMapTypeStandard;
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=0.2;
    span.longitudeDelta=0.2;
    region.span=span;
    region.center=_locationCordinate;
    [_mapView setRegion:region animated:TRUE];
    [_mapView regionThatFits:region];
    
    _showTestCaseBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _showTestCaseBtn.frame = CGRectMake(2, 384,100, 30);
    _showTestCaseBtn.layer.cornerRadius = 6.0f;
    [_showTestCaseBtn setTitle:@"TestCases" forState:UIControlStateNormal];
    _showTestCaseBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [_showTestCaseBtn addTarget:self action:@selector(showPointBtnPressed) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_showTestCaseBtn];
    
    _showTriggerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _showTriggerBtn.layer.cornerRadius = 6.0f;
    _showTriggerBtn.frame = CGRectMake(110, 384, 100, 30);
    [_showTriggerBtn setTitle:@"GeoTargeting" forState:UIControlStateNormal];
    _showTriggerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [_showTriggerBtn addTarget:self action:@selector(showTriggerPressed) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_showTriggerBtn];
    
    _startTestBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _startTestBtn.layer.cornerRadius = 6.0f;
    _startTestBtn.frame = CGRectMake(218, 384, 100, 30);
    [_startTestBtn setTitle:@"Start Test" forState:UIControlStateNormal];
    _startTestBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [_startTestBtn addTarget:self action:@selector(startTestPressed) forControlEvents:UIControlEventTouchDown];
    _startTestBtn.enabled = NO;
    [self.view addSubview:_startTestBtn];
    

    NSLog(@"current locatin%f--",_locationCordinate.latitude);
    
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    float batteryLevel = [[UIDevice currentDevice] batteryLevel];
    NSLog(@"batteryLevel %f",batteryLevel);
}
-(void)createTestCaseAlert{
    
    actionSheetTestCase = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [actionSheetTestCase showInView:self.view];
    [actionSheetTestCase setBounds:CGRectMake(0, 0, 320, 470.0)];
    
    _pickerViewTestCase = [[UIPickerView alloc] init];
    _pickerViewTestCase.showsSelectionIndicator = YES;
    _pickerViewTestCase.frame=CGRectMake(0, 44, 320,250);
    _pickerViewTestCase.tag = 1;
    _pickerViewTestCase.delegate = self;
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.backgroundColor = [UIColor redColor];
    pickerToolbar.barStyle = UIBarStyleBlack;
    [pickerToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *btnBarSaveTestCase = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(btnBarSaveTestCaseClicked)];
    
    UIBarButtonItem *btnBarCancelTestCase = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(btnBarCancelClicked)];
    [barItems addObject:btnBarSaveTestCase];
    [barItems addObject:btnBarCancelTestCase];
    
    [pickerToolbar setItems:barItems animated:YES];
    
    [actionSheetTestCase addSubview:pickerToolbar];
    [actionSheetTestCase addSubview:_pickerViewTestCase];
}
-(void)createTriggerAlert{
    
    actionSheetTrigger = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [actionSheetTrigger showInView:self.view];
    [actionSheetTrigger setBounds:CGRectMake(0, 0, 320, 470.0)];
    
    _pickerViewTrigger = [[UIPickerView alloc] init];
    _pickerViewTrigger.showsSelectionIndicator = YES;
    _pickerViewTrigger.frame=CGRectMake(0, 44, 320,250);
    _pickerViewTrigger.delegate = self;
    _pickerViewTrigger.tag = 2;
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.backgroundColor = [UIColor redColor];
    pickerToolbar.barStyle = UIBarStyleBlack;
    [pickerToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *btnBarSaveTrigger = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(btnBarSaveTriggerClicked)];
    [barItems addObject:btnBarSaveTrigger];
    
    UIBarButtonItem *btnBarCancelTrigger = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(btnBarCancelTriggerClicked)];
    [barItems addObject:btnBarSaveTrigger];
    [barItems addObject:btnBarCancelTrigger];
    
    [pickerToolbar setItems:barItems animated:YES];
    
    [actionSheetTrigger addSubview:pickerToolbar];
    [actionSheetTrigger addSubview:_pickerViewTrigger];
    
}
-(void)btnBarSaveTestCaseClicked{
    
    if (_selectTestCase == nil && _testCaseNameArr != nil && _testCaseNameArr.count>0) {
        _selectTestCase = [_testCaseNameArr objectAtIndex:0];
        _selectedTestCase = _selectTestCase;
        _startTestBtn.enabled = YES;
    }else{
        _selectedTestCase = _selectTestCase;
        _startTestBtn.enabled = YES;
    }
    
    [actionSheetTestCase dismissWithClickedButtonIndex:0 animated:YES];  
}
-(void)btnBarCancelClicked{
    
    _selectedTestCase = nil;
    [actionSheetTestCase dismissWithClickedButtonIndex:0 animated:YES];   
}
-(void)btnBarSaveTriggerClicked{
    
    if (_selectedTrigger == nil && _triggerNameArr.count>0) {

        _selectedTrigger = [_triggerNameArr objectAtIndex:0];
        _selectTrigger = _selectedTrigger;
        _startTestBtn.enabled = YES;
    }else {
        
        _selectTrigger = _selectedTrigger;
        _startTestBtn.enabled = YES;
    }
    
    [actionSheetTrigger dismissWithClickedButtonIndex:0 animated:YES];
}
-(void)btnBarCancelTriggerClicked{
    
    _selectTrigger = nil;
    [actionSheetTrigger dismissWithClickedButtonIndex:0 animated:YES]; 
}

                      /////delegate methods test case////

-(void)testCaseName :(NSMutableArray *)testCasenames{
    NSLog(@"_testCaseNameArr %d",testCasenames.count); 
    
    _testCaseNameArr = [testCasenames mutableCopy];
    _pickerViewTestCase.delegate = self;
    _selectTestCase = [_testCaseNameArr objectAtIndex:0];
    
}
-(void)triggerName :(NSMutableArray *)triggerNames{
    NSLog(@"triggerName %d",triggerNames.count);
    
    _triggerNameArr = [triggerNames mutableCopy];
    _pickerViewTrigger.delegate = self;
    _selectedTrigger = [_triggerNameArr objectAtIndex:0];

}
-(void)triggerStatus :(NSString *)triggerStatus{
    
    _triggerStatus = triggerStatus; 
    
    if ([_triggerStatus isEqualToString:@"true"]) {
        
        UIAlertView *_testPointAlert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"Trigger Matched"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_testPointAlert show];
    }
}

-(void)geoLoqalPointLatitude :(double)lat longitude:(double)lon{
    NSLog(@"lat lon%f ==%f",lat,lon);  
    _location.latitude = lat;
    _location.longitude = lon;
     [self drawPointOnMap];
    if (_selectTrigger != nil) {
        [_glLocationManager getCheckedGeoTriggerName:_selectTrigger lat:[NSString stringWithFormat:@"%f",_location.latitude] lon:[NSString stringWithFormat:@"%f",_location.longitude]]; 
    }

//    [_glLocationManager createInsideCircleTrigger:@"demoCircle" lat:[NSString stringWithFormat:@"%f",lat] lon:[NSString stringWithFormat:@"%f",lon] rad:20];
}
            ////////end all delegate Imaplementation/////////
        
-(void)showPointBtnPressed
{
    [self createTestCaseAlert];
    [_glLocationManager getTestCaseNames];
    
}
-(void)showTriggerPressed{
    
    [self createTriggerAlert];
    [_glLocationManager getTriggerNames];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 1) {
        NSLog(@"row %d",row);
        _selectTestCase =  [_testCaseNameArr objectAtIndex:row];        
    }else if(pickerView.tag == 2){
        
        _selectedTrigger =  [_triggerNameArr objectAtIndex:row];
        NSLog(@"_selectedTrigger %@",_selectedTrigger);
    }
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    if (pickerView.tag == 1) {
        return [_testCaseNameArr count];
    }else if(pickerView.tag == 2){
        return [_triggerNameArr count];
    }
    return 0; 
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (pickerView.tag == 1) {
        UILabel *_label = (UILabel *)view;
        _label= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
        _label.font = [UIFont boldSystemFontOfSize:18.0];
        _label.text = [_testCaseNameArr objectAtIndex:row];
        _label.textAlignment = UITextAlignmentLeft;
        _label.textColor = [UIColor darkGrayColor];
        [pickerView addSubview:_label];
        return _label;
    }else if(pickerView.tag == 2){
        UILabel *_label = (UILabel *)view;
        _label= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
        _label.font = [UIFont boldSystemFontOfSize:18.0];
        _label.textAlignment = UITextAlignmentLeft;
        _label.textColor = [UIColor darkGrayColor];
        _label.text = [_triggerNameArr objectAtIndex:row];
        [pickerView addSubview:_label];
        return _label;
    }
    return nil;
}
-(void)startTestPressed{
    
    if (_selectedTestCase != nil) {
        NSLog(@"startTestPressed %@",_selectedTestCase);
        [_glLocationManager registrationWithTestCase:_selectedTestCase];
        _startTestBtn.hidden = NO;
    }else{
        
        if (_selectedTrigger != nil) {
            [[[UIAlertView alloc] initWithTitle:nil message:@"You have to associate a test case with this trigger" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
        
    }

}
-(void)drawPointOnMap{
        
    NSLog(@"drawPointOnMap _location.latitude %f",_location.latitude);
    CLLocationCoordinate2D coords;
    coords.latitude = _location.latitude;
    coords.longitude = _location.longitude;
    
    //_mapView.centerCoordinate = coords;
    [_mapView setCenterCoordinate:coords animated:YES];
    
    if (_mapView.annotations.count > 0) {
        [_mapView removeAnnotation:[_mapView.annotations objectAtIndex:0]];
    }
    MKPointAnnotation *_pointAnnotation = [[MKPointAnnotation alloc]init];
    _pointAnnotation.coordinate = coords;
    [_mapView addAnnotation:_pointAnnotation];
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{

    
    MKAnnotationView *pinView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"pin"];
    pinView.canShowCallout = YES;
    UIImage *_image = [UIImage imageNamed:@"geoloqallogo.png"];
    pinView.image = _image;
    pinView.centerOffset = CGPointMake(0.0, -_image.size.height/2);
        return pinView;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}
- (void)readPlist;
{
    NSString *filePath = @"/SWAGATIKA/My Apps/GeoloqalSDK/GeoLoqalSDK/10DecModificationGeoloqalSDK/GeoLoqalTest/GeoLoqalTest/GeoLoqalTest-Info.plist";
    NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    NSArray *_allKeys = [plistDict allKeys];
    for (int i=0; i<_allKeys.count; i++) {
        NSLog(@"readPlist %@",[_allKeys objectAtIndex:i]);
    }
    NSString *value;
    value = [plistDict objectForKey:@"CFBundleDisplayName"];
    
    /* You could now call the string "value" from somewhere to return the value of the string in the .plist specified, for the specified key. */
}

- (void)writeToPlist;
{
    NSString *filePath = @"/SWAGATIKA/My Apps/GeoloqalSDK/GeoLoqalSDK/10DecModificationGeoloqalSDK/GeoLoqalTest/GeoLoqalTest/GeoLoqalTest-Info.plist";
    NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    
    [plistDict setValue:@"GeoLoqalTest_App" forKey:@"CFBundleDisplayName"];
    [plistDict writeToFile:filePath atomically: YES];
    
    /* This would change the firmware version in the plist to 1.1.1 by initing the NSDictionary with the plist, then changing the value of the string in the key "ProductVersion" to what you specified */
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[self writeToPlist];
    //[self readPlist];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
