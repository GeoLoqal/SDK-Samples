//
//  GeoLoqalDemoViewController.m
//  GeoLoqalDemo
//
//  Created by GeoLoqal Inc. on 06/02/13.
//  Copyright (c) 2013 GeoLoqal Inc.. All rights reserved.
//

#import "GeoLoqalDemoViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation GeoLoqalDemoViewController

@synthesize _locationCordinate;
@synthesize _geoLoqalTestAppDelegate;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
NSMutableArray *_testCaseNameArr;
NSMutableArray *_testCaseTypeArr;

NSMutableArray *_triggerNameArr;
NSMutableArray *_groupTriggerNameArr;

NSMutableArray *_layersNameArr;
NSMutableArray *_publicLayersNameArr;

UIPickerView *_pickerViewTestCase ;
UIPickerView *_pickerViewTrigger ;

UIButton *_showTestCaseBtn;
UIButton *_showTriggerBtn;

NSString *_selectTestCase;
NSString *_selectedTrigger;
NSString *_selectedTestCase;
NSString *_selectTrigger;
NSString *_selectedTestType;
NSString *_selectTestType;
//NSString *_testTypeStr;

NSString *_selectedTriggerGroup;
NSString *_selectTriggerGroup;

GLLocationManager *_glLocationManager;
CLLocationCoordinate2D _location;
NSString *_triggerStatus;
UIButton *_startTestBtn;

UIButton *_showGroupTriggerBtn;
UIButton *_checkTriggerBtn;

MKMapView *_mapView;

UIActionSheet *actionSheetTestCase;
UIActionSheet *actionSheetTrigger;

UIActivityIndicatorView *_searchActivity;

UIActionSheet *actionSheetGroupTrigger;
UIPickerView *_pickerViewGroupTrigger;

UIActionSheet *actionSheetLayers;
UIPickerView *_pickerViewLayers;
UIActionSheet *actionSheetPublicLayers;
UIPickerView *_pickerViewPublicLayers;

UIView *_triggerMatchedView;
UIView *_triggerGroupedMatchedView;
UILabel *_triggerMatchedLabel;
UILabel *_triggerGroupedMatchedLabel;

NSTimer *_directionTimer;

BOOL _btnStartPressed;
BOOL _viewShow;
BOOL _viewGroupedShow;

////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"GeoLoqal Demo";
    
    _viewShow = NO;
    
    _glLocationManager = [[GLLocationManager alloc] init];
    _glLocationManager.unitOfSpeed = @"kph";
    _glLocationManager.delegate = self;
    _glLocationManager.testMode = Test_GL;
    _glLocationManager.frequency = 10.0;
    _glLocationManager.logMode = LogMode_DEBUG;

