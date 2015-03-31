//
//  IndividualRankViewController.m
//  FitBitChallenge
//
//  Created by 李中琦 on 13-11-25.
//  Copyright (c) 2013年 李中琦. All rights reserved.
//

#import "IndividualRankViewController.h"

@interface IndividualRankViewController ()

@end

#define getIndieURL @"http://lawson.cis.utas.edu.au/~zhongqil/fitBitTest/IndieRank.php"

@implementation IndividualRankViewController

@synthesize selectedName = _selectedName;
@synthesize json = _json;

@synthesize nameSearchBar;
@synthesize filteredNames;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = [NSString stringWithFormat:@"%@'s Rank", self.selectedName];
    //NSLog(@"selected name : %@", self.selectedName);
    [self retrieveIndieData];
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
        //return [searchResults count];
    } else {
        return self.json.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Indie_Cell";
    IndividualCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil) {
        cell = [[IndividualCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier];
        NSLog(@"nil");
    
    }
    
    NSMutableArray *newJson; //= [[NSMutableArray alloc] init];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        newJson = filteredNames;
    } else {
        newJson = self.json;
    }
    
    // Configure the cell...
    cell.indiNameLabel.text = [[newJson objectAtIndex:indexPath.row] objectForKey:@"Username"];
    cell.indiStepLabel.text = [NSString stringWithFormat:@"Total Steps: %@", [[newJson objectAtIndex:indexPath.row] objectForKey:@"Total_Steps"]];
    cell.indiRankLabel.text = [NSString stringWithFormat:@"Rank: %@", [[newJson objectAtIndex:indexPath.row] objectForKey:@"Indie_Rank"]];
    cell.indiProgress.progress = [[[newJson objectAtIndex:indexPath.row] objectForKey:@"Total_Steps"] floatValue]/250000;
     NSLog(@"indiname : %@", [NSString stringWithFormat:@"Total Steps: %@", [[newJson objectAtIndex:indexPath.row] objectForKey:@"Total_Steps"]]);
    cell.indiTeamLabel.text = [NSString stringWithFormat:@"Team: %@", [[newJson objectAtIndex:indexPath.row] objectForKey:@"Team_Name"]];
    
    if ([[[cell indiNameLabel] text] isEqualToString:[self selectedName]]) {
        NSLog(@"called");
        cell.backgroundColor = [UIColor colorWithRed:0 green:0.3333 blue:0.6667 alpha:0.8];
        cell.indiProgress.progressTintColor = [UIColor whiteColor];
        cell.indiProgress.trackTintColor = [UIColor colorWithRed:0 green:0.3333 blue:0.6667 alpha:0.8];
        cell.indiNameLabel.textColor = [UIColor whiteColor];
        cell.indiRankLabel.textColor = [UIColor whiteColor];
        cell.indiStepLabel.textColor = [UIColor whiteColor];
        cell.indiTeamLabel.textColor = [UIColor whiteColor];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

}


#pragma mark - retrieve Data

- (void)retrieveIndieData {
    NSURL *url = [NSURL URLWithString:getIndieURL];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    self.json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

#pragma mark - Content Filtering

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    
    [self.filteredNames removeAllObjects];
    NSString *names = @"Username";
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
    tableView.rowHeight = 137;
}


@end
