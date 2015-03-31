//
//  SLAppDelegate.m
//  FitBitChallenge
//
//  Created by 李中琦 on 13-11-15.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import "SLAppDelegate.h"

#import "SLViewController.h"
#import "FBChallengeViewController.h"

#import <GoogleMaps/GoogleMaps.h>

@implementation SLAppDelegate {
    id services_;
}

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize session = _session;
@synthesize navigationController = _navigationController;
@synthesize mainMenuStoryBoard = _mainMenuStoryBoard;
@synthesize loginView = _loginView;

#pragma mark Edited Code


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation{
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                    fallbackHandler:^(FBAppCall *call) {
                        // Facebook SDK * App Linking *
                        if(call.accessTokenData) {
                            if([FBSession activeSession].isOpen) {
                                NSLog(@"INFO: Ignoring app link because current session is open.");
                            } else {
                                [self handleAppLink:call.accessTokenData];
                            }
                        }
                    }];
}

- (void)handleAppLink:(FBAccessTokenData *)appLinkToken {
    // Initialize a new blank session instance...
    FBSession *appLinkSession = [[FBSession alloc] initWithAppID:nil permissions:nil defaultAudience:FBSessionDefaultAudienceNone urlSchemeSuffix:nil tokenCacheStrategy:[FBSessionTokenCachingStrategy nullCacheInstance] ];
    
    [FBSession setActiveSession:appLinkSession];
    // ... and open it from the App Link's Token.
    [appLinkSession openFromAccessTokenData:appLinkToken
                          completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        // Forward any errors to the FBLoginView delegate.
        if (error) {
            [self.viewController loginView:nil handleError:error];
        }
    }];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [FBProfilePictureView class];
    
    [GMSServices provideAPIKey:@"AIzaSyDh8UrETF0Nx98jncetamqttfWktp_lmrE"];
    services_ = [GMSServices sharedServices];
    
    NSLog(@"Open Source licenses:\n%@", [GMSServices openSourceLicenseInfo]);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        _mainMenuStoryBoard = [UIStoryboard storyboardWithName:@"MainMenuViewController_iPhone" bundle:nil];
    } else {
        _mainMenuStoryBoard = [UIStoryboard storyboardWithName:@"MainMenuViewController_iPad" bundle:nil];
    }
    _loginView = [_mainMenuStoryBoard instantiateViewControllerWithIdentifier:@"SLViewController"];
    _loginView.modalPresentationStyle = UIModalTransitionStyleFlipHorizontal;
    
    self.window.rootViewController = self.loginView;

    [self.window makeKeyAndVisible];
    return YES;
}


							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

#pragma mark Edited Code

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBAppEvents activateApp];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [FBSession.activeSession close];
}

@end
