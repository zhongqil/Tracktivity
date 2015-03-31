//
//  RankingCell.m
//  FitBitChallenge
//
//  Created by 李中琦 on 13-11-27.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import "RankingCell.h"

@implementation RankingCell

@synthesize steps = _steps;
@synthesize userNameLabel = _userNameLabel;
@synthesize stepLabel = _stepLabel;
@synthesize rankLabel = _rankLabel;
@synthesize nameValue = _nameValue;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
