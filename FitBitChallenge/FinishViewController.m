//
//  FinishViewController.m
//  FitBitChallenge
//
//  Created by 李中琦 on 13-12-4.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import "FinishViewController.h"

#import <GoogleMaps/GoogleMaps.h>


float latitude, longtitude;
NSString *dest_title, *dest_snippet;

@implementation FinishViewController {
    GMSMapView *mapView_;
    NSTimer *timer;
    GMSMarker *destination_;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"Destination Preview";
    self.navigationItem.backBarButtonItem.title = @"Track";
    
    latitude = [[[NSUserDefaults standardUserDefaults] stringForKey:@"Latitude"] floatValue];
    longtitude = [[[NSUserDefaults standardUserDefaults] stringForKey:@"Longtitude"] floatValue];
    dest_title = [[NSUserDefaults standardUserDefaults] stringForKey:@"Dest_Title"];
    dest_snippet = [[NSUserDefaults standardUserDefaults] stringForKey:@"Dest_Snippet"];
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                            longitude:longtitude
                                                                 zoom:15
                                                              bearing:0
                                                         viewingAngle:0];


    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.settings.zoomGestures = NO;
    mapView_.settings.scrollGestures = NO;
    mapView_.settings.rotateGestures = NO;
    mapView_.settings.tiltGestures = NO;
    
    self.view = mapView_;
    
    destination_ = [[GMSMarker alloc] init];
    destination_.position = CLLocationCoordinate2DMake(latitude, longtitude);
    destination_.title = dest_title;
    destination_.snippet = dest_snippet;
    destination_.appearAnimation = kGMSMarkerAnimationPop;
    destination_.map = mapView_;
}

- (void)moveCamera {
    GMSCameraPosition *camera = mapView_.camera;
    float zoom = fmaxf(camera.zoom - 0.1f, 17.5f);
    
    GMSCameraPosition *newCamera = [[GMSCameraPosition alloc] initWithTarget:camera.target
                                                                        zoom:zoom
                                                                     bearing:camera.bearing + 10
                                                                viewingAngle:camera.viewingAngle + 10];
    [mapView_ animateToCameraPosition:newCamera];
}

- (void)viewDidAppear:(BOOL)animated {
    timer = [NSTimer scheduledTimerWithTimeInterval:1.f/30.f
                                             target:self
                                           selector:@selector(moveCamera)
                                           userInfo:nil
                                            repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [timer invalidate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [timer invalidate];
}

- (void)dealloc {
    
}

@end
