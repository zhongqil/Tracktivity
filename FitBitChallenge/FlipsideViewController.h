//
//  FlipsideViewController.h
//  FitBitChallenge
//
//  Created by 李中琦 on 13-11-16.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBChallengeViewController.h"

@class FBChallengeViewController;

@interface FlipsideViewController : UITableViewController

@property (strong, nonatomic) FBChallengeViewController *fbChallengeViewController;

@property (strong, nonatomic) NSMutableArray *competition_json;

@property (strong, nonatomic) UILabel *warningLabel;

@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longtitude;
@property (strong, nonatomic) NSString *dest_Title;
@property (strong, nonatomic) NSString *dest_Snippet;
@property (strong, nonatomic) NSString *start_Time;
@property (strong, nonatomic) NSString *trackTivityName;


@end
