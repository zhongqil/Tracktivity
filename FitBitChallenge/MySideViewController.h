//
//  MySideViewController.h
//  FitBitChallenge
//
//  Created by 李中琦 on 13-12-17.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MySideViewController;

@protocol MySideViewControllerDelegate

- (void)mySideViewControllerDidFinish:(MySideViewController *)controller;
- (void)passNewUser: (BOOL)isTheNewUser;
- (void)passSelectedTeam: (NSString *)theSelectedTeam;
- (void)passRole: (NSString *)theRole;

@end

@interface MySideViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) id <MySideViewControllerDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *teamJson;
@property (strong, nonatomic) NSString *role;

@property (retain, nonatomic) UITableView *teamTableView;
@property (strong, nonatomic) UIAlertView *createTeamAlert;
@property (strong, nonatomic) UILabel *warningLabel;
@property (strong, nonatomic) UIAlertView *quitWarning;
@property (strong, nonatomic) UIAlertView *dismissWarning;

- (void)cancelButtonTapped;

@end
