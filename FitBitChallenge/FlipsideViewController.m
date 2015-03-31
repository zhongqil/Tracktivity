//
//  FlipsideViewController.m
//  FitBitChallenge
//
//  Created by 李中琦 on 13-11-16.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import "FlipsideViewController.h"

@interface FlipsideViewController () {
    NSMutableArray *_objects;
}

@end

#define ReloadMasterTableNotification @"ReloadMasterTableNotification"

@implementation FlipsideViewController

@synthesize competition_json;

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController setTitle:@"Tracks"];
    
    [self.tableView registerClass:[CompCell class] forCellReuseIdentifier:@"Flip_Cell"];
    
    UIBarButtonItem *chooseButton = [[UIBarButtonItem alloc] initWithTitle:@"Choose"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(chooseButtonTapped)];
    self.navigationItem.rightBarButtonItem = chooseButton;
    self.fbChallengeViewController = (FBChallengeViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadMasterView:)
                                                 name:ReloadMasterTableNotification
                                               object:_fbChallengeViewController];
   // NSLog(@"compJson: %@", competition_json);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ReloadMasterTableNotification
                                                  object:nil];
}

#pragma mark - Table view data source

- (void)reloadMasterView: (NSNotification *)notification {
    NSDictionary *dict = [notification userInfo];
    competition_json = [dict objectForKey:@"CompJson"];

    [self.tableView reloadData];
    NSLog(@"compJson : %@", [[competition_json objectAtIndex:2] objectForKey:@"Destination_Title"]);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.competition_json.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flip_Cell";
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
        [self.fbChallengeViewController.navigationController pushViewController:routeViewController animated:YES];
    } else {
        self.warningLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 190, 320, 30)];
        self.warningLabel.text = @"You must CHOOSE a tracktivity";
        self.warningLabel.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Futura"] objectAtIndex:3] size:18];
        self.warningLabel.textColor = [UIColor redColor];
        self.warningLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_warningLabel];
        self.warningLabel.hidden = NO;
    }
}

@end
