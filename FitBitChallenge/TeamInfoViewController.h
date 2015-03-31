//
//  TeamInfoViewController.h
//  FitBitChallenge
//
//  Created by 李中琦 on 13-11-23.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLAppDelegate.h"
#import "TeamRankCell.h"

@interface TeamInfoViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *json;

@property (strong, nonatomic) NSMutableArray *filteredNames;
@property IBOutlet UISearchBar *nameSearchBar;

- (void)retrieveTeamData;

@end
