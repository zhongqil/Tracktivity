//
//  TeamRankCell.h
//  FitBitChallenge
//
//  Created by 李中琦 on 13-11-28.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamRankCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *teamTeamNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamStepLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamRankLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *teamProgress;

@property (weak, nonatomic) NSString *teamPushedName;

@end
