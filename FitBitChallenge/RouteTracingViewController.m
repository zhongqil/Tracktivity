//
//  RouteTracingViewController.m
//  FitBitChallenge
//
//  Created by 李中琦 on 13-11-20.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import "RouteTracingViewController.h"
#import "FinishViewController.h"

static NSString const *kNormalType = @"Normal";
static NSString const *kSatelliteType = @"Satellite";
static NSString const *kHybridType = @"Hybrid";
static NSString const *kTerrainType = @"Terrain";

static CGFloat koverlayHeight = 140.0f;
static float kAccuracy = 0.00005f; // worth 5.5 m

#define  UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define postTimeDuration @"http://lawson.cis.utas.edu.au/~zhongqil/fitBitTest/IndieTrack.php"

float latitude, longtitude;

@implementation RouteTracingViewController {
    BOOL isTrackingCamera;
    BOOL flyButtonTapped;
    
    NSTimer *awakeTimer;
    
    UIBarButtonItem *optionButton;
    UISegmentedControl *switcher;
    UIView *overlay;
    UIView *topOverlay;
    UIButton *finishPointButton;
    UIButton *toDestination;
    UIButton *cameraTracking;
    UILabel *clockLabel;
    
    NSDate *startDate;
    
    GMSPolyline *route;
    GMSMutablePath *myPath;
    GMSMapView  *mapView;
    CLLocationManager *manager;
    GMSMarker         *locationMarker_;
}

@synthesize timer;
@synthesize backgroundTask;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // Create a GMSCameraPosition that tells the map to display Launceston
    
    isTrackingCamera = TRUE;
    flyButtonTapped = FALSE;
    
    latitude = [[[NSUserDefaults standardUserDefaults] stringForKey:@"Latitude"] floatValue];
    longtitude = [[[NSUserDefaults standardUserDefaults] stringForKey:@"Longtitude"] floatValue];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                            longitude:longtitude
                                                                 zoom:17];
    
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.settings.indoorPicker = NO;
    mapView.settings.myLocationButton = NO;
    mapView.padding = UIEdgeInsetsMake(0, 0, koverlayHeight, 0);
    self.view = mapView;
    
    // Create a rightBarButton to trigger display the options
    optionButton = [[UIBarButtonItem alloc] initWithTitle:@"Options"
                                                       style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(optionButtonTapped)];
    self.navigationItem.rightBarButtonItem = optionButton;
    
    
    // Create a Tap gesture
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTap:)];
    tapGesture.delegate = self;
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tapGesture];
    
    // Create Clock Timer
    clockLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, 0, 50)];
    clockLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |
                                  UIViewAutoresizingFlexibleWidth;
    [clockLabel setFont:[UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Futura"] objectAtIndex:3] size:25]];
    [clockLabel setTextColor:[UIColor orangeColor]];
    clockLabel.textAlignment = NSTextAlignmentCenter;
    clockLabel.backgroundColor = [UIColor blackColor];
    clockLabel.userInteractionEnabled = YES;
    
    startDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_Start"];
    [self startTimer];
    
    // Control camera tracking.
    cameraTracking = [[UIButton alloc] init];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        cameraTracking.frame = CGRectMake(0, 0, 100, 50);
    } else {
        cameraTracking.frame = CGRectMake(0, 0, 256, 50);
    }
    
    cameraTracking.clipsToBounds = YES;
    [cameraTracking addTarget:self action:@selector(didChangeCameraControl:) forControlEvents:UIControlEventTouchUpInside];
    [cameraTracking setTitle:@"Tracking" forState:UIControlStateNormal];
    [cameraTracking setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cameraTracking.backgroundColor = [UIColor greenColor];
    cameraTracking.titleLabel.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Futura"] objectAtIndex:3] size:23];
    [clockLabel addSubview:cameraTracking];
    
    
    // Create the fly to Destination Button.
    toDestination = [[UIButton alloc] init];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        toDestination.frame = CGRectMake(220, 0, 100, 50);
    } else {
        toDestination.frame = CGRectMake(512, 0, 256, 50);
    }
    
    toDestination.clipsToBounds = YES;
    toDestination.backgroundColor = [UIColor orangeColor];
    [toDestination addTarget:self action:@selector(didTapFlyToDestination:) forControlEvents:UIControlEventTouchUpInside];
    [toDestination setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
    [toDestination setTitle:@"To Finish" forState:UIControlStateNormal];
    toDestination.titleLabel.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Futura"] objectAtIndex:3] size:23];
    [clockLabel addSubview:toDestination];
    
    [self.view addSubview:clockLabel];
    
    // Create the option panel
    CGRect overlayFrame = CGRectMake(0, -koverlayHeight, 0, koverlayHeight);
    overlay = [[UIView alloc] initWithFrame:overlayFrame];
    overlay.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |
                                UIViewAutoresizingFlexibleWidth;
    overlay.frame = CGRectMake(0, mapView.bounds.size.height, self.view.bounds.size.width, 0);
    mapView.padding = UIEdgeInsetsZero;
    overlay.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8f];
    [self.view addSubview:overlay];
    
    // Create the finish Button to push the Finish line viewcontroller.
    finishPointButton = [[UIButton alloc] init];
    finishPointButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |
                                         UIViewAutoresizingFlexibleWidth |
                                         UIViewAutoresizingFlexibleBottomMargin;
    finishPointButton.frame = CGRectMake(0, 0, 0, koverlayHeight/2.f);
    [finishPointButton addTarget:self action:@selector(finishButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    finishPointButton.backgroundColor = [UIColor colorWithRed:235/255.0f green:124/255.0f blue:9/255.0f alpha:0.8f];
    [finishPointButton setTitle:@"Destination" forState:UIControlStateNormal];
    finishPointButton.titleLabel.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Futura"] objectAtIndex:3] size:25];
    [finishPointButton setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    [overlay addSubview:finishPointButton];
    
    // The possible different types to show.
    NSArray *types = @[kNormalType, kSatelliteType, kHybridType, kTerrainType];
    
    // Create a UISegmentControl that is the navigationitem's titleView.
    switcher = [[UISegmentedControl alloc] initWithItems:types];
    switcher.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |
                                 UIViewAutoresizingFlexibleWidth |
                                 UIViewAutoresizingFlexibleBottomMargin;
    switcher.frame = CGRectMake(0, koverlayHeight/2.f, 0, koverlayHeight/2.f);
    switcher.selectedSegmentIndex = 0;
    [switcher setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Futura"] objectAtIndex:0] size:15], NSFontAttributeName,
                                       [UIColor orangeColor], NSForegroundColorAttributeName,
                                       nil]
                             forState:UIControlStateNormal];
    [switcher setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Futura"] objectAtIndex:3] size:21], NSFontAttributeName,
                                       [UIColor orangeColor], NSForegroundColorAttributeName,
                                       nil]
                             forState:UIControlStateSelected];
    [switcher setTintColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.8f]];
    [overlay addSubview:switcher];
    
    // Listen to touch events on the UISegmentControl.
    [switcher addTarget:self
                  action:@selector(didChangeswitcher)
        forControlEvents:UIControlEventValueChanged];

    [self awakeTopOverlay];
    
    
    // Setup location services
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"Please enable location services");
        return;
    }
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        NSLog(@"Please authorize location services");
        return;
    }
    
    manager = [[CLLocationManager alloc] init];
    manager.delegate = self;
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    manager.distanceFilter = 5.0f;
    [manager startUpdatingLocation];
}

