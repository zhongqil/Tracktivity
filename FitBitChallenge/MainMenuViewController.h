//
//  MainMenViewController.h
//  FitBitChallenge
//
//  Created by 李中琦 on 13-11-16.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "SLAppDelegate.h"

#import "FlipsideViewController.h"
#import "MySideViewController.h"

@interface MainMenuViewController : UITableViewController <MySideViewControllerDelegate , UIPopoverControllerDelegate, FBUserSettingsDelegate, UIActionSheetDelegate,
    FBFriendPickerDelegate, UIAlertViewDelegate, FBLoginViewDelegate, NSURLConnectionDataDelegate>
{
    IBOutlet UIView *theView;
}

@property (strong, nonatomic) NSMutableArray *json;
@property (strong, nonatomic) NSMutableArray *teamJson;
@property (strong, nonatomic) NSString *role;
@property (readwrite) BOOL isNewUser;
@property (strong, nonatomic) UIPopoverController *myPopoverController;

@property (strong, nonatomic) UIActionSheet *teamActionSheet;
@property (retain, nonatomic) UITableView *teamTableView;
@property (strong, nonatomic) UIAlertView *createTeamAlert;
@property (strong, nonatomic) UILabel *warningLabel;
@property (strong, nonatomic) UIAlertView *quitWarning;
@property (strong, nonatomic) UIAlertView *dismissWarning;

@property (strong, nonatomic) IBOutlet UILabel *stepLabel;
@property (strong, nonatomic) IBOutlet UILabel *seMinLabel;
@property (strong, nonatomic) IBOutlet UILabel *acMinLabel;


@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (readwrite, strong) IBOutlet UIProgressView *stepBar;
@property (readwrite, strong) IBOutlet UIProgressView *seMinBar;
@property (readwrite, strong) IBOutlet UIProgressView *acMinBar;

- (IBAction)editButtonTapped:(id)sender;
- (IBAction)logoutButtonTapped:(id)sender;
- (IBAction)togglePopover:(id)sender;

- (void)cancelButtonTapped;
- (void)chooseButtonTapped;
- (void)createTeamButtonTapped;
- (void)quitTeamButtonTapped;
- (void)dismissCurrentTeamButtonTapped;

@end
