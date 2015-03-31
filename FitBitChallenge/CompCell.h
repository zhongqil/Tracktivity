//
//  CompCell.h
//  FitBitChallenge
//
//  Created by 李中琦 on 13-12-9.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompCell : UITableViewCell

@property (strong, nonatomic) UILabel *status;
@property (strong, nonatomic) UILabel *tName;
@property (strong, nonatomic) UILabel *tStartTime;
@property (strong, nonatomic) UILabel *tEndTime;
@property (strong, nonatomic) UILabel *tDestination;
@property (strong, nonatomic) UIView *infoView;

@end
