//
//  MainCell.h
//  FitBitChallenge
//
//  Created by 李中琦 on 13-12-1.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface MainCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet FBProfilePictureView *userPicView;

@end
