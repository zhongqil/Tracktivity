//
//  LViewController.h
//  FitBitChallenge
//
//  Created by 李中琦 on 13-11-15.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SLAppDelegate.h"
#import "MainMenuViewController.h"

@interface SLViewController : UIViewController<FBLoginViewDelegate>
{
    UIActivityIndicatorView *spinner;
}

@property (unsafe_unretained, nonatomic) IBOutlet FBLoginView *FBLoginView;

- (void)updateView;
- (void)stopIndicator;

@end
