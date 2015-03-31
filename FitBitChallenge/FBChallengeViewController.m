//
//  FBChallengeViewController.m
//  FitBitChallenge
//
//  Created by 李中琦 on 13-11-15.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import "FBChallengeViewController.h"
#import "FriendViewController.h"
#import "RouteTracingViewController.h"

@interface FBChallengeViewController ()
{
    UINavigationController *FBChallengeNavigationController;
    FlipsideViewController *flipViewController;
    RouteTracingViewController *routeController;
    NSTimer *timer;
}

@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end

#define getTeamNameURL @"http://lawson.cis.utas.edu.au/~zhongqil/fitBitTest/IndieRank.php"
#define getCompetitionURL @"http://lawson.cis.utas.edu.au/~zhongqil/fitBitTest/Competitions.php"
#define ReloadMasterTableNotification @"ReloadMasterTableNotification"

@implementation FBChallengeViewController

@synthesize competition_json = _competition_json;

@synthesize trackActionSheet = _trackActionSheet;
@synthesize competitionView = _competitionView;

@synthesize warningLabel = _warningLabel;
@synthesize clockLabel = _clockLabel;
@synthesize iPadWarningLabel = _iPadWarningLabel;

@synthesize latitude = _latitude;
@synthesize longtitude = _longtitude;
@synthesize dest_Title = _dest_Title;
@synthesize dest_Snippet = _dest_Snippet;
@synthesize start_Time = _start_Time;
@synthesize trackTivityName = _trackTivityName;

- (id)init {
    if (self = [super init]) {
        UIImage *titleImage = [UIImage imageNamed:@"tracktivity_logo_a_r.png"];
        UIImageView *titleImageView = [[UIImageView alloc] initWithImage:titleImage];
        
        titleImageView.frame = CGRectMake(0, 0, 150, 40);
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
              titleImageView.contentMode = UIViewContentModeScaleAspectFill;
              self.navigationItem.titleView = titleImageView;
        } else {
            self.navigationItem.title = @"tracktivity";
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    for (UIButton *button in [self.menu subviews])
        [button setAlpha:.95f];
    
    [self.competitionView registerClass:[CompCell class] forCellReuseIdentifier:@"Comp_Cell"];
    [self getCompetition];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(makeActionSheet)
                                                 name:@"zhongqil.FitBitChallenge.makeActionSheet"
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - KYCircleMenu Button Action

// Run button action depend on their tags:
//
// TAG:        1       1   2      1   2     1   2     1 2 3     1 2 3
//            \|/       \|/        \|/       \|/       \|/       \|/
// COUNT: 1) --|--  2) --|--   3) --|--  4) --|--  5) --|--  6) --|--
//            /|\       /|\        /|\       /|\       /|\       /|\
// TAG:                             3       3   4     4   5     4 5 6
//
- (void)runButtonActions:(id)sender {
    [super runButtonActions:sender];
    
    // Configure new view & push it with custom |pushViewController:| method
    
    switch ([sender tag]) {
        case 1:
        {
            if ([[NSUserDefaults standardUserDefaults] stringForKey:@"Latitude"].length == 0 && self.latitude.length == 0) {
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                  [self makeActionSheet];
                } else {
                    self.iPadWarningLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 500, 100)];
                    self.iPadWarningLabel.text = @"Please Choose A Tracktivity First :)";
                    self.iPadWarningLabel.hidden = NO;
                }
            } else {
            SLAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
            RouteTracingViewController *routeTracingViewController = [appDelegate.mainMenuStoryBoard instantiateViewControllerWithIdentifier:@"RouteTracingViewController"];
            [self.navigationController pushViewController:routeTracingViewController animated:YES];
            }
        };
            break;
        case 2:
        {
            SLAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
            UIViewController *routeTracingViewController = [appDelegate.mainMenuStoryBoard instantiateViewControllerWithIdentifier:@"FriendViewController"];
            [self.navigationController pushViewController:routeTracingViewController animated:YES];
        }
            ;
            break;
        case 3:
        {
            SLAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
            UIViewController *webViewController = [appDelegate.mainMenuStoryBoard instantiateViewControllerWithIdentifier:@"WebViewController"];
            [self.navigationController pushViewController:webViewController animated:YES];
        }
            ;
            break;
            
            
        default:
        {
            SLAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
            UIViewController *routeTracingViewController = [appDelegate.mainMenuStoryBoard instantiateViewControllerWithIdentifier:@"TeamInfoViewController"];
            [self.navigationController pushViewController:routeTracingViewController animated:YES];
        }
            break;
    }
}