#pragma mark - Top Panel Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)OnTap: (UITapGestureRecognizer *) tapGesture {
    CGPoint p = [tapGesture locationInView:clockLabel];
    
    // In case the background of the label isn't transparent...
    UIColor *labelBackgroundColor = clockLabel.backgroundColor;
    clockLabel.backgroundColor = [UIColor clearColor];
    
    // Get a UIImage of the label
    UIGraphicsBeginImageContext(clockLabel.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [clockLabel.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Restore the label's background..
    clockLabel.backgroundColor = labelBackgroundColor;
    
    // draw the pixel we're interested in into a 1x1 bitmap
    unsigned char pixel = 0x00;
    context = CGBitmapContextCreate(&pixel,
                                    1,
                                    1,
                                    8,
                                    1,
                                    NULL,
                                    kCGImageAlphaOnly);
    UIGraphicsPushContext(context);
    [img drawAtPoint:CGPointMake(-p.x, -p.y)];
    UIGraphicsPopContext();
    CGContextRelease(context);
    
    if (pixel != 0) {
        //NSLog(@"Touched text");
        [self awakeTopOverlay];
    }
}

- (void) awakeTopOverlay {
    [awakeTimer invalidate];
    clockLabel.backgroundColor = [UIColor blackColor];
    cameraTracking.alpha = 1.0f;
    toDestination.alpha = 1.0f;
    [cameraTracking setEnabled:YES];
    [toDestination setEnabled:YES];
    awakeTimer = [NSTimer scheduledTimerWithTimeInterval:10.f
                                                  target:self
                                                selector:@selector(sleepTopOverlay)
                                                userInfo:nil
                                                 repeats:NO];
}

- (void) sleepTopOverlay {
    clockLabel.backgroundColor = [UIColor clearColor];
    cameraTracking.alpha = 0.2f;
    toDestination.alpha = 0.2f;
    [cameraTracking setEnabled:NO];
    [toDestination setEnabled:NO];
}

- (void) didChangeCameraControl: (id) sender {
    NSLog(@"camera Control");
    if (isTrackingCamera || flyButtonTapped) {
        isTrackingCamera = NO;
        flyButtonTapped = NO;
        [cameraTracking setTitle:@"Browsing" forState:UIControlStateNormal];
        [cameraTracking setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cameraTracking.backgroundColor = [UIColor redColor];
        cameraTracking.titleLabel.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Futura"] objectAtIndex:0] size:18];
    } else {
        isTrackingCamera = YES;
        flyButtonTapped = NO;
        [cameraTracking setTitle:@"Tracking" forState:UIControlStateNormal];
        [cameraTracking setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cameraTracking.backgroundColor = [UIColor greenColor];
        cameraTracking.titleLabel.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Futura"] objectAtIndex:3] size:23];
    }
}

- (void) startTimer {
    timer = [NSTimer scheduledTimerWithTimeInterval:1.f
                                             target:self
                                           selector:@selector(timerTick)
                                           userInfo:nil
                                            repeats:YES];
    
    
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"BackGround");
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
}

- (void) stopTimer {
    [self updateTimeDuration];
    [timer invalidate];
    timer = nil;
    if (self.backgroundTask != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }
}

- (void)timerTick {
    @autoreleasepool {
        NSDate *currentDate = [NSDate date];
        NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:startDate];
        NSDate *timeDuration = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
        static NSDateFormatter *dateFormatter;
        if( !dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"HH:mm:ss";
            [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
        }
        clockLabel.text = [dateFormatter stringFromDate:timeDuration];
    }
}

- (void) didTapFlyToDestination: (id) sender {
    NSLog(@"to finish");
    flyButtonTapped = YES;
    [self didChangeCameraControl:sender];
    
    mapView.layer.cameraLatitude = latitude;
    mapView.layer.cameraLongitude = longtitude;
    mapView.layer.cameraBearing = 0.0;
    
    // Access the GMSMapLayer directly to modify the following properties with a
    // specified timing function and duration.
    
    CAMediaTimingFunction *curve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CABasicAnimation *animation;
    
    animation = [CABasicAnimation animationWithKeyPath:kGMSLayerCameraLatitudeKey];
    animation.duration = 2.0f;
    animation.timingFunction = curve;
    animation.toValue = @(latitude);
    [mapView.layer addAnimation:animation forKey:kGMSLayerCameraLatitudeKey];
    
    animation = [CABasicAnimation animationWithKeyPath:kGMSLayerCameraLongitudeKey];
    animation.duration = 2.0f;
    animation.timingFunction = curve;
    animation.toValue = @(longtitude);
    [mapView.layer addAnimation:animation forKey:kGMSLayerCameraLongitudeKey];
    
    animation = [CABasicAnimation animationWithKeyPath:kGMSLayerCameraBearingKey];
    animation.duration = 2.0f;
    animation.timingFunction = curve;
    animation.toValue = @(0.0);
    [mapView.layer addAnimation:animation forKey:kGMSLayerCameraBearingKey];
    
    // FLy out to the minimum zoom and then zoon back to the current zoom.
    CGFloat zoom = mapView.camera.zoom;
    NSArray *keyValues = @[@(zoom), @(kGMSMinZoomLevel), @(zoom)];
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:kGMSLayerCameraZoomLevelKey];
    keyFrameAnimation.duration = 2.0f;
    keyFrameAnimation.values = keyValues;
    [mapView.layer addAnimation:keyFrameAnimation forKey:kGMSLayerCameraZoomLevelKey];
    
    GMSMarker *destination_ = [[GMSMarker alloc] init];
    destination_.position = CLLocationCoordinate2DMake(latitude, longtitude);
    destination_.title = [[NSUserDefaults standardUserDefaults] stringForKey:@"Dest_Title"];
    destination_.snippet = [[NSUserDefaults standardUserDefaults] stringForKey:@"Dest_Snippet"];
    destination_.appearAnimation = kGMSMarkerAnimationPop;
    destination_.map = mapView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
}

#pragma mark - Bottom Panel Delegate

- (void)optionButtonTapped {
    UIEdgeInsets padding = mapView.padding;
    
    [UIView animateWithDuration:0.4 animations:^{
        CGSize size = self.view.bounds.size;
        if (padding.bottom == 0.0f) {
            overlay.frame = CGRectMake(0, size.height - koverlayHeight, size.width, koverlayHeight);
            mapView.padding = UIEdgeInsetsMake(0, 0, koverlayHeight, 0);
        } else {
            overlay.frame = CGRectMake(0, mapView.bounds.size.height, size.width, 0);
            mapView.padding = UIEdgeInsetsZero;
        }
    }];
}

- (void)didChangeswitcher {
    // Switch to the type clicked on.
    NSString *title = [switcher titleForSegmentAtIndex:switcher.selectedSegmentIndex];
    if ([kNormalType isEqualToString:title]) {
        mapView.mapType = kGMSTypeNormal;
    } else if ([kSatelliteType isEqualToString:title]) {
       mapView.mapType = kGMSTypeSatellite;
    } else if ([kHybridType isEqualToString:title]) {
        mapView.mapType = kGMSTypeHybrid;
    } else if ([kTerrainType isEqualToString:title]) {
        mapView.mapType = kGMSTypeTerrain;
    }
}

- (void)finishButtonTapped {
    SLAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    FinishViewController *finishViewController = [appDelegate.mainMenuStoryBoard instantiateViewControllerWithIdentifier:@"FinishViewController"];
    [self.navigationController pushViewController:finishViewController animated:YES];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        NSLog(@"Please authorize location services");
        return;
    }
    
    NSLog(@"CLLocationManager error: %@", error.localizedFailureReason);
    return;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    
    if (locationMarker_ == nil) {
        locationMarker_ = [[GMSMarker alloc] init];
        locationMarker_.position = location.coordinate;
        
        // Create a 'normal' polyline.
        route = [[GMSPolyline alloc] init];
        myPath = [GMSMutablePath path];
        
        // Animated walker images derived from an www.angryanimator.com tutorial.
        // See: http://www.angryanimator.com/word/2010/11/26/tutorial-2-walk-cycle/
        
        NSArray *frames = @[[UIImage imageNamed:@"step1"],
                            [UIImage imageNamed:@"step2"],
                            [UIImage imageNamed:@"step3"],
                            [UIImage imageNamed:@"step4"],
                            [UIImage imageNamed:@"step5"],
                            [UIImage imageNamed:@"step6"],
                            [UIImage imageNamed:@"step7"],
                            [UIImage imageNamed:@"step8"]];
        
        locationMarker_.icon = [UIImage animatedImageWithImages:frames duration:0.8];
        locationMarker_.groundAnchor = CGPointMake(0.5f, 0.97f); // Taking into account walker's shadow
        locationMarker_.map = mapView;
        
        // Check if the player has reached the destination.
        if (locationMarker_.position.latitude < latitude + kAccuracy && locationMarker_.position.latitude > latitude - kAccuracy && locationMarker_.position.longitude < longtitude + kAccuracy && locationMarker_.position.longitude > longtitude - kAccuracy) {
            [self stopTimer];
        }
    } else {
        [CATransaction begin];
        [CATransaction setAnimationDuration:2.0];
        locationMarker_.position = location.coordinate;
        [CATransaction commit];
        [myPath addCoordinate:location.coordinate];
        route.path = myPath;
        route.strokeColor = [UIColor blueColor];
        route.geodesic = YES;
        route.strokeWidth = 7.f;
        route.zIndex = 15;
        route.map = mapView;
    }
   
    if (isTrackingCamera) {
        GMSCameraUpdate *move = [GMSCameraUpdate setTarget:location.coordinate zoom:17];
        [mapView animateWithCameraUpdate:move];
    }
}

#pragma mark - updateTimeDuration

- (void) updateTimeDuration {
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"userName"];
    NSString *competition = [[NSUserDefaults standardUserDefaults] stringForKey:@"Competition_Name"];
    NSString *teamName = [[NSUserDefaults standardUserDefaults] stringForKey:@"myTeamName"];
    NSString *timeDuration = clockLabel.text;
    //NSLog(@"timeduration: %@", timeDuration);
    
    NSURL *url = [NSURL URLWithString:postTimeDuration];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [urlRequest setHTTPMethod:@"POST"];
    
    NSString *postString = [NSString stringWithFormat:@"username=%@&competition=%@&teamname=%@&timeduration=%@", username, competition, teamName, timeDuration];
    
    [urlRequest setValue:[NSString stringWithFormat:@"%d", [postString length]] forHTTPHeaderField:@"Content-length"];
    
    [urlRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    //response = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"response: %@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    int code = [httpResponse statusCode];
}

@end
