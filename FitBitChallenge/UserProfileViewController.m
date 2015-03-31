//
//  UserProfileViewController.m
//  FitBitChallenge
//
//  Created by 李中琦 on 13-11-18.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import "UserProfileViewController.h"
#import "IndividualRankViewController.h"

#import "RankingCell.h"


@interface UserProfileViewController ()

@property (strong, nonatomic) id<ImgPhotoProtocols> anObject;
@property (retain, nonatomic) id<FBGraphObject> graphObject;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *shareButton;


- (IBAction)shareButtonTapped:(id)sender;

@end

#define getDataURL @"http://lawson.cis.utas.edu.au/~zhongqil/fitBitTest/Contribution.php"
#define urlToShare @"http://www.youtube.com"
#define imgToShare @"KYICircleMenuCenterButton.png"  // when the user don't have FB APP
#define shareImgWithURL @"http://aussietheatre.com.au/wp-content/uploads/2012/03/star.jpeg"
#define shareName @"Tracktivity"
#define shareCaption @"Tracktivity"
#define shareDescription @"The Tracktivity application"

NSString *userName;

@implementation UserProfileViewController {
    NSArray *searchResults;
}

@synthesize shareButton = _shareButton;
@synthesize graphObject = _graphObject;
@synthesize anObject = _anObject;
@synthesize json = _json;
@synthesize pushedTeamName = _pushedTeamName;

@synthesize nameSearchBar;
@synthesize filteredNames;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    userName = [[NSUserDefaults standardUserDefaults] stringForKey:@"userName"];
    
    [self retrieveData];
    self.filteredNames = [NSMutableArray arrayWithCapacity:[self.json count]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareButtonTapped:(id)sender {
    [self postStatus];
}

#pragma mark -

// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performPublishAction:(void (^)(void)) action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don;t already have the permission, then we request it now
        [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceOnlyMe completionHandler:^(FBSession *session, NSError *error) {
                                                  if (!error) {
                                                      action();
                                                  } else if (error.fberrorCategory !=
                                                             FBErrorCategoryUserCancelled){
                                                      UIAlertView *alertView = [[UIAlertView alloc]
                                                                                initWithTitle:@"Permission denied"
                                                                                message:@"Unable to get permission to post"
                                                                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                      [alertView show];
                                                  }
                                              }];
    } else {
        action();
    }
}

// Post status Update button handler
- (void)postStatus {
    // Post a status update to the user's feed via the Graph API, and display an alert view
    // with the results or an error.
    
    NSURL *url = [NSURL URLWithString:urlToShare];
    NSString *step = [[NSUserDefaults standardUserDefaults] stringForKey:@"myStep"];
    NSString *rank = [[NSUserDefaults standardUserDefaults] stringForKey:@"myRank"];
    
    NSString *message = [NSString stringWithFormat:@"I just made %d steps at %@ in Tracktivity Ranked %d", [step intValue],[NSDate date], [rank intValue]];
    UIImage *img = [UIImage imageNamed:imgToShare];
    
    // This code demonstrates 3 different ways of sharing using the Facebook SDK.
    // The first method tries to share via the Facebook app. This allows sharing without
    // the user having to authorize your app, and is available as long as the user has the
    // correct Facebook app installed. This publish will result in a fast-app-switch to the
    // Facebook app.
    // The second method tries to share via Facebook's iOS6 integration, which also
    // allows sharing without the user having to authorize your app, and is available as
    // long as the user has linked their Facebook account with iOS6. This publish will
    // result in a popup iOS6 dialog.
    // The third method tries to share via a Graph API request. This does require the user
    // to authorize your app. They must also grant your app publish permissions. This
    // allows the app to publish without any user interaction.
    
    // If it is available, we will first try to post using the share dialog in the facebook app
    
    FBAppCall *appCall = [FBDialogs presentShareDialogWithLink:url
                                                          name:shareName
                                                       caption:shareCaption
                                                   description:shareDescription
                                                       picture:[NSURL URLWithString:shareImgWithURL]
                                                   clientState:nil
                                                       handler:^(FBAppCall *call, NSDictionary *results,
                                                                 NSError *error) {
                                                           if (error) {
                                                               NSLog(@"Error: %@", error.description);
                                                           } else {
                                                               NSLog(@"success!");
                                                           }
                                                       }];

    
    if (!appCall) {
        // Next try to post using Facebook's iOS7 integration
        BOOL displayedNativeDialog = [FBDialogs presentOSIntegratedShareDialogModallyFrom:self
                                                                              initialText:message
                                                                                    image:img
                                                                                      url:url
                                                                                  handler:nil];
        if (!displayedNativeDialog) {
            // Lastly, fall back on a request for permissions and a direct post using the Graph API
            [self performPublishAction:^{
                
                FBRequestConnection *connection = [[FBRequestConnection alloc] init];
                
                connection.errorBehavior = FBRequestConnectionErrorBehaviorReconnectSession
                                         | FBRequestConnectionErrorBehaviorAlertUser
                | FBRequestConnectionErrorBehaviorRetry;
                
                [connection addRequest:[FBRequest requestForPostStatusUpdate:message]
                     completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                         
                         [self showAlert:message result:result error:error];
                     }];

                [connection start];
                
            }];
        }
    }
}

