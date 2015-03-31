//
//  SplitViewController.m
//  FitBitChallenge
//
//  Created by 李中琦 on 13-12-10.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import "SplitViewController.h"
#import "FBChallengeViewController.h"

@interface SplitViewController ()

@end

@implementation SplitViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UINavigationController *navController = [self.viewControllers lastObject];
    self.delegate = (id)navController.topViewController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
