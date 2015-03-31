//
//  TeamInfoViewController.m
//  FitBitChallenge
//
//  Created by 李中琦 on 13-11-23.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import "TeamInfoViewController.h"
#import "UserProfileViewController.h"

@interface TeamInfoViewController ()

@end

#define getTeamURL @"http://lawson.cis.utas.edu.au/~zhongqil/fitBitTest/TeamRank.php"

NSString *myTeamName;

@implementation TeamInfoViewController

@synthesize json = _json;

@synthesize nameSearchBar;
@synthesize filteredNames;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    myTeamName = [[NSUserDefaults standardUserDefaults] stringForKey:@"myTeamName"];
    [self retrieveTeamData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    static NSString *CellIdentifier = @"Team_Cell";
    TeamRankCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil) {
        cell = [[TeamRankCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:CellIdentifier];
    }
    
    NSMutableArray *newJson;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        newJson = filteredNames;
    } else {
        newJson = self.json;
    }
    
    // Configure the cell...
    cell.teamStepLabel.text = [NSString stringWithFormat:@"Total Steps: %@", [[newJson objectAtIndex:indexPath.row] objectForKey:@"Team_Total_Steps"]];
    cell.teamRankLabel.text = [NSString stringWithFormat:@"Rank: %@", [[newJson objectAtIndex:indexPath.row] objectForKey:@"Team_Rank"]];
    cell.teamProgress.progress = [[[newJson objectAtIndex:indexPath.row] objectForKey:@"Team_Total_Steps"] floatValue]/1000000;
    cell.teamTeamNameLabel.text = [NSString stringWithFormat:@"Team: %@", [[newJson objectAtIndex:indexPath.row] objectForKey:@"Team_Name"]];
    cell.teamPushedName = [[newJson objectAtIndex:indexPath.row] objectForKey:@"Team_Name"];
    
    if ([[cell teamPushedName] isEqualToString:myTeamName]) {
        NSLog(@"called");
        cell.backgroundColor = [UIColor colorWithRed:0 green:0.3333 blue:0.6667 alpha:0.8];
        cell.teamProgress.progressTintColor = [UIColor whiteColor];
        cell.teamProgress.trackTintColor = [UIColor colorWithRed:0 green:0.3333 blue:0.6667 alpha:0.8];
        cell.teamTeamNameLabel.textColor = [UIColor whiteColor];
        cell.teamRankLabel.textColor = [UIColor whiteColor];
        cell.teamStepLabel.textColor = [UIColor whiteColor];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TeamRankCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    SLAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
     UserProfileViewController *contributionController = [appDelegate.mainMenuStoryBoard instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
    [self.navigationController pushViewController:contributionController animated:YES];
    contributionController.pushedTeamName = cell.teamPushedName;
}

#pragma mark - Retrieve Team Data

- (void)retrieveTeamData {
    NSURL *url = [NSURL URLWithString:getTeamURL];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    self.json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

#pragma mark - Content Filtering

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    
    [self.filteredNames removeAllObjects];
    NSString *names = @"Team_Name";
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"%K contains[c] %@", names, searchText];
    
    filteredNames = [NSMutableArray arrayWithArray:[self.json filteredArrayUsingPredicate:resultPredicate]];
    
    NSLog(@"filtered: %@", filteredNames);
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
    tableView.rowHeight = 159;
}

@end
