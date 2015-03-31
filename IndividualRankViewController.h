//
//  IndividualRankViewController.h
//  FitBitChallenge
//
//  Created by 李中琦 on 13-11-25.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLAppDelegate.h"
#import "IndividualCell.h"


@interface IndividualRankViewController : UITableViewController

@property (nonatomic, strong) NSString *selectedName;

@property (strong, nonatomic) NSMutableArray *json;

@property (strong, nonatomic) NSMutableArray *filteredNames;
@property IBOutlet UISearchBar *nameSearchBar;

- (void)retrieveIndieData;

@end
