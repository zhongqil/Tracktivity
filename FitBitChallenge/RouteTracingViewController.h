//
//  RouteTracingViewController.h
//  FitBitChallenge
//
//  Created by 李中琦 on 13-11-20.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "SLAppDelegate.h"

#import <GoogleMaps/GoogleMaps.h>

@interface RouteTracingViewController : UIViewController<CLLocationManagerDelegate, UIGestureRecognizerDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;

@end
