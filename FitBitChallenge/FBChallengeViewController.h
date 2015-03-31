//
//  FBChallengeViewController.h
//  FitBitChallenge
//
//  Created by 李中琦 on 13-11-15.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KYCircleMenu.h"
#import "SLAppDelegate.h"
#import "CompCell.h"

#import "RouteTracingViewController.h"
#import "FlipsideViewController.h"

@interface FBChallengeViewController : KYCircleMenu <UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource, UISplitViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *competition_json;

@property (strong, nonatomic) UIActionSheet *trackActionSheet;
@property (retain, nonatomic) UITableView *competitionView;

@property (strong, nonatomic) UILabel *warningLabel;
@property (strong, nonatomic) UILabel *clockLabel;
@property (strong, nonatomic) UILabel *iPadWarningLabel;

@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longtitude;
@property (strong, nonatomic) NSString *dest_Title;
@property (strong, nonatomic) NSString *dest_Snippet;
@property (strong, nonatomic) NSString *start_Time;
@property (strong, nonatomic) NSString *trackTivityName;


- (void)makeActionSheet;

@end