//    [_glLocationManager reverseGeoCode:39.677242432 longitude:-104.53425];
//    [_glLocationManager geoCode:@"Denver,CO"];
//    [_glLocationManager getPlaces:39.567348 longitude:-104.78816535 provider:@"google" radius:5000 query:@"school"];
    
    _testCaseNameArr = [[NSMutableArray alloc]init];
    _testCaseTypeArr = [[NSMutableArray alloc]init];
    
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    
    _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
    _mapView.delegate = self;
    _mapView.zoomEnabled = YES;
    _mapView.scrollEnabled = YES;
    _mapView.mapType = MKMapTypeStandard;
    _mapView.showsUserLocation = YES;
    NSLog(@"_locationCordinate %f",_locationCordinate.latitude);
    [self.view addSubview:_mapView];
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=0.2;
    span.longitudeDelta=0.2;
    region.span=span;
    region.center=_locationCordinate;
    [_mapView setRegion:region animated:TRUE];
    [_mapView regionThatFits:region];
    
    UIButton *_showLayersBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _showLayersBtn.frame = CGRectMake(30, 310, 100, 30);
    [_showLayersBtn setTitle:@"Layers" forState:UIControlStateNormal];
    _showLayersBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [_showLayersBtn addTarget:self action:@selector(showLayers) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_showLayersBtn];
    
    UIButton *_showPublicLayersBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _showPublicLayersBtn.frame = CGRectMake(160, 310, 100, 30);
    [_showPublicLayersBtn setTitle:@"Public Layers" forState:UIControlStateNormal];
    _showPublicLayersBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [_showPublicLayersBtn addTarget:self action:@selector(showPublicLayers) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_showPublicLayersBtn];
    
    _showTestCaseBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _showTestCaseBtn.frame = CGRectMake(7, 344,100, 30);
    [_showTestCaseBtn setTitle:@"TestCases" forState:UIControlStateNormal];
    _showTestCaseBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [_showTestCaseBtn addTarget:self action:@selector(showPointBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    if (_glLocationManager.testMode == Test_GL) {
        _showTestCaseBtn.enabled = YES;
        
    }else if (_glLocationManager.testMode == Test_PROD){
        _showTestCaseBtn.enabled = NO;
    }
    [self.view addSubview:_showTestCaseBtn];
    
    _showTriggerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _showTriggerBtn.frame = CGRectMake(110, 344, 100, 30);
    [_showTriggerBtn setTitle:@"GeoTargeting" forState:UIControlStateNormal];
    _showTriggerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [_showTriggerBtn addTarget:self action:@selector(showTriggerPressed) forControlEvents:UIControlEventTouchUpInside];
    _showTriggerBtn.enabled = YES;
    [self.view addSubview:_showTriggerBtn];
    
    _startTestBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _startTestBtn.frame = CGRectMake(213, 344, 100, 30);
    [_startTestBtn setTitle:@"Start Test" forState:UIControlStateNormal];
    _startTestBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [_startTestBtn addTarget:self action:@selector(startTestPressed:) forControlEvents:UIControlEventTouchUpInside];
    _startTestBtn.enabled = YES;
    [self.view addSubview:_startTestBtn];
    
    _showGroupTriggerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _showGroupTriggerBtn.frame = CGRectMake(50, 380, 120, 30);
    [_showGroupTriggerBtn setTitle:@"Trigger Groups" forState:UIControlStateNormal];
    _showGroupTriggerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [_showGroupTriggerBtn addTarget:self action:@selector(showGroupTriggerPressed) forControlEvents:UIControlEventTouchUpInside];
//    if (_glLocationManager.testMode == Test_GL) {
//        _showGroupTriggerBtn.enabled = YES;
//        
//    }else if (_glLocationManager.testMode == Test_PROD){
//        _showGroupTriggerBtn.enabled = NO;
//        
//    }
    [self.view addSubview:_showGroupTriggerBtn];
    
    _checkTriggerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _checkTriggerBtn.frame = CGRectMake(180, 380, 120, 30);
    [_checkTriggerBtn setTitle:@"Check Trigger" forState:UIControlStateNormal];
    _checkTriggerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [_checkTriggerBtn addTarget:self action:@selector(checkGroupTrigger) forControlEvents:UIControlEventTouchDown];
    _checkTriggerBtn.enabled = YES;
    [self.view addSubview:_checkTriggerBtn];

}


-(void)showLayers{
    _layersNameArr = [[NSMutableArray alloc]init];
    [_glLocationManager getLayersList];  
    [self createLayersAlert];
}
-(void)showPublicLayers{
    _publicLayersNameArr = [[NSMutableArray alloc]init];
    [_glLocationManager getPublicLayers];
    [self createPublicLayersAlert];
}
-(void)showGroupTriggerPressed
{
    [_glLocationManager getTriggerGroups];
    [self createTriggerGroupsAlert];
}

-(void)createTriggerGroupsAlert{
    
    actionSheetGroupTrigger = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [actionSheetGroupTrigger showInView:self.view];
    [actionSheetGroupTrigger setBounds:CGRectMake(0, 0, 320, 470.0)];
    
    _pickerViewGroupTrigger = [[UIPickerView alloc] init];
    _pickerViewGroupTrigger.showsSelectionIndicator = YES;
    _pickerViewGroupTrigger.frame=CGRectMake(0, 44, 320,250);
    _pickerViewGroupTrigger.tag = 3;
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.backgroundColor = [UIColor redColor];
    pickerToolbar.barStyle = UIBarStyleBlack;
    [pickerToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *btnBarSaveTrigger = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(btnBarSaveGroupTriggerClicked)];
    [barItems addObject:btnBarSaveTrigger];
    
    UIBarButtonItem *btnBarCancelTrigger = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(btnBarCancelGroupTriggerClicked)];
    [barItems addObject:btnBarSaveTrigger];
    [barItems addObject:btnBarCancelTrigger];
    
    [pickerToolbar setItems:barItems animated:YES];
    
    [actionSheetGroupTrigger addSubview:pickerToolbar];
    [actionSheetGroupTrigger addSubview:_pickerViewGroupTrigger];
    
}
-(void)btnBarSaveGroupTriggerClicked
{
    if (_selectTriggerGroup == nil && _groupTriggerNameArr != nil && _groupTriggerNameArr.count>0) {
        _selectTriggerGroup = [_groupTriggerNameArr objectAtIndex:0];
        _selectTriggerGroup = _selectedTriggerGroup;
        _checkTriggerBtn.enabled = YES;
    }else{
        _selectedTriggerGroup = _selectTriggerGroup;
        _checkTriggerBtn.enabled = YES;
    }
    
    [actionSheetGroupTrigger dismissWithClickedButtonIndex:0 animated:YES];
}
-(void)btnBarCancelGroupTriggerClicked
{
    _selectedTriggerGroup = nil;
    [actionSheetGroupTrigger dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)checkGroupTrigger
{
    _btnStartPressed = NO;
    if (_glLocationManager.testMode == Test_GL) {
        if (_selectedTestCase != nil) {
            if (_selectTestType != nil) {
                
                if ([_selectTestType isEqualToString:@"By Polyline"] || [_selectTestType isEqualToString:@"By Polygon"] || [_selectTestType isEqualToString:@"By Circle"] || [_selectTestType isEqualToString:@"By Layers"]) {
                    [_glLocationManager getGeoPoint:_selectedTestCase];
                    
                }else if([_selectTestType isEqualToString:@"By Address"]){
                    
                    [_glLocationManager getDirectionPoint:_selectedTestCase speed:40];
                    
                }else if([_selectTestType isEqualToString:@"By Sequential Polyline"]){
                    [_glLocationManager getNextPoint:_selectedTestCase];
                }
            }
        }
        if (_selectedTriggerGroup != nil) {
            if (_selectedTestCase != nil) {
                if ([_selectTestType isEqualToString:@"By Address"]) {
                    if (![_directionTimer isValid]) {
                        [[[UIAlertView alloc] initWithTitle:nil message:@"You have to start the test" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];   
                    }else{
                        [_glLocationManager checkGroupTrigger:_selectedTriggerGroup lat:0.0 lng:0.0 checkCriteria:CriteriaAll];
                        
                    }
                }else{
                    [_glLocationManager checkGroupTrigger:_selectedTriggerGroup lat:0.0 lng:0.0 checkCriteria:CriteriaAll];
                }
                
            }else{
                [[[UIAlertView alloc] initWithTitle:nil message:@"You have to associate a test case with this trigger" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            }
        }
    }else if(_glLocationManager.testMode == Test_PROD){
        if (_selectedTestCase == nil ){
            if(_selectedTriggerGroup != nil)
            {
                [_glLocationManager checkGroupGeoTrigger:_selectedTriggerGroup checkCriteriaType:CriteriaAll];
//                [_glLocationManager checkBatterySafeGroupGeoTrigger:_selectedTriggerGroup checkCriteriaType:CriteriaAll];
//                [_glLocationManager checkIPBasedGroupGeoTrigger:_selectedTriggerGroup checkCriteriaType:CriteriaAll];
                if (_selectedTrigger != nil) {
                   _startTestBtn.hidden = NO; 
                }
                
            }else{
                [[[UIAlertView alloc] initWithTitle:nil message:@"Choose a trigger group" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show]; 
            }
        }
    }
    
}
-(void)createTestCaseAlert{
    
    actionSheetTestCase = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [actionSheetTestCase showInView:self.view];
    [actionSheetTestCase setBounds:CGRectMake(0, 0, 320, 470.0)];
    
    _pickerViewTestCase = [[UIPickerView alloc] init];
    _pickerViewTestCase.showsSelectionIndicator = YES;
    _pickerViewTestCase.frame=CGRectMake(0, 44, 320,250);
    _pickerViewTestCase.tag = 1;
    
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
-(void)createLayersAlert{
    
    actionSheetLayers = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [actionSheetLayers showInView:self.view];
    [actionSheetLayers setBounds:CGRectMake(0, 0, 320, 470.0)];
    
    _pickerViewLayers = [[UIPickerView alloc] init];
    _pickerViewLayers.showsSelectionIndicator = YES;
    _pickerViewLayers.frame=CGRectMake(0, 44, 320,250);
    _pickerViewLayers.tag = 4;
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.backgroundColor = [UIColor redColor];
    pickerToolbar.barStyle = UIBarStyleBlack;
    [pickerToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *btnBarSaveTestCase = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(btnBarSaveLayrsClicked)];
    
    UIBarButtonItem *btnBarCancelTestCase = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(btnBarCancelClicked)];
    [barItems addObject:btnBarSaveTestCase];
    [barItems addObject:btnBarCancelTestCase];
    
    [pickerToolbar setItems:barItems animated:YES];
    
    [actionSheetLayers addSubview:pickerToolbar];
    [actionSheetLayers addSubview:_pickerViewLayers];
}
-(void)btnBarSaveLayrsClicked{
    [actionSheetLayers dismissWithClickedButtonIndex:0 animated:YES]; 
}
-(void)createPublicLayersAlert{
    
    actionSheetPublicLayers = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [actionSheetPublicLayers showInView:self.view];
    [actionSheetPublicLayers setBounds:CGRectMake(0, 0, 320, 470.0)];
    
    _pickerViewPublicLayers = [[UIPickerView alloc] init];
    _pickerViewPublicLayers.showsSelectionIndicator = YES;
    _pickerViewPublicLayers.frame=CGRectMake(0, 44, 320,250);
    _pickerViewPublicLayers.tag = 5;
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.backgroundColor = [UIColor redColor];
    pickerToolbar.barStyle = UIBarStyleBlack;
    [pickerToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *btnBarSaveTestCase = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(btnBarSavePublicLayersClicked)];
    
    UIBarButtonItem *btnBarCancelTestCase = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(btnBarCancelClicked)];
    [barItems addObject:btnBarSaveTestCase];
    [barItems addObject:btnBarCancelTestCase];
    
    [pickerToolbar setItems:barItems animated:YES];
    
    [actionSheetPublicLayers addSubview:pickerToolbar];
    [actionSheetPublicLayers addSubview:_pickerViewPublicLayers];
}
-(void)btnBarSavePublicLayersClicked{
   [actionSheetPublicLayers dismissWithClickedButtonIndex:0 animated:YES];  
}
-(void)btnBarSaveTestCaseClicked{
    
    if (_selectTestCase == nil && _testCaseNameArr != nil && _testCaseNameArr.count>0) {
        _selectTestCase = [_testCaseNameArr objectAtIndex:0];
        _selectedTestCase = _selectTestCase;
        _selectTestCase = [_testCaseTypeArr objectAtIndex:0];
        _selectedTestType = _selectTestType;
        _startTestBtn.enabled = YES;
    }else{
        _selectedTestCase = _selectTestCase;
        _selectedTestType = _selectTestType;
        _startTestBtn.enabled = YES;
    }
    
    [actionSheetTestCase dismissWithClickedButtonIndex:0 animated:YES];  
}
-(void)btnBarCancelClicked{
    
    _selectedTestCase = nil;
    [actionSheetTestCase dismissWithClickedButtonIndex:0 animated:YES];   
    [actionSheetLayers dismissWithClickedButtonIndex:0 animated:YES];
    [actionSheetPublicLayers dismissWithClickedButtonIndex:0 animated:YES];
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

-(void)notificationToShow:(NSString*)code{
    
    if (!_viewGroupedShow) {
        _triggerMatchedView = [[UIView alloc]initWithFrame:CGRectMake(60, 240,200, 40)];
        _triggerMatchedView.layer.cornerRadius = 5.0f;
        _triggerMatchedView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:_triggerMatchedView];
    }else{
        NSLog(@" !_triggerGroupedMatchedView");
        _triggerMatchedView = [[UIView alloc]initWithFrame:CGRectMake(60, 190,200, 40)];
        _triggerMatchedView.layer.cornerRadius = 5.0f;
        _triggerMatchedView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:_triggerMatchedView];
    }
    
    _triggerMatchedLabel = [[UILabel alloc]initWithFrame:_triggerMatchedView.frame];
    _triggerMatchedLabel.textAlignment = UITextAlignmentCenter;
    _triggerMatchedLabel.textColor = [UIColor whiteColor];
    _triggerMatchedLabel.text = code;
    _triggerMatchedLabel.layer.cornerRadius = 5.0f;
    _triggerMatchedLabel.backgroundColor = [UIColor clearColor];
    _triggerMatchedLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:_triggerMatchedLabel];
    
    CATransition *_transition = [CATransition animation];
    _transition.duration = 1.0;
    _transition.delegate = self;
    _transition.type = kCATransitionFade; 
    _transition.subtype = kCATransitionFromLeft;
    [_triggerMatchedView.layer addAnimation:_transition forKey:nil];
    
    _startTestBtn.enabled = NO;
    
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    NSLog(@"animationDidStop");
    if (_triggerMatchedView.hidden == NO) {
        _triggerMatchedView.hidden = YES;
        _triggerMatchedLabel.hidden = YES;
        _startTestBtn.enabled = YES;
    }
    if (_triggerGroupedMatchedView.hidden == NO) {
        _triggerGroupedMatchedView.hidden = YES;
        _triggerGroupedMatchedLabel.hidden = YES;
        _checkTriggerBtn.enabled = YES;
    }
    
}
-(void)notificationShow:(NSString*)code{
    
    _checkTriggerBtn.enabled = NO;
    
    if (!_viewShow) {
        
        _triggerGroupedMatchedView = [[UIView alloc]initWithFrame:CGRectMake(60, 240,200, 40)];
        _triggerGroupedMatchedView.layer.cornerRadius = 5.0f;
        _triggerGroupedMatchedView.backgroundColor = [UIColor lightGrayColor];
        
        [self.view addSubview:_triggerGroupedMatchedView];  
    }else{
        _triggerGroupedMatchedView = [[UIView alloc]initWithFrame:CGRectMake(60,190,200, 40)];
        _triggerGroupedMatchedView.layer.cornerRadius = 5.0f;
        _triggerGroupedMatchedView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:_triggerGroupedMatchedView];
    }
    _triggerGroupedMatchedLabel = [[UILabel alloc]initWithFrame:_triggerGroupedMatchedView.frame];
    _triggerGroupedMatchedLabel.textAlignment = UITextAlignmentCenter;
    _triggerGroupedMatchedLabel.textColor = [UIColor whiteColor];
    _triggerGroupedMatchedLabel.text = code;
    _triggerGroupedMatchedLabel.layer.cornerRadius = 5.0f;
    _triggerGroupedMatchedLabel.backgroundColor = [UIColor clearColor];
    _triggerGroupedMatchedLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:_triggerGroupedMatchedLabel];
    
    CATransition *_transition = [CATransition animation];
    _transition.duration = 1.0;
    _transition.delegate = self;
    _transition.type = kCATransitionFade; 
    _transition.subtype = kCATransitionFromLeft;
    [_triggerGroupedMatchedView.layer addAnimation:_transition forKey:nil];
    
}
-(void)showPointBtnPressed
{
    
    [_glLocationManager getTestcases];
    if (_testCaseNameArr != nil) {
        [self createTestCaseAlert];
    }
    
}
-(void)showTriggerPressed{
    
    
    [_glLocationManager getTriggers];
    if (_triggerNameArr != nil) {
        [self createTriggerAlert];
    }
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 1) {
        
        _selectTestCase =  [_testCaseNameArr objectAtIndex:row]; 
        _selectTestType = [_testCaseTypeArr objectAtIndex:row];
        NSLog(@"_selectedTrigger %@",_selectTestCase);
    }else if(pickerView.tag == 2){
        
        _selectedTrigger =  [_triggerNameArr objectAtIndex:row];
        NSLog(@"_selectedTrigger %@",_selectedTrigger);
    }else if(pickerView.tag == 3){
        
        _selectTriggerGroup =  [_groupTriggerNameArr objectAtIndex:row];
        NSLog(@"_selectedTrigger %@",_selectTriggerGroup);
    }else if(pickerView.tag == 4){
        
    }else if(pickerView.tag == 5){
        
    }
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    if (pickerView.tag == 1) {
        return [_testCaseNameArr count];
    }else if(pickerView.tag == 2){
        return [_triggerNameArr count];
    }else if(pickerView.tag == 3){
        return [_groupTriggerNameArr count];
    }else if(pickerView.tag == 4){
        return [_layersNameArr count];
    }else if(pickerView.tag == 5){
        return [_publicLayersNameArr count];
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
    }else if(pickerView.tag == 3){
        UILabel *_label = (UILabel *)view;
        _label= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
        _label.font = [UIFont boldSystemFontOfSize:18.0];
        _label.textAlignment = UITextAlignmentLeft;
        _label.textColor = [UIColor darkGrayColor];
        _label.text = [_groupTriggerNameArr objectAtIndex:row];
        [pickerView addSubview:_label];
        return _label;
    }else if(pickerView.tag == 4){
        UILabel *_label = (UILabel *)view;
        _label= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
        _label.font = [UIFont boldSystemFontOfSize:18.0];
        _label.textAlignment = UITextAlignmentLeft;
        _label.textColor = [UIColor darkGrayColor];
        _label.text = [_layersNameArr objectAtIndex:row];
        [pickerView addSubview:_label];
        return _label;

    }else if(pickerView.tag == 5){
        UILabel *_label = (UILabel *)view;
        _label= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
        _label.font = [UIFont boldSystemFontOfSize:18.0];
        _label.textAlignment = UITextAlignmentLeft;
        _label.textColor = [UIColor darkGrayColor];
        _label.text = [_publicLayersNameArr objectAtIndex:row];
        [pickerView addSubview:_label];
        return _label;

    }
    return nil;
}

