//
//  MainMenViewController.m
//  FitBitChallenge
//
//  Created by 李中琦 on 13-11-16.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import "MainMenuViewController.h"
#import <AddressBook/AddressBook.h>

#import "SLAppDelegate.h"
#import "SLViewController.h"
#import "SCProtocols.h"

#import "MainCell.h"

@interface MainMenuViewController ()
{
    NSTimer *_timer;
    NSDateFormatter *currentDate;
    NSString *selectedTeam;
}

@end


#define getDataURL @"http://lawson.cis.utas.edu.au/~zhongqil/fitBitTest/"
#define getStepsURL @"Steps.php?date="
#define getSedentryURL @"SedentryMinutes.php?date="
#define getActiveURL @"VeryActiveMinutes.php?date="
#define getUserIdURL @"http://lawson.cis.utas.edu.au/~zhongqil/fitBitTest/UserInfo.php"
#define getTeamNameURL @"http://lawson.cis.utas.edu.au/~zhongqil/fitBitTest/TeamRank.php"

static NSString *nullData = @"<5b5d>";
static NSString *member = @"Member";
static NSString *creator = @"Creator";

@implementation MainMenuViewController

@synthesize datePicker = _datePicker;

@synthesize json = _json;
@synthesize stepBar = _stepBar;
@synthesize seMinBar = _seMinBar;
@synthesize acMinBar = _acMinBar;
@synthesize stepLabel = _stepLabel;
@synthesize seMinLabel = _seMinLabel;
@synthesize acMinLabel = _acMinLabel;
@synthesize teamActionSheet;
@synthesize teamTableView;
@synthesize teamJson;
@synthesize createTeamAlert;
@synthesize warningLabel;
@synthesize quitWarning;
@synthesize dismissWarning;
@synthesize role;
@synthesize myPopoverController;
@synthesize isNewUser;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isNewUser = YES;
    
    if(FBSession.activeSession.isOpen) {
        [self populateUserDetails];
    } else {
    }
    
    currentDate = [[NSDateFormatter alloc] init];
    [currentDate setDateFormat:@"yyyy-MM-dd"];

    [self dateSelected];
    [self checkUser];
    warningLabel.hidden = YES;
    
    self.clearsSelectionOnViewWillAppear = NO;
    
    FBCacheDescriptor *cacheDescriptor = [FBFriendPickerViewController cacheDescriptor];
    [cacheDescriptor prefetchAndCacheForSession:FBSession.activeSession];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.clearsSelectionOnViewWillAppear = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - teamActionSheet

