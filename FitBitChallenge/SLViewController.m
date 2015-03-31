//
//  LViewController.m
//  FitBitChallenge
//
//  Created by 李中琦 on 13-11-15.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import "SLViewController.h"

#import "SLAppDelegate.h"



@interface SLViewController ()

@end

@implementation SLViewController

@synthesize FBLoginView = _FBLoginView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame), 10, 10)];
    [spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:spinner];
    
    self.FBLoginView.delegate = self;
    
    if(![FBSession activeSession].isOpen){
        // create a fresh session object
        FBSession.activeSession = [[FBSession alloc] init];
        
        if([FBSession activeSession].state == FBSessionStateCreatedTokenLoaded){
            // even though we had a cached token, we need to login to make the session usable
            [[FBSession activeSession] openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error){
                // we recurse here, in order to update buttons and label
                [self updateView];
            }];
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stopIndicator)
                                                 name:@"zhongqil.FitBitChallenge.activityIndicatorOff"
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// main helper method to update the UI to reflect the current state of session
-(void)updateView{
    // get the app delegate, so that we can reference the session property
    SLAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if([FBSession activeSession].isOpen){
        // valid account UI is shown whenever the session is open
        //[self.buttonLoginLogout setTitle:@"Log out" forState:UIControlStateNormal];
        //[self.textNoteOrLink setText:[NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@",[FBSession activeSession].accessTokenData.accessToken]];
        
        [spinner startAnimating];
        NSLog(@"start animating");
        
        UIViewController *mainMenuView = [appDelegate.mainMenuStoryBoard instantiateViewControllerWithIdentifier:@"TabBarController"];

        mainMenuView.modalPresentationStyle = UIModalPresentationFullScreen;
        mainMenuView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:mainMenuView animated:YES completion:nil];
    } else {
        
    }
}

- (void)stopIndicator {
    [spinner stopAnimating];
}

#pragma mark Edited Code

- (void)viewDidUnload
{
    
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"zhongqil.FitBitChallenge.activityIndicatorOff"
                                                  object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    // Return YES for supported orientations
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {

    [self updateView];
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id)user {
    
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    [self updateView];
}

@end
