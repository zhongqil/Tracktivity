//
//  RankingCell.h
//  FitBitChallenge
//
//  Created by 李中琦 on 13-11-27.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIProgressView *steps;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;

@property (weak, nonatomic) NSString *nameValue;

@end
