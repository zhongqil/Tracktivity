//
//  FriendViewController.m
//  FitBitChallenge
//
//  Created by 李中琦 on 13-11-21.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import "FriendViewController.h"

#import "OGProtocols.h"

@interface FriendViewController () <FBFriendPickerDelegate, UIAlertViewDelegate>

@property (readwrite, nonatomic, copy) NSString *fbidSelection;
@property (readwrite, nonatomic, retain) FBFrictionlessRecipientCache *friendCache;

- (void)updateActivityForID: (NSString *)fbid;

@end

@implementation FriendViewController

@synthesize  activityTextView = _activityTextView;
@synthesize friendCache = _friendCache;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"FBChallenge w/Friends", @"FBChallenge w/Friends");
        self.fieldsForRequest = [NSSet setWithObject:@"installed"];
        self.allowsMultipleSelection = NO;
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.doneButton = nil;
    self.cancelButton = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshView {
    [self loadData];
    
    // we use frictionless request, so let's get a cache and request the
    // current list of frictionless friends before enabling the invite button
    if (!self.friendCache) {
        self.friendCache = [[FBFrictionlessRecipientCache alloc] init];
        [self.friendCache prefetchAndCacheForSession:nil
                                   completionHandler:^(FBRequestConnection *connection,
                                                       id result, NSError *error) {
                                       self.inviteButton.enabled = YES;
                                   }];
    } else {
        // if we already have a primed cache, let's just run with it
        self.inviteButton.enabled = YES;
    }
}

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (FBSession.activeSession.isOpen) {
        [self refreshView];
    } else {
        self.inviteButton.enabled = NO;
        self.friendCache = nil;
        
        // display the message that we have
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In with Facebook"
                                                        message:@"When you Log In with Facebook, you can view "
                                                                @"friends' activity within FBChallenge, and "
                                                                @"invite friends to play. \n\n"
                                                                @"what would you like to do?"
                                                       delegate:self
                                              cancelButtonTitle:@"Do Nothing"
                                              otherButtonTitles:@"Login", nil];
        [alert show];
         
    }
}

- (void)viewDidUnload {
    self.activityTextView = nil;
    
    [self setInviteButton:nil];
    [super viewDidUnload];
}

#pragma mark - FBFriendPickerDelegate implementation

// 1. Filtering support in the friend picker
// 2. The "installed" field presented (and true) if the friend is also a user of the application

- (void)friendPickerViewControllerSelectionDidChange:(FBFriendPickerViewController *)friendPicker {
    self.activityTextView.text = @"";
    if (friendPicker.selection.count) {
        [self updateActivityForID:[[friendPicker.selection objectAtIndex:0] id]];
    } else {
        self.fbidSelection = nil;
    }
}

- (BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                 shouldIncludeUser:(id<FBGraphUser>)user {
    return YES;
}

#pragma mark - private methods

// It updates the textView with the activity of a given user.
// It accomplishes this by fetching the "step" actions for the selected user.
- (void)updateActivityForID:(NSString *)fbid {
    
    // keep track of the selection
    self.fbidSelection = fbid;
    
    // create a request for the "throw" activity
    FBRequest *challengeActivity = [FBRequest requestForGraphPath:[NSString stringWithFormat:@"%@/fb_challenge:throw", fbid]];
    [challengeActivity.parameters setObject:@"U" forKey:@"date_format"];
    
    // this block is the one that does the real handling work for the requests
    void (^handleBlock)(id) = ^(id<FBCGraphActionList> result) {
        if (result) {
            for (id<FBCGraphPublishedThrowAction> entry in result.data) {
                // we tranlate the date into something useful for sorting and displaying
                entry.publish_date = [NSDate dateWithTimeIntervalSince1970:entry.publish_time.intValue];
            }
        }
        
        // sort the array by date
        NSMutableArray *activity = [NSMutableArray arrayWithArray:result.data];
        [activity sortUsingComparator:^NSComparisonResult(id<FBCGraphPublishedThrowAction> obj1,
                                                          id<FBCGraphPublishedThrowAction> obj2) {
            if (obj1.publish_date && obj2.publish_date) {
                return [obj2.publish_date compare:obj1.publish_date];
            }
            return NSOrderedSame;
        }];
        
        NSMutableString *output = [NSMutableString string];
        for (id<FBCGraphPublishedThrowAction> entry in activity) {
            NSDateComponents *c = [[NSCalendar currentCalendar]
                                   components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit
                                   fromDate:entry.publish_date];
            [output appendFormat:@"%02d/%02d/%02d - %@ %@ %@\n",
             c.month,
             c.year,
             c.year,
             entry.data.gesture.title,
             @"vs",
             entry.data.opposing_gesture.title];
        }
        self.activityTextView.text = output;
    };
    
    //a batch request using FBRequestConnection
    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
    [connection addRequest:challengeActivity
         completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
             handleBlock(result);
         }];
    // start the actual request
    [connection start];
}

- (IBAction)clickInviteFriends:(id)sender {
    // if there is a selected user, seed the dialog with that user
    NSDictionary *parameters = self.fbidSelection ? @{@"to":self.fbidSelection} : nil;
    [FBWebDialogs presentRequestsDialogModallyWithSession:nil
                                                  message:@"Please FBChallenge with Me!"
                                                    title:@"Invite a Friend"
                                               parameters:parameters
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL,
                                                            NSError *error) {
                                                      if (result == FBWebDialogResultDialogCompleted) {
                                                          NSLog(@"Web dialog complete: %@", resultURL);
                                                      } else {
                                                          NSLog(@"Web dialog not complete, error: %@", error.description);
                                                      }
                                                  }
                                              friendCache:self.friendCache];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: // do nothing
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        case 1: { // log in
            // we will update the view *once* upon successful login
            __block FriendViewController *me = self;
            [FBSession openActiveSessionWithReadPermissions:nil
                                               allowLoginUI:YES
                                          completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                              if (me) {
                                                  if (session.isOpen) {
                                                      [me refreshView];
                                                  } else {
                                                      [me.navigationController popToRootViewControllerAnimated:YES];
                                                  }
                                                  me = nil;
                                              }
                                          }];
                }
            break;
            
    }
}
 

@end
