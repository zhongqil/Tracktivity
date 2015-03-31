//
//  IndividualCell.h
//  FitBitChallenge
//
//  Created by 李中琦 on 13-11-28.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndividualCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *indiNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *indiRankLabel;
@property (weak, nonatomic) IBOutlet UILabel *indiStepLabel;
@property (weak, nonatomic) IBOutlet UILabel *indiTeamLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *indiProgress;

@property (weak, nonatomic) NSString *indiPushedName;

@end
