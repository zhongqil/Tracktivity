//
//  FriendViewController.h
//  FitBitChallenge
//
//  Created by 李中琦 on 13-11-21.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SLAppDelegate.h"

@interface FriendViewController : FBFriendPickerViewController

@property (strong, nonatomic) IBOutlet UITextView *activityTextView;

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *inviteButton;

- (IBAction)clickInviteFriends:(id)sender;

@end