- (IBAction)editButtonTapped:(id)sender
{
    [self getTeamName];
    [self checkUser];
    
       teamActionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Team to Start"
                                                        delegate:self
                                               cancelButtonTitle:nil
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:nil];
    
    
    UIView *actionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    actionView.backgroundColor = [UIColor orangeColor];
    actionView.contentMode = UIViewContentModeScaleToFill;
    [teamActionSheet addSubview:actionView];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 260, 320, 50)];
    [cancelButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.adjustsImageWhenHighlighted = YES;
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithRed:0/255.0f green:177/255.0f blue:148/255.0f alpha:1.0f] forState:UIControlStateNormal];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    cancelButton.titleLabel.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Futura"] objectAtIndex:3] size:21];
    
    [teamActionSheet addSubview:cancelButton];
    
    
    UIButton *chooseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 175, 320, 50)];
    [chooseButton addTarget:self action:@selector(chooseButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [chooseButton setTitle:@"Choose" forState:UIControlStateNormal];
    [chooseButton setTitleColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [chooseButton setTitleColor:[UIColor colorWithRed:0/255.0f green:177/255.0f blue:148/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
    [chooseButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    chooseButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    chooseButton.titleLabel.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Futura"] objectAtIndex:3] size:21];
    
    [teamActionSheet addSubview:chooseButton];
    
    UIButton *createTeamButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 215, 160, 50)];
    [createTeamButton addTarget:self action:@selector(createTeamButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [createTeamButton setTitle:@"Create A Team" forState:UIControlStateNormal];
    [createTeamButton setTitleColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [createTeamButton setTitleColor:[UIColor colorWithRed:0/255.0f green:177/255.0f blue:148/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
    [createTeamButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    createTeamButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    createTeamButton.titleLabel.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Futura"] objectAtIndex:3] size:15];
    
    [teamActionSheet addSubview:createTeamButton];
    
    UIButton *quitTeamButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 215, 160, 50)];
    [quitTeamButton addTarget:self action:@selector(quitTeamButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [quitTeamButton setTitle:@"Quit My Team" forState:UIControlStateNormal];
    [quitTeamButton setTitleColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [quitTeamButton setTitleColor:[UIColor colorWithRed:0/255.0f green:177/255.0f blue:148/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
    [quitTeamButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    quitTeamButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    quitTeamButton.titleLabel.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Futura"] objectAtIndex:3] size:15];
    
    [teamActionSheet addSubview:quitTeamButton];
    
    UIButton *dismissTeamButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 215, 160, 50)];
    [dismissTeamButton addTarget:self action:@selector(dismissCurrentTeamButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [dismissTeamButton setTitle:@"Dismiss My Team" forState:UIControlStateNormal];
    [dismissTeamButton setTitleColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [dismissTeamButton setTitleColor:[UIColor colorWithRed:0/255.0f green:177/255.0f blue:148/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
    [dismissTeamButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    dismissTeamButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    dismissTeamButton.titleLabel.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Futura"] objectAtIndex:3] size:15];
    
    [teamActionSheet addSubview:dismissTeamButton];
    
    if ([role isEqualToString:creator]) {
        quitTeamButton.hidden = YES;
        dismissTeamButton.hidden = NO;
        [dismissTeamButton setEnabled:YES];
    } else {
        quitTeamButton.hidden = NO;
        dismissTeamButton.hidden = YES;
        [dismissTeamButton setEnabled:NO];
    }
    
    
    if (!isNewUser) {
        [chooseButton setEnabled:NO];
        [createTeamButton setEnabled:NO];
        [quitTeamButton setEnabled:YES];
    } else {
        [chooseButton setEnabled:YES];
        [createTeamButton setEnabled:YES];
        [quitTeamButton setEnabled:NO];
    }
    
    self.teamTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 155) style:UITableViewStylePlain];
    self.teamTableView.delegate = self;
    self.teamTableView.dataSource = self;
    [self.teamTableView setBackgroundColor:[UIColor orangeColor]];
    [self.teamTableView setSeparatorColor:[UIColor orangeColor]];
    [self.teamTableView setTintColor:[UIColor orangeColor]];
    [self.teamTableView setAlpha:0.7];
    
    [self.teamActionSheet addSubview:self.teamTableView];
    
    [self.teamActionSheet showInView:self.view];
    [self.teamActionSheet setBounds:CGRectMake(0, 0, 320, 580)];
}

- (void)cancelButtonTapped {
    [self.teamActionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)chooseButtonTapped {
    if (selectedTeam.length != 0) {
       //NSLog(@"team: %@", selectedTeam);
        [self cancelButtonTapped];
        role = member;
        warningLabel.hidden = YES;
        [self joinTeam:selectedTeam role:role];
    } else {
        warningLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 155, 320, 30)];
        warningLabel.text = @"You have to CHOOSE a Team";
        warningLabel.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Futura"] objectAtIndex:3] size:11];
        warningLabel.textColor = [UIColor redColor];
        warningLabel.textAlignment = NSTextAlignmentCenter;
        [teamActionSheet addSubview:self.warningLabel];
        warningLabel.hidden = NO;

    }
}

- (void)createTeamButtonTapped {
    [self cancelButtonTapped];
    createTeamAlert = [[UIAlertView alloc] initWithFrame:CGRectMake(160, 160, 150, 100)];

    [createTeamAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [createTeamAlert setTitle:@"Create your Team"];
    [createTeamAlert setMessage:@"Enter the Name of Your Team"];
    [createTeamAlert addButtonWithTitle:@"Create"];
    [createTeamAlert addButtonWithTitle:@"Cancel"];
    [createTeamAlert setCancelButtonIndex:1];
    [createTeamAlert setDelegate:self];
    [createTeamAlert show];
}

- (void)quitTeamButtonTapped {
    
    quitWarning = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                             message:[NSString stringWithFormat:@"Are you sure you want to quit %@ team?", [[NSUserDefaults standardUserDefaults] stringForKey:@"myTeamName"]]
                                            delegate:self
                                   cancelButtonTitle:@"Cancel"
                                   otherButtonTitles:@"Yes", nil];
    [self cancelButtonTapped];
    [quitWarning show];
}

- (void)dismissCurrentTeamButtonTapped {
    
    dismissWarning = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                             message:[NSString stringWithFormat:@"Are you sure you want to dismiss %@ team?", [[NSUserDefaults standardUserDefaults] stringForKey:@"myTeamName"]]
                                            delegate:self
                                   cancelButtonTitle:@"Cancel"
                                   otherButtonTitles:@"Yes", nil];
    [self cancelButtonTapped];
    [dismissWarning show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView == createTeamAlert) {
      if (buttonIndex == 0) {
        //NSLog(@"created: %@", [alertView textFieldAtIndex:buttonIndex].text);
        if ([alertView textFieldAtIndex:buttonIndex].text.length != 0) {
            NSString *teamName = [alertView textFieldAtIndex:buttonIndex].text;
            role = creator;

            NSURL *url = [NSURL URLWithString:getTeamNameURL];
            NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
            
            [urlRequest setHTTPMethod:@"POST"];
            
            NSString *postString = [NSString stringWithFormat:@"teamname=%@",teamName];
            
            [urlRequest setValue:[NSString stringWithFormat:@"%d", [postString length]] forHTTPHeaderField:@"Content-length"];
            
            [urlRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
            
            [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
            
            [self joinTeam:teamName role:role];
            
        } else {
            NSLog(@"nothing");
        }
      }
    } else if (alertView == dismissWarning) {
        [self dismissCurrentTeam];
    } else {
        if (buttonIndex == 1) {
            [self quitCurrentTeam];
        } else {
            
        }
    }
}

#pragma mark - popover

- (void)mySideViewControllerDidFinish:(MySideViewController *)controller {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
       [myPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)passNewUser:(BOOL)isTheNewUser {
    isNewUser = isTheNewUser;
}

- (void)passSelectedTeam:(NSString *)theSelectedTeam {
    selectedTeam = theSelectedTeam;
}

- (void)passRole:(NSString *)theRole {
    role = theRole;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    myPopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showPopover"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            myPopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
}

- (IBAction)togglePopover:(id)sender{
    if (myPopoverController) {
        [myPopoverController dismissPopoverAnimated:YES];
        myPopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showPopover" sender:sender];
    }
}

#pragma mark FBrequest

- (void)requestPermissionAndPost {
    [FBSession.activeSession requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error) {
       if(!error && [FBSession.activeSession.permissions
                     indexOfObject:@"publish_actions"] != NSNotFound) {
           // Now have the permission
           // [self ...];
       } else if (error){
           // Facebook SDK * error handling *
           // if the operation is not user cancelled
           if (error.fberrorCategory != FBErrorCategoryUserCancelled) {
               [self presentAlertForError:error];
           }
       }
    }];
}

- (void) presentAlertForError:(NSError *)error {
    // Facebook SDK * error handling *
    if (error.fberrorShouldNotifyUser) {
        // The SDK has a message for the user, surface it.
        [[[UIAlertView alloc] initWithTitle:@"Something Went Wrong" message:error.fberrorUserMessage delegate:nil cancelButtonTitle:@"I See" otherButtonTitles:nil] show];
    } else {
        NSLog(@"unexpected error:%@", error);
    }
}

- (void)populateUserDetails
{
    if (FBSession.activeSession.isOpen){
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error){
             if(!error){
                 [[NSUserDefaults standardUserDefaults] setObject:user.id forKey:@"userId"];
                 [[NSUserDefaults standardUserDefaults] setObject:user.name forKey:@"userName"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
             }
         }];
    }
}


- (IBAction)logoutButtonTapped:(id)sender
{
    if([FBSession activeSession].isOpen){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"zhongqil.FitBitChallenge.activityIndicatorOff" object:self];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - datepicker

- (IBAction)dateValueChanged:(id)sender
{
    //NSLog(@"time:%@", _datePicker.date.description);
    [_timer invalidate];
    _timer = nil;
    [self performSelector:@selector(dateSelected) withObject:nil afterDelay:0.5f];
}

- (void)dateSelected
{
    [self getSteps];
    [self getSendentryMinutes];
    [self getActiveMinutes];
}

- (void) getSteps {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",getDataURL, getStepsURL, [currentDate stringFromDate:self.datePicker.date]]];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    
    if ([[data description] isEqualToString:@"<5b5d>"]) {
        self.stepBar.progress = 0.f;
        self.stepLabel.text = @"None";
    } else {
    
        self.json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
        NSString *steps = [[self.json objectAtIndex:0] objectForKey:@"Steps"];
       float fstep =[steps floatValue];
       //self.stepBar.progress = fstep/15000;
       [self.stepBar setProgress:fstep/15000 animated:YES];
       self.stepLabel.text = steps;
    }
}

- (void) getSendentryMinutes {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",getDataURL, getSedentryURL, [currentDate stringFromDate:self.datePicker.date]]];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    
    if ([[data description] isEqualToString:@"<5b5d>"]) {
        self.seMinBar.progress = 0.f;
        self.seMinLabel.text = @"None";
    } else {
    
        self.json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
        NSString *seMinutes = [[self.json objectAtIndex:0] objectForKey:@"SedentryMinutes"];
        float fsMin =[seMinutes floatValue];
        //self.seMinBar.progress = fsMin/1000;
        [self.seMinBar setProgress:fsMin/1000 animated:YES];
        self.seMinLabel.text = seMinutes;
    }
}

- (void) getActiveMinutes {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",getDataURL, getActiveURL, [currentDate stringFromDate:self.datePicker.date]]];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];

    if ([[data description] isEqualToString:@"<5b5d>"]) {
        self.acMinBar.progress = 0.f;
        self.acMinLabel.text = @"None";
    } else {
    
       self.json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
       NSString *acMinutes = [[self.json objectAtIndex:0] objectForKey:@"VeryActiveMinutes"];
       float facMin =[acMinutes floatValue];
       //self.acMinBar.progress = facMin/1000;
       [self.acMinBar setProgress:facMin/1000 animated:YES];
       self.acMinLabel.text = acMinutes;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // IF user presses cancel,do nothing
    if (buttonIndex == actionSheet.cancelButtonIndex)
        return;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (tableView == teamTableView) {
        return 1;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == teamTableView) {
        return teamJson.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == teamTableView) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text = [[teamJson objectAtIndex:indexPath.row] objectForKey:@"Team_Name"];
        cell.textLabel.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Futura"] objectAtIndex:3] size:21];
        cell.backgroundColor = [UIColor orangeColor];
        return cell;

    } else {
        
        static NSString *CellIdentifier = @"Main_Cell";
        MainCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
        if(cell == nil) {
            cell = [[MainCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier];
        
        }
    
        cell.userNameLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"userName"];
        cell.userPicView.profileID = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
        // Configure the cell...
    
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        if (tableView == teamTableView) {
            selectedTeam = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        } else {
    
            [self checkUser];
            if (isNewUser) {
                [self editButtonTapped:nil];
            } else {
    
                SLAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
                UIViewController *inTeamViewController = [appDelegate.mainMenuStoryBoard instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
                [self.navigationController pushViewController:inTeamViewController animated:YES];
            }
        }
    } else {
        [self checkUser];
        if (isNewUser) {
           [self performSegueWithIdentifier:@"showPopover" sender:self];
        } else {
            SLAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
            UIViewController *inTeamViewController = [appDelegate.mainMenuStoryBoard instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
            [self.navigationController pushViewController:inTeamViewController animated:YES];
        }
        //NSLog(@"user");
    }
}


#pragma mark - Check First Time User Delegate

- (void) checkUser {
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?userId=%@", getUserIdURL, userId]];
    
    NSData *data = [NSData dataWithContentsOfURL:url];

    if ([[data description] isEqualToString: nullData]) {
        isNewUser = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"zhongqil.FitBitChallenge.closeTracktivity" object:nil];
    } else {
        isNewUser = NO;
        NSLog(@"myteamname : %@",[[[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil] objectAtIndex:0] objectForKey:@"Team_Name"]);
        [[NSUserDefaults standardUserDefaults] setObject:[[[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil] objectAtIndex:0] objectForKey:@"Team_Name"] forKey:@"myTeamName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        role = [[[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil] objectAtIndex:0] objectForKey:@"Role"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"zhongqil.FitBitChallenge.openTracktivity" object:nil];
    }
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    int code = [httpResponse statusCode];
}


- (void) getTeamName {

    NSURL *url = [NSURL URLWithString:getTeamNameURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    teamJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

}

- (void) joinTeam: (NSString *)teamName role: (NSString *)myRole{
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"userName"];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    
    NSURL *url = [NSURL URLWithString:getUserIdURL];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [urlRequest setHTTPMethod:@"POST"];
    
    NSString *postString = [NSString stringWithFormat:@"username=%@&userId=%@&teamname=%@&role=%@", username, userId, teamName, myRole];
    
    [urlRequest setValue:[NSString stringWithFormat:@"%d", [postString length]] forHTTPHeaderField:@"Content-length"];
    
    [urlRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"zhongqil.FitBitChallenge.openTracktivity" object:nil];
}

- (void)quitCurrentTeam {
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    NSString *delete = @"delete";
    role = @"";

    NSURL *url = [NSURL URLWithString:getUserIdURL];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [urlRequest setHTTPMethod:@"POST"];
    
    NSString *postString = [NSString stringWithFormat:@"userId=%@&delete=%@", userId, delete];
    
    [urlRequest setValue:[NSString stringWithFormat:@"%d", [postString length]] forHTTPHeaderField:@"Content-length"];
    
    [urlRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"zhongqil.FitBitChallenge.closeTracktivity" object:nil];
}

- (void)dismissCurrentTeam {
    NSString *myTeamName = [[NSUserDefaults standardUserDefaults] stringForKey:@"myTeamName"];
    NSString *delete = @"delete";

    NSURL *url = [NSURL URLWithString:getTeamNameURL];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [urlRequest setHTTPMethod:@"POST"];
    
    NSString *postString = [NSString stringWithFormat:@"teamname=%@&delete=%@", myTeamName, delete];
    
    [urlRequest setValue:[NSString stringWithFormat:@"%d", [postString length]] forHTTPHeaderField:@"Content-length"];
    
    [urlRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    [self quitCurrentTeam];
}

@end
