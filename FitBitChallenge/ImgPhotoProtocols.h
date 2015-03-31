//
//  ImgPhotoProtocols.h
//  FitBitChallenge
//
//  Created by 李中琦 on 13-11-24.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <FacebookSDK/FacebookSDK.h>

@protocol ImgPhotoProtocols <FBOpenGraphObject>

@property (retain, nonatomic) NSString *id;
@property (retain, nonatomic) id<FBGraphObject> data;
@property (retain, nonatomic) id description;
@property (retain, nonatomic) id image;
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *type;
@property (retain, nonatomic) id url;

@end
