//
//  TeamRankCell.m
//  FitBitChallenge
//
//  Created by 李中琦 on 13-11-28.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import "TeamRankCell.h"

@implementation TeamRankCell

@synthesize teamTeamNameLabel;
@synthesize teamStepLabel;
@synthesize teamRankLabel;
@synthesize teamProgress;

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
