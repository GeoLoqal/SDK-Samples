//
//  GeoLoqalTestViewController.m
//  GeoLoqalTest
//
//  Created by user on 30/10/12.
//  Copyright (c) 2012 GeoLoqal LLC. All rights reserved.
//

#import "GeoLoqalTestViewController.h"
#import "GLLocationManager.h"
#import "PointsOnMap.h"
#import "LineOnMap.h"
#import <QuartzCore/QuartzCore.h>
#import "GLConfig.h"

@implementation GeoLoqalTestViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

NSMutableArray *_testCaseNameArr;
NSMutableArray *_testCaseTypeArr;
NSMutableArray *_triggerNameArr;
UIPickerView *_pickerViewTestCase ;
UIPickerView *_pickerViewTrigger ;
UIButton *_showMapBtn;
UIButton *_showLineMapBtn;
UIButton *_showTestCaseBtn;
UIButton *_showTriggerBtn;
UIButton *_showPointBtn;
UIButton *_showNextLineMapBtn;
UIButton *_showCheckedTriggerBtn;
NSString *_selectTestCase;
NSString *_selectedTrigger;
GLLocationManager *_glLocationManager;
CLLocationCoordinate2D _location;
NSString *_triggerStatus;

NSMutableArray *_latArr;
NSMutableArray *_lonArr;
NSMutableArray *_latNextArr;
NSMutableArray *_lonNextArr;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"Geoloqal Test";
    
    _showTestCaseBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _showTestCaseBtn.frame = CGRectMake(10, 20,130, 30);
    _showTestCaseBtn.layer.cornerRadius = 6.0f;
    [_showTestCaseBtn setTitle:@"Show TestCases" forState:UIControlStateNormal];
    _showTestCaseBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [_showTestCaseBtn addTarget:self action:@selector(showPointBtnPressed) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_showTestCaseBtn];
    
    _showTriggerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _showTriggerBtn.layer.cornerRadius = 6.0f;
    _showTriggerBtn.frame = CGRectMake(180, 20, 130, 30);
    [_showTriggerBtn setTitle:@"Show Triggers" forState:UIControlStateNormal];
    _showTriggerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [_showTriggerBtn addTarget:self action:@selector(showTriggerPressed) forControlEvents:UIControlEventTouchDown];
    _showTriggerBtn.hidden = YES;
    [self.view addSubview:_showTriggerBtn];
    
    _pickerViewTestCase = [[UIPickerView alloc] init];
    _pickerViewTestCase.showsSelectionIndicator = YES;
    _pickerViewTestCase.frame=CGRectMake(0, 75, self.view.bounds.size.width/2, 190);
    _pickerViewTestCase.hidden = YES;
    _pickerViewTestCase.tag = 1;
    [self.view addSubview:_pickerViewTestCase];
    
    _pickerViewTrigger = [[UIPickerView alloc] init];
    _pickerViewTrigger.showsSelectionIndicator = YES;
    _pickerViewTrigger.frame=CGRectMake(165, 75, self.view.bounds.size.width/2, 190);
    _pickerViewTrigger.hidden = YES;
    _pickerViewTrigger.tag = 2;
    [self.view addSubview:_pickerViewTrigger];

    _showPointBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _showPointBtn.layer.cornerRadius = 6.0f;
    _showPointBtn.frame = CGRectMake(10, 280, 130, 30);
    [_showPointBtn setTitle:@"Show Point" forState:UIControlStateNormal];
    _showPointBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [_showPointBtn addTarget:self action:@selector(showTestPoint) forControlEvents:UIControlEventTouchDown];
    _showPointBtn.hidden = YES;
    //_showPointBtn.userInteractionEnabled = NO;
    [self.view addSubview:_showPointBtn];
    
    _showCheckedTriggerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _showCheckedTriggerBtn.frame = CGRectMake(180, 280, 130, 30);
    _showCheckedTriggerBtn.layer.cornerRadius = 6.0f;
    [_showCheckedTriggerBtn setTitle:@"Check Triggers" forState:UIControlStateNormal];
    _showCheckedTriggerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [_showCheckedTriggerBtn addTarget:self action:@selector(showIsTriggerPoint) forControlEvents:UIControlEventTouchDown];
    _showCheckedTriggerBtn.hidden = YES;
    [self.view addSubview:_showCheckedTriggerBtn];

    _showMapBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _showMapBtn.layer.cornerRadius = 6.0f;
    _showMapBtn.frame = CGRectMake(10, 340,  90, 30);
    [_showMapBtn setTitle:@"Point On Map" forState:UIControlStateNormal];
    _showMapBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [_showMapBtn addTarget:self action:@selector(showMapBtnPressed) forControlEvents:UIControlEventTouchDown];
    _showMapBtn.hidden = YES;
    //_showMapBtn.userInteractionEnabled = NO;
    [self.view addSubview:_showMapBtn];
    
    _showLineMapBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _showLineMapBtn.layer.cornerRadius = 6.0f;
    _showLineMapBtn.frame = CGRectMake(110, 340,  90, 30);
    [_showLineMapBtn setTitle:@"Line On Map" forState:UIControlStateNormal];
    _showLineMapBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [_showLineMapBtn addTarget:self action:@selector(showLineMapBtnPressed) forControlEvents:UIControlEventTouchDown];
    _showLineMapBtn.hidden = YES;
    //_showMapBtn.userInteractionEnabled = NO;
    [self.view addSubview:_showLineMapBtn];
    
    _showNextLineMapBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _showNextLineMapBtn.layer.cornerRadius = 6.0f;
    _showNextLineMapBtn.frame = CGRectMake(210, 340, 100, 30);
    [_showNextLineMapBtn setTitle:@"NextPointPath" forState:UIControlStateNormal];
    _showNextLineMapBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [_showNextLineMapBtn addTarget:self action:@selector(showNextLineMapBtnPressed) forControlEvents:UIControlEventTouchDown];
    _showNextLineMapBtn.hidden = YES;
    //_showMapBtn.userInteractionEnabled = NO;
    [self.view addSubview:_showNextLineMapBtn];
    
    _glLocationManager = [[GLLocationManager alloc] init];
    _glLocationManager.speed = 40;
    _glLocationManager.frequency = 5;
    _glLocationManager.delegate = self;
    
    _latArr = [[NSMutableArray alloc]init];
    _lonArr = [[NSMutableArray alloc]init];
    _latNextArr = [[NSMutableArray alloc]init];
    _lonNextArr = [[NSMutableArray alloc]init];
    _testCaseNameArr = [[NSMutableArray alloc]init];;
}
//delegate methods
-(void)geoPointLatitude :(double)lat longitude:(double)lon{
    NSLog(@"lat lon%f ==%f",lat,lon);  
    _location.latitude = lat;
    _location.longitude = lon;
//    _showPointBtn.userInteractionEnabled = YES;
//    _showMapBtn.userInteractionEnabled = YES;
    [_glLocationManager createInsideCircleTrigger:@"demoCircle" lat:[NSString stringWithFormat:@"%f",lat] lon:[NSString stringWithFormat:@"%f",lon] rad:20];
}
-(void)byAddressLatitude :(double)lat longitude:(double)lon{
    NSLog(@"latlonDirection%f ==%f",lat,lon);
    if(lat != 0.0){
        _location.latitude = lat;
        _location.longitude = lon;
        NSString *_lat = [NSString stringWithFormat:@"%f",lat];
        NSString *_lon = [NSString stringWithFormat:@"%f",lon];
        
        [_latArr addObject:_lat];
        [_lonArr addObject:_lon];
    }
    
    
//    _showPointBtn.userInteractionEnabled = YES;
//    _showMapBtn.userInteractionEnabled = YES;
}
-(void)bySequentialPolylineLatitude :(double)lat longitude:(double)lon{

  if(lat != 0.0){
        _location.latitude = lat;
        _location.longitude = lon;
      [_latNextArr addObject:[NSString stringWithFormat:@"%f",lat]];
      [_lonNextArr addObject:[NSString stringWithFormat:@"%f",lon]];
      NSLog(@"latlonNextPoint%f ==%f--count%d",lat,lon,_latNextArr.count);
    }
//    if (lat != 0.0) {
//        _showPointBtn.userInteractionEnabled = YES;
//        _showMapBtn.userInteractionEnabled = YES;
//    }
    
}
-(void)showPointBtnPressed
{
    [_glLocationManager getTestCaseNames];
    
}
-(void)showTriggerPressed{
    [_glLocationManager getTriggerNames];
}
-(void)showTestPoint{
    UIAlertView *_testPointAlert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"Latitude:= %f\nLongitude:= %f",_location.latitude,_location.longitude] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [_testPointAlert show];
}
-(void)showIsTriggerPoint{
    NSLog(@"Trigger status %@",_triggerStatus);
    if ([_triggerStatus isEqualToString:@"true"]) {
        UIAlertView *_testPointAlert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"Point Matches in Trigger"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_testPointAlert show];

    }else if([_triggerStatus isEqualToString:@"false"]){
        UIAlertView *_testPointAlert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"Point doesn't Matches in Trigger"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_testPointAlert show];
    }
}
//delegate method test case
-(void)testCaseName :(NSMutableArray *)testCasenames{
    NSLog(@"_testCaseNameArr %d",testCasenames.count); 
    
    _pickerViewTestCase.hidden = NO;
    _testCaseNameArr = [testCasenames mutableCopy];
    _pickerViewTestCase.delegate = self;
    _selectTestCase = [_testCaseNameArr objectAtIndex:0];
    if (_selectTestCase != nil) {
        
        [_glLocationManager registrationWithApiKey:GL_APIKey andTestCase:_selectTestCase];
    }
    _showTriggerBtn.hidden = NO;
    _showPointBtn.hidden = NO;
    _showMapBtn.hidden = NO;
    _showLineMapBtn.hidden = NO;
    _showNextLineMapBtn.hidden = NO;
}
-(void)triggerName :(NSMutableArray *)triggerNames{
    NSLog(@"triggerName %d",triggerNames.count);
    _pickerViewTrigger.hidden = NO;
    _showCheckedTriggerBtn.hidden = NO;
    _triggerNameArr = [triggerNames mutableCopy];
    _pickerViewTrigger.delegate = self;
    _selectedTrigger = [_triggerNameArr objectAtIndex:0];
    if (_selectedTrigger != nil) {
        [_glLocationManager getCheckedGeoTrigger:_selectedTrigger lat:[NSString stringWithFormat:@"%f",_location.latitude] lon:[NSString stringWithFormat:@"%f",_location.longitude]]; 
    }
    
}
-(void)triggerStatus :(NSString *)triggerStatus{
    _triggerStatus = triggerStatus; 
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 1) {
        NSLog(@"row %d",row);
        NSString *_selectedTestCase;
        _selectedTestCase =  [_testCaseNameArr objectAtIndex:row];
        NSLog(@"_selectTestCase %@",_selectedTestCase);
        if (_selectedTestCase != nil) {
            [_glLocationManager registrationWithApiKey:GL_APIKey andTestCase:_selectedTestCase];
        }
        
    }else if(pickerView.tag == 2){
        
        _selectedTrigger =  [_triggerNameArr objectAtIndex:row];
        NSLog(@"_selectedTrigger %@",_selectedTrigger);
        _showCheckedTriggerBtn.userInteractionEnabled = YES;
        if (_selectedTrigger != nil) {
            [_glLocationManager getCheckedGeoTrigger:_selectedTrigger lat:[NSString stringWithFormat:@"%f",_location.latitude] lon:[NSString stringWithFormat:@"%f",_location.longitude] ]; 
        }
        
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
-(void)showMapBtnPressed{
    
    PointsOnMap *_pointsOnMap = [[PointsOnMap alloc]init];
    if (_location.latitude != 0.0) {
        _pointsOnMap._locationCordinate = _location;
        [self.navigationController pushViewController:_pointsOnMap animated:YES];
    }
    
}
-(void)showLineMapBtnPressed{
    NSLog(@"showLineMapBtnPressed");
    LineOnMap *_lineOnMap = [[LineOnMap alloc]init];
    if (_latArr.count != 0 || _latArr != nil) {
        NSLog(@"showLineMapBtnPressed");
        _lineOnMap._latArray = [_latArr mutableCopy]; 
        _lineOnMap._lonArray = [_lonArr mutableCopy];
        [self.navigationController pushViewController:_lineOnMap animated:YES];
    }
    [_latArr removeAllObjects];
    [_lonArr removeAllObjects];
    
}
-(void)showNextLineMapBtnPressed{
    LineOnMap *_lineOnMap = [[LineOnMap alloc]init];
    if (_latNextArr.count != 0 || _latNextArr != nil) {
        NSLog(@"showNextLineMapBtnPressed");
        _lineOnMap._latArray = [_latNextArr mutableCopy]; 
        _lineOnMap._lonArray = [_lonNextArr mutableCopy];
        [self.navigationController pushViewController:_lineOnMap animated:YES];
    }
    [_latNextArr removeAllObjects];
    [_lonNextArr removeAllObjects];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
