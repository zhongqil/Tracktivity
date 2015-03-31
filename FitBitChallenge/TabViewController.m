//
//  TabViewController.m
//  FitBitChallenge
//
//  Created by 李中琦 on 13-12-17.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import "TabViewController.h"

@interface TabViewController ()

@end

@implementation TabViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openTracktivity) name:@"zhongqil.FitBitChallenge.openTracktivity" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeTracktivity) name:@"zhongqil.FitBitChallenge.closeTracktivity" object:nil];
}

- (void)openTracktivity {
    [[[self.tabBar items] objectAtIndex:1] setEnabled:YES];
}

- (void)closeTracktivity {
    [[[self.tabBar items] objectAtIndex:1] setEnabled:NO];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"zhongqil.FitBitChallenge.openTracktivity" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"zhongqil.FitBitChallenge.closeTracktivity" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
