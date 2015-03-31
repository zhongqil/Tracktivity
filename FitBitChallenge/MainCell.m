//
//  MainCell.m
//  FitBitChallenge
//
//  Created by 李中琦 on 13-12-1.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import "MainCell.h"

@implementation MainCell

@synthesize userNameLabel;
@synthesize userPicView;

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