-(void)timeIntervalForDirectionPoint{
    if (_directionTimer == nil) {
        
        _directionTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(repeatCall) userInfo:nil repeats:YES];
    }
    
}
-(void)repeatCall{
    
    if (_selectTestType != nil) {
        
        if ([_selectTestType isEqualToString:@"By Polyline"] || [_selectTestType isEqualToString:@"By Polygon"] || [_selectTestType isEqualToString:@"By Circle"] || [_selectTestType isEqualToString:@"By Layers"]) {
            [_glLocationManager getGeoPoint:_selectedTestCase];
            
        }else if([_selectTestType isEqualToString:@"By Address"]){
            
            [_glLocationManager getDirectionPoint:_selectedTestCase speed:60];
            
        }else if([_selectTestType isEqualToString:@"By Sequential Polyline"]){
            [_glLocationManager getNextPoint:_selectedTestCase];
        }
    }
}   
-(void)invalidateTimer{
    NSLog(@"invalidateTimer");
    if ([_directionTimer isValid]) {
        [_directionTimer invalidate];
        _directionTimer = nil;
        
    }
}
-(void)startTestPressed:(UIButton *)_btn{
    _btnStartPressed = YES;
    /////// for changing start and Stop btn titile///////////////
    if ([_selectedTestType isEqualToString:@"By Address"]) {
        if ([_startTestBtn.titleLabel.text isEqualToString:@"Stop Test"]) {
            [self invalidateTimer];
            [_startTestBtn setTitle:@"Start Test" forState:UIControlStateNormal];
        }else if ([_startTestBtn.titleLabel.text isEqualToString:@"Start Test"]) {
            [self timeIntervalForDirectionPoint];
            [_startTestBtn setTitle:@"Stop Test" forState:UIControlStateNormal];
        }
        
    }
    if (_selectedTestCase != nil) {
        if (_selectTestType != nil) {
            if ([_selectTestType isEqualToString:@"By Polyline"] || [_selectTestType isEqualToString:@"By Polygon"] || [_selectTestType isEqualToString:@"By Circle"] || [_selectTestType isEqualToString:@"By Layers"]) {
                [_glLocationManager getGeoPoint:_selectedTestCase];
                
            }else if([_selectTestType isEqualToString:@"By Address"]){
                
                [_glLocationManager getDirectionPoint:_selectedTestCase speed:60];
                
            }else if([_selectTestType isEqualToString:@"By Sequential Polyline"]){
                [_glLocationManager getNextPoint:_selectedTestCase];
            }
        }
        _startTestBtn.hidden = NO;
    }else{
        if (_glLocationManager.testMode == Test_GL) {
            
            if (_selectedTrigger != nil)  {
                [[[UIAlertView alloc] initWithTitle:nil message:@"You have to associate a test case with this trigger" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            }     
        }else if (_glLocationManager.testMode == Test_PROD) {
            if (_selectedTestCase == nil) {
                if (_selectedTrigger != nil) {
                    _showTriggerBtn.enabled = YES;
                    //////precisionHigh//////
                    //[_glLocationManager checkGeoTrigger:_selectedTrigger];
                    //////precisionMedium///
                    [_glLocationManager checkBatterySafeGeoTrigger:_selectedTrigger];
                    /////precisionLow/////
                    //[_glLocationManager checkIPBasedGeoTrigger:_selectedTrigger];
                }
            }else{
                [[[UIAlertView alloc] initWithTitle:nil message:@"choose one trigger" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            }
            
        }
    }
    
}
-(void)drawPointOnMap{
    
    CLLocationCoordinate2D coords;
    coords.latitude = _location.latitude;
    coords.longitude = _location.longitude;
    
    [_mapView setCenterCoordinate:coords animated:YES];
    
    if (_mapView.annotations.count > 0) {
        [_mapView removeAnnotation:[_mapView.annotations objectAtIndex:0]];
    }
    MKPointAnnotation *_pointAnnotation = [[MKPointAnnotation alloc]init];
    _pointAnnotation.coordinate = coords;
    [_mapView addAnnotation:_pointAnnotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{ 
    static NSString *placemarkIdentifier = @"placemark_identifier";
    
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:placemarkIdentifier];
    if (annotationView == nil) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:placemarkIdentifier];
    } else {
        annotationView.annotation = annotation;
    }
    
    annotationView.canShowCallout = YES;
    UIImage *_image = [UIImage imageNamed:@"geoloqallogo.png"];
    annotationView.image = _image;
    annotationView.centerOffset = CGPointMake(0.0, -_image.size.height/2);
    return annotationView;
}

///////////////////////////////////////////////////
////////////////  GEOLOQAL Delegate  Methods //////
///////////////////////////////////////////////////

-(void)testCaseName :(NSMutableArray *)testCaseNames:(NSMutableArray *)testCaseType{
    
    _testCaseNameArr = [testCaseNames mutableCopy];
    _testCaseTypeArr = [testCaseType mutableCopy];
    _pickerViewTestCase.delegate = self;
    if (_glLocationManager.testMode == Test_GL) {
        _selectTestCase = [_testCaseNameArr objectAtIndex:0];
        _selectTestType = [_testCaseTypeArr objectAtIndex:0];
    }
}
-(void)triggerName :(NSMutableArray *)triggerNames{
    
    _triggerNameArr = [triggerNames mutableCopy];
    _pickerViewTrigger.delegate = self;
    _selectedTrigger = [_triggerNameArr objectAtIndex:0];
    
}
-(void)triggerStatus :(NSString *)triggerStatus{
    NSLog(@"trigger status %@",triggerStatus);
    //_viewGroupedShow = NO;
    if (![_selectedTestType isEqualToString:@"By Address"]) {
        [self notificationToShow:[NSString stringWithFormat:@"Trigger Code:\"%@\"",triggerStatus]];
        
    }        
    
}
-(void)triggerGroupName :(NSMutableArray *)groupNames
{
    NSLog(@"Trigger groups %@",groupNames);
    _groupTriggerNameArr = [groupNames mutableCopy];
    _pickerViewGroupTrigger.delegate = self;
    _selectedTriggerGroup = [_groupTriggerNameArr objectAtIndex:0];
    
}
-(void)groupedTriggerStatus :(NSString *)triggerStatus
{
    _triggerStatus = [NSString stringWithFormat:@" Grouped Trigger Code:\"%@\"",triggerStatus];
    NSLog(@"Group Trigger Status %@",triggerStatus);
    
    //_viewShow = NO;
    if (![_selectedTestType isEqualToString:@"By Address"]) {
        [self notificationShow:_triggerStatus];        
    }  
}
-(void)geoLoqalLocationLatitude :(double)lat longitude:(double)lon{
    NSLog(@"lat lon%f == %f",lat,lon);  
    _location.latitude = lat;
    _location.longitude = lon;
    [self drawPointOnMap];
    if (_btnStartPressed) {
        if (_selectTrigger != nil) {
            [_glLocationManager checkGeoTrigger:_selectTrigger lat:_location.latitude lon:_location.longitude]; 
        } 
    }else {
        
        if (_selectedTriggerGroup != nil) {
            
            [_glLocationManager checkGroupTrigger:_selectedTriggerGroup lat:_location.latitude lng:_location.longitude checkCriteria:CriteriaAll];
        }
    }
    
}
-(void)glGeoCodeLocation:(id)location
{
    NSLog(@"GeoCode Location %@",location);
}
-(void)glReverseGeoCodePlace:(id)place
{
    NSLog(@"Reverse GeoCode Address %@",place);
}

-(void)allTestcaseGroups :(NSMutableArray *)testcaseGroups
{
    NSLog(@"allTestcaseGroups %@",testcaseGroups);
}
-(void)didFailedWithGeoCodeError:(NSString*)error{
    NSLog(@"didFailedWithGeoCodeError %@",error);
}
-(void)didFailedWithReverseGeoCodeError:(NSString*)error{
    NSLog(@"didFailedWithReverseGeoCodeError %@",error);
}
-(void)testcaseType :(NSString *)testcaseType
{
    NSLog(@"testcaseType %@",testcaseType);
}
//// Method to get the list of layers ////
-(void)layersList :(NSMutableArray *)layers
{
    NSLog(@"layersList %@",layers);
    _layersNameArr = [layers mutableCopy];
    _pickerViewLayers.delegate = self;
}

//// Method to get the list of public layers ////
-(void)publicLayersList :(NSMutableArray *)publicLayers
{
    NSLog(@"publicLayersList %@",publicLayers);
    _publicLayersNameArr = [publicLayers mutableCopy];
    _pickerViewPublicLayers.delegate = self;
}

//// Method to get the list of points inside a layers ////
-(void)layerPointsList :(NSMutableArray *)layerPoints
{
    NSLog(@"layerPointsList %@",layerPoints);
}

///// Delegate methods for geoloqal get places API ///
-(void)geoLoqalGetPlaces :(NSMutableArray *)places
{
    NSLog(@"geoLoqalGetPlaces %@",places);
}
////////end all delegate Imaplementation/////////

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
