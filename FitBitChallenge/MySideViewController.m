//
//  PopoverViewController.m
//  FitBitChallenge
//
//  Created by 李中琦 on 13-12-17.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import "MySideViewController.h"
#import "MainMenuViewController.h"

@interface MySideViewController ()

@end

#define getUserIdURL @"http://lawson.cis.utas.edu.au/~zhongqil/fitBitTest/UserInfo.php"
#define getTeamNameURL @"http://lawson.cis.utas.edu.au/~zhongqil/fitBitTest/TeamRank.php"

BOOL isTheNewUser = YES;
static NSString *nullData = @"<5b5d>";
static NSString *member = @"Member";
static NSString *creator = @"Creator";
NSString *selectedTeam;

@implementation MySideViewController {
    MainMenuViewController *mainMenuViewController;
}

@synthesize teamTableView;
@synthesize teamJson;
@synthesize createTeamAlert;
@synthesize warningLabel;
@synthesize quitWarning;
@synthesize dismissWarning;
@synthesize role;

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    SLAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    mainMenuViewController = [appDelegate.mainMenuStoryBoard instantiateViewControllerWithIdentifier:@"MainMenuViewController"];
    
    [self didShowPopover];
}

- (void)didShowPopover {
    [self getTeamName];
    [self checkUser];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 760, 320, 50)];
    [cancelButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.adjustsImageWhenHighlighted = YES;
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithRed:0/255.0f green:177/255.0f blue:148/255.0f alpha:1.0f] forState:UIControlStateNormal];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    cancelButton.titleLabel.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Futura"] objectAtIndex:3] size:21];
    
    [self.view addSubview:cancelButton];
    
    
    UIButton *chooseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 675, 320, 50)];
    [chooseButton addTarget:self action:@selector(chooseButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [chooseButton setTitle:@"Choose" forState:UIControlStateNormal];
    [chooseButton setTitleColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [chooseButton setTitleColor:[UIColor colorWithRed:0/255.0f green:177/255.0f blue:148/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
    [chooseButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    chooseButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    chooseButton.titleLabel.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Futura"] objectAtIndex:3] size:21];
    
    [self.view addSubview:chooseButton];
    
    UIButton *createTeamButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 715, 160, 50)];
    [createTeamButton addTarget:self action:@selector(createTeamButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [createTeamButton setTitle:@"Create A Team" forState:UIControlStateNormal];
    [createTeamButton setTitleColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [createTeamButton setTitleColor:[UIColor colorWithRed:0/255.0f green:177/255.0f blue:148/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
    [createTeamButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    createTeamButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    createTeamButton.titleLabel.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Futura"] objectAtIndex:3] size:15];
    
    [self.view addSubview:createTeamButton];
    
    UIButton *quitTeamButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 715, 160, 50)];
    [quitTeamButton addTarget:self action:@selector(quitTeamButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [quitTeamButton setTitle:@"Quit My Team" forState:UIControlStateNormal];
    [quitTeamButton setTitleColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [quitTeamButton setTitleColor:[UIColor colorWithRed:0/255.0f green:177/255.0f blue:148/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
    [quitTeamButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    quitTeamButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    quitTeamButton.titleLabel.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Futura"] objectAtIndex:3] size:15];
    
    [self.view addSubview:quitTeamButton];
    
    UIButton *dismissTeamButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 815, 160, 50)];
    [dismissTeamButton addTarget:self action:@selector(dismissCurrentTeamButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [dismissTeamButton setTitle:@"Dismiss My Team" forState:UIControlStateNormal];
    [dismissTeamButton setTitleColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [dismissTeamButton setTitleColor:[UIColor colorWithRed:0/255.0f green:177/255.0f blue:148/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
    [dismissTeamButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    dismissTeamButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    dismissTeamButton.titleLabel.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Futura"] objectAtIndex:3] size:15];
    
    [self.view addSubview:dismissTeamButton];
    
    if ([role isEqualToString:creator]) {
        quitTeamButton.hidden = YES;
        dismissTeamButton.hidden = NO;
        [dismissTeamButton setEnabled:YES];
    } else {
        quitTeamButton.hidden = NO;
        dismissTeamButton.hidden = YES;
        [dismissTeamButton setEnabled:NO];
    }
    
    
    if (!isTheNewUser) {
        [chooseButton setEnabled:NO];
        [createTeamButton setEnabled:NO];
        [quitTeamButton setEnabled:YES];
    } else {
        [chooseButton setEnabled:YES];
        [createTeamButton setEnabled:YES];
        [quitTeamButton setEnabled:NO];
    }
    
    teamTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 655) style:UITableViewStylePlain];
    teamTableView.delegate = self;
    teamTableView.dataSource = self;
    [teamTableView setBackgroundColor:[UIColor orangeColor]];
    [teamTableView setSeparatorColor:[UIColor orangeColor]];
    [teamTableView setTintColor:[UIColor orangeColor]];
    [teamTableView setAlpha:0.7];
    
    [self.view addSubview:teamTableView];
}

- (void)cancelButtonTapped {
    [self.delegate mySideViewControllerDidFinish:self];
}

- (void)chooseButtonTapped {
    if (selectedTeam.length != 0) {
        NSLog(@"team: %@", selectedTeam);
        [self cancelButtonTapped];
        role = member;
        warningLabel.hidden = YES;
        [self joinTeam:selectedTeam role:role];
        [self.delegate passRole:role];
    } else {
        warningLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 155, 320, 30)];
        warningLabel.text = @"You have to CHOOSE a Team";
        warningLabel.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Futura"] objectAtIndex:3] size:11];
        warningLabel.textColor = [UIColor redColor];
        warningLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:self.warningLabel];
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
            NSLog(@"created: %@", [alertView textFieldAtIndex:buttonIndex].text);
            
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
                [self.delegate passRole:role];
                
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
        return teamJson.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedTeam = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    [self.delegate passSelectedTeam:selectedTeam];
}


#pragma mark - Check First Time User Delegate

- (void) checkUser {
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?userId=%@", getUserIdURL, userId]];
    
    NSData *data = [NSData dataWithContentsOfURL:url];

    if ([[data description] isEqualToString: nullData]) {
        isTheNewUser = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"zhongqil.FitBitChallenge.closeTracktivity" object:nil];
    } else {
        isTheNewUser = NO;
        NSLog(@"myteamname : %@",[[[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil] objectAtIndex:0] objectForKey:@"Team_Name"]);
        [[NSUserDefaults standardUserDefaults] setObject:[[[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil] objectAtIndex:0] objectForKey:@"Team_Name"] forKey:@"myTeamName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        role = [[[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil] objectAtIndex:0] objectForKey:@"Role"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"zhongqil.FitBitChallenge.openTracktivity" object:nil];
    }
    [self.delegate passNewUser:isTheNewUser];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
