//
//  WebViewController.m
//  FitBitChallenge
//
//  Created by 李中琦 on 13-12-2.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import "WebViewController.h"

#define urlAddress @"http://www.apple.com/"

@implementation WebViewController {
    UIWebView *webView_;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"Tracktivity Website";
    
    webView_ = [[UIWebView alloc] initWithFrame:CGRectZero];

    self.view = webView_;
    
    NSURL *url = [[NSURL alloc] initWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [webView_ setScalesPageToFit:YES];
    
    
    [webView_ loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