- (void)cancelButtonTapped {
    [self.trackActionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)chooseButtonTapped {
    if(self.latitude.length != 0) {
        if (![self.latitude isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"Latitude"]]) {
            
            [[NSUserDefaults standardUserDefaults] setObject:self.trackTivityName forKey:@"Competition_Name"];
            [[NSUserDefaults standardUserDefaults] setObject:self.latitude forKey:@"Latitude"];
            [[NSUserDefaults standardUserDefaults] setObject:self.longtitude forKey:@"Longtitude"];
            [[NSUserDefaults standardUserDefaults] setObject:self.dest_Title forKey:@"Dest_Title"];
            [[NSUserDefaults standardUserDefaults] setObject:self.dest_Snippet forKey:@"Dest_Snippet"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"user_Start"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        self.warningLabel.hidden = YES;
        
        SLAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        RouteTracingViewController *routeViewController = [appDelegate.mainMenuStoryBoard instantiateViewControllerWithIdentifier:@"RouteTracingViewController"];
        [self.navigationController pushViewController:routeViewController animated:YES];
        [self cancelButtonTapped];
    } else {
        self.warningLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 190, 320, 30)];
        self.warningLabel.text = @"You must CHOOSE a tracktivity";
        self.warningLabel.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Futura"] objectAtIndex:3] size:18];
        self.warningLabel.textColor = [UIColor redColor];
        self.warningLabel.textAlignment = NSTextAlignmentCenter;
        [self.trackActionSheet addSubview:self.warningLabel];
        self.warningLabel.hidden = NO;
    }
}

- (void) getCompetition {
    NSURL *url = [NSURL URLWithString:getCompetitionURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    self.competition_json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:_competition_json forKey:@"CompJson"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ReloadMasterTableNotification object:self userInfo:dict];
}