- (void)showAlert:(NSString *)message result:(id)result error:(NSError *)error {
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertTitle = @"Error";
        // Since we use FBRequestConnectionErrorBehaviorAlertUser,
        // we don't need to surface our own alert view if there is an
        // and fberrorUserMessage unless the session is closed.
        if (error.fberrorUserMessage && FBSession.activeSession.isOpen) {
            alertTitle = nil;
            
        } else {
            // Otherwise, user a general "connection problem" message.
            alertMsg = @"Operation failed due to a connection problem, retry later.";
        }
    } else {
        NSDictionary *resultDict = (NSDictionary *)result;
        alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'.", message];
        NSString *postId = [resultDict valueForKey:@"id"];
        if(!postId) {
            postId = [resultDict valueForKey:@"postId"];
        }
        if(postId) {
            alertMsg = [NSString stringWithFormat:@"%@\nPost ID: %@", alertMsg, postId];
        }
        alertTitle = @"Success";
    }
    
    if (alertTitle) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                            message:alertMsg
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}


 #pragma mark - Table view data source
 
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
 {
 // Return the number of sections.
 return 1;
 }
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
 // Return the number of rows in the section.
     
     if (tableView == self.searchDisplayController.searchResultsTableView) {
         return [filteredNames count];
     } else {
         return self.json.count;
     }
 }

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 static NSString *CellIdentifier = @"Contribution_Cell";
 RankingCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
 
 // Configure the cell...
     if(cell == nil) {
         cell = [[RankingCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
         
     }
     
     
     NSMutableArray *newJson;
     
     if (tableView == self.searchDisplayController.searchResultsTableView) {
         newJson = filteredNames;
     } else {
         newJson = self.json;
     }
     
     if(self.pushedTeamName != nil) {
         self.title = [NSString stringWithFormat:@"%@ Team", self.pushedTeamName];
     } else {
     self.title = [NSString stringWithFormat:@"%@ Team",[[self.json objectAtIndex:indexPath.row] objectForKey:@"Team_Name"]];
     }
     
     cell.stepLabel.text = [NSString stringWithFormat:@"Total Steps: %@", [[newJson objectAtIndex:indexPath.row] objectForKey:@"Total_Steps"]];
     cell.userNameLabel.text = [[newJson objectAtIndex:indexPath.row] objectForKey:@"Username"];
     cell.rankLabel.text = [NSString stringWithFormat:@"Rank: %@", [[newJson objectAtIndex:indexPath.row] objectForKey:@"Rank"]];
     cell.steps.progress = [[[newJson objectAtIndex:indexPath.row] objectForKey:@"Total_Steps"] floatValue]/250000;

     
     if ([cell.userNameLabel.text isEqualToString:userName]) {
         cell.nameValue = userName;
         cell.userNameLabel.text = [NSString stringWithFormat:@"%@ (Me)", userName];
         [[NSUserDefaults standardUserDefaults] setObject:[[newJson objectAtIndex:indexPath.row] objectForKey:@"Rank"] forKey:@"myRank"];
         [[NSUserDefaults standardUserDefaults] setObject:[[newJson objectAtIndex:indexPath.row] objectForKey:@"Total_Steps"] forKey:@"myStep"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         cell.backgroundColor = [UIColor colorWithRed:0 green:0.3333 blue:0.6667 alpha:0.8];
         cell.steps.progressTintColor = [UIColor whiteColor];
         cell.steps.trackTintColor = [UIColor colorWithRed:0 green:0.3333 blue:0.6667 alpha:0.8];
         cell.userNameLabel.textColor = [UIColor whiteColor];
         cell.rankLabel.textColor = [UIColor whiteColor];
         cell.stepLabel.textColor = [UIColor whiteColor];
         [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
     } else {
         cell.nameValue = cell.userNameLabel.text;
     }
     
 return cell;
 }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RankingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    SLAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    IndividualRankViewController *indieController = [appDelegate.mainMenuStoryBoard instantiateViewControllerWithIdentifier:@"IndividualRankViewController"];
    [self.navigationController pushViewController:indieController animated:YES];
    indieController.selectedName = cell.nameValue;
}

 
- (void)retrieveData {
    NSURL *url = [NSURL URLWithString:getDataURL];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
   self.json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}


#pragma mark - Content Filtering

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    
    [self.filteredNames removeAllObjects];
    NSString *names = @"Username";
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"%K contains[c] %@", names, searchText];
    
    searchResults = [self.json filteredArrayUsingPredicate:resultPredicate];
    filteredNames = [NSMutableArray arrayWithArray:searchResults];
}

#pragma mark - UISearchDisplayController Delegate Methods


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView {
    tableView.rowHeight = 122;
}

@end
