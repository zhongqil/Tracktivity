//
//  SLAppDelegate.h
//  FitBitChallenge
//
//  Created by 李中琦 on 13-11-15.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FacebookSDK/FacebookSDK.h>
#import <FacebookSDK/FBSessionTokenCachingStrategy.h>


@class SLViewController;

@interface SLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SLViewController *viewController;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) UIStoryboard *mainMenuStoryBoard;
@property (strong, nonatomic) UIViewController *loginView;

@property (strong, nonatomic) FBSession *session;

@end