- (void) makeActionSheet {
    NSLog(@"makeactionsheet");
    self.trackActionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose A Tracktivity"
                                                        delegate:self
                                               cancelButtonTitle:nil
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:nil];
    
    UIView *actionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    actionView.backgroundColor = [UIColor orangeColor];
    actionView.contentMode = UIViewContentModeScaleToFill;
    [self.trackActionSheet addSubview:actionView];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 260, 320, 50)];
    [cancelButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.adjustsImageWhenHighlighted = YES;
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithRed:0/255.0f green:177/255.0f blue:148/255.0f alpha:1.0f] forState:UIControlStateNormal];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    cancelButton.titleLabel.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Futura"] objectAtIndex:3] size:21];
    
    [self.trackActionSheet addSubview:cancelButton];
    
    
    UIButton *chooseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 210, 320, 50)];
    [chooseButton addTarget:self action:@selector(chooseButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [chooseButton setTitle:@"Choose" forState:UIControlStateNormal];
    [chooseButton setTitleColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [chooseButton setTitleColor:[UIColor colorWithRed:0/255.0f green:177/255.0f blue:148/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
    chooseButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    chooseButton.titleLabel.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Futura"] objectAtIndex:3] size:21];
    
    [self.trackActionSheet addSubview:chooseButton];
    
    self.competitionView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 175) style:UITableViewStylePlain];
    self.competitionView.delegate = self;
    self.competitionView.dataSource = self;
    [self.competitionView setBackgroundColor:[UIColor orangeColor]];
    [self.competitionView setSeparatorColor:[UIColor orangeColor]];
    [self.competitionView setTintColor:[UIColor orangeColor]];
    [self.competitionView setAlpha:0.7];
    
    [self.trackActionSheet addSubview:self.competitionView];
    
    [self.trackActionSheet showInView:self.view];
    [self.trackActionSheet setBounds:CGRectMake(0, 0, 320, 580)];
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
    return _competition_json.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Comp_Cell";
    CompCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if(cell == nil) {
        cell = [[CompCell alloc] initWithStyle:UITableViewCellStyleValue1
                                  reuseIdentifier:CellIdentifier];
        
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startdate = [dateFormat dateFromString:[[self.competition_json objectAtIndex:indexPath.row] objectForKey:@"DateTime_Start"]];
    NSDate *endDate = [dateFormat dateFromString:[[self.competition_json objectAtIndex:indexPath.row] objectForKey:@"DateTime_End"]];
    
        cell.tName.text = [[self.competition_json objectAtIndex:indexPath.row] objectForKey:@"Competition_Name"];
        cell.tDestination.text = [NSString stringWithFormat:@"%@, %@", [[self.competition_json objectAtIndex:indexPath.row] objectForKey:@"Destination_Snippet"], [[self.competition_json objectAtIndex:indexPath.row] objectForKey:@"Destination_Title"]];
        cell.tStartTime.text = [NSString stringWithFormat:@"Start Time: %@",[[self.competition_json objectAtIndex:indexPath.row] objectForKey:@"DateTime_Start"]];
        cell.tEndTime.text = [NSString stringWithFormat:@"End Time: %@",[[self.competition_json objectAtIndex:indexPath.row] objectForKey:@"DateTime_End"]];
    
    if ([startdate compare:[NSDate date]] == NSOrderedAscending && [endDate compare:[NSDate date]] == NSOrderedAscending) {
        cell.status.text = @"Expired";
        cell.status.textColor = [UIColor whiteColor];
        cell.tName.textColor = [UIColor whiteColor];
        cell.tDestination.textColor = [UIColor whiteColor];
        cell.tStartTime.textColor = [UIColor whiteColor];
        cell.tEndTime.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor grayColor];
        [cell setUserInteractionEnabled:NO];
    } else if ([startdate compare:[NSDate date]] == NSOrderedAscending && [endDate compare:[NSDate date]] == NSOrderedDescending) {
        cell.status.text = @"Game On!";
        cell.backgroundColor = [UIColor orangeColor];
        [cell setUserInteractionEnabled:YES];
    } else if ([startdate compare:[NSDate date]] == NSOrderedDescending && [endDate compare:[NSDate date]] == NSOrderedDescending) {
        cell.status.text = @"Coming Up Soon";
        cell.status.textColor = [UIColor redColor];
        cell.tName.textColor = [UIColor redColor];
        cell.tDestination.textColor = [UIColor redColor];
        cell.tStartTime.textColor = [UIColor redColor];
        cell.tEndTime.textColor = [UIColor redColor];
        cell.backgroundColor = [UIColor yellowColor];
        [cell setUserInteractionEnabled:NO];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    self.trackTivityName = [[self.competition_json objectAtIndex:indexPath.row] objectForKey:@"Competition_Name"];
    self.latitude = [[self.competition_json objectAtIndex:indexPath.row] objectForKey:@"Destination_Lati"];
    self.longtitude = [[self.competition_json objectAtIndex:indexPath.row] objectForKey:@"Destination_Long"];
    self.dest_Title = [[self.competition_json objectAtIndex:indexPath.row] objectForKey:@"Destination_Title"];
    self.dest_Snippet = [[self.competition_json objectAtIndex:indexPath.row] objectForKey:@"Destination_Snippet"];
    self.start_Time = [[self.competition_json objectAtIndex:indexPath.row] objectForKey:@"DateTime_Start"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160.0;
}

- (void)dealloc {
    
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc {
    barButtonItem.title = NSLocalizedString(@"Tracks", @"Tracks");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = pc;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    // Called when the view is shown again in the split view, invalidating the button and popover
    // controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.iPadWarningLabel.hidden = YES;
    self.masterPopoverController = nil;
}

@end
