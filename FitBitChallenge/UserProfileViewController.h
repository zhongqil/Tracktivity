//
//  UserProfileViewController.h
//  FitBitChallenge
//
//  Created by 李中琦 on 13-11-18.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>

#import "SLAppDelegate.h"
#import "MainMenuViewController.h"
#import "ImgPhotoProtocols.h"


@interface UserProfileViewController : UITableViewController <FBLoginViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>


@property (strong, nonatomic) NSMutableArray *json;
@property (strong, nonatomic) NSString *pushedTeamName;

@property (strong, nonatomic) NSMutableArray *filteredNames;
@property IBOutlet UISearchBar *nameSearchBar;


- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error;
- (void)retrieveData;

@end
