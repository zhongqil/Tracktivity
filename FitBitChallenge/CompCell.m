//
//  CompCell.m
//  FitBitChallenge
//
//  Created by 李中琦 on 13-12-9.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import "CompCell.h"

@implementation CompCell

@synthesize status;
@synthesize tName;
@synthesize tStartTime;
@synthesize tEndTime;
@synthesize tDestination;

@synthesize infoView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        status = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
        status.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Futura"] objectAtIndex:3] size:12];
        status.textAlignment = NSTextAlignmentNatural;
        [self.contentView addSubview:status];
        
        tName = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, CGRectGetWidth(self.contentView.frame)-110, 40)];
        tName.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Futura"] objectAtIndex:3] size:21];
        tName.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:tName];
        
        tDestination = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.contentView.frame), 40)];
        tDestination.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Futura"] objectAtIndex:0] size:18];
        tDestination.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:tDestination];
        
        tStartTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, CGRectGetWidth(self.contentView.frame), 40)];
        tStartTime.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Futura"] objectAtIndex:0] size:18];
        tStartTime.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:tStartTime];
        
        tEndTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, CGRectGetWidth(self.contentView.frame), 40)];
        tEndTime.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Futura"] objectAtIndex:0] size:18];
        tEndTime.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:tEndTime];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
