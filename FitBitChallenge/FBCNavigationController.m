//
//  FBCNavigationController.m
//  FitBitChallenge
//
//  Created by 李中琦 on 13-11-20.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import "FBCNavigationController.h"

#import "FBChallengeViewController.h"

@interface FBCNavigationController ()
@end

#define  UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation FBCNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    FBChallengeViewController * fbChallengeViewController;
    fbChallengeViewController = [FBChallengeViewController alloc];
    (void)[fbChallengeViewController initWithButtonCount:kKYCCircleMenuButtonsCount
                                               menuSize:kKYCircleMenuSize
                                             buttonSize:kKYCircleMenuButtonSize
                                  buttonImageNameFormat:kKYICircleMenuButtonImageNameFormat
                                       centerButtonSize:kKYCircleMenuCenterButtonSize
                                  centerButtonImageName:kKYICircleMenuCenterButton
                        centerButtonBackgroundImageName:kKYICircleMenuCenterButtonBackground];
    
       (void)[self initWithRootViewController:fbChallengeViewController];
    [self.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
}

@end
