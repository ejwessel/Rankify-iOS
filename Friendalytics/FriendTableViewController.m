//
//  FriendTableViewController.m
//  Friendalytics
//
//  Created by Ethan Wessel on 1/18/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import "FriendTableViewController.h"

@interface FriendTableViewController ()

@end

@implementation FriendTableViewController
@synthesize friendData;
@synthesize friendName;
@synthesize friendObject;
@synthesize searchBar;
@synthesize filteredResults;
@synthesize cellDownload;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSLog(@"total friends: %i",friendData.count);
    
    //set the back button here so that it doesn't show "back"
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    filteredResults = [[NSMutableArray alloc] initWithCapacity:friendData.count];

}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.navigationController.navigationBarHidden = false;
    //determine if we are using the search bar or the table view
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        friendObject = [[filteredResults objectAtIndex:indexPath.row] objectForKey:@"User"];
    }
    else{
        friendObject = [[friendData objectAtIndex:indexPath.row] objectForKey:@"User"];
    }
    
    CustomCell *cell = [tableView cellForRowAtIndexPath:indexPath]; //warning shouldn't be a problem
    friendName = cell.nameLabel.text;
    NSLog(@"clicked on: %@", friendName);
    
    //this calls "prepareForSegue" since prepare for segue has has priority over this function
    //we need to call this function first, this is how we do it
    [self performSegueWithIdentifier:@"segueToSpecifics" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //this function will be called after didSelectRowAtIndexPath
    
    if([segue.identifier isEqualToString:@"segueToSpecifics"]){
        SpecificsViewController *controller = (SpecificsViewController *)segue.destinationViewController;
        controller.friendName = friendName;
        controller.totalLikes = [NSString stringWithFormat:@"%@", [friendObject objectForKey:@"totalLikes"]];
        controller.totalPhotoLikes = [NSString stringWithFormat:@"%@", [friendObject objectForKey:@"photoLikes"]];
        controller.totalAlbumLikes = [NSString stringWithFormat:@"%@", [friendObject objectForKey:@"albumLikes"]];
        controller.totalVideoLikes = [NSString stringWithFormat:@"%@", [friendObject objectForKey:@"videoLikes"]];
        controller.totalStatusLikes = [NSString stringWithFormat:@"%@", [friendObject objectForKey:@"statusLikes"]];
        controller.profilePictureURL = [friendObject objectForKey:@"profilePictureLarge"];
    }
}

- (void)downloadAndLoadImageWithCell{
    NSURL *url = [NSURL URLWithString:cellDownload.urlPath];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    UIImage *tmpImage = [[UIImage alloc] initWithData:data];
    cellDownload.smallIconPicture.image = tmpImage;
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.filteredResults removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"User.firstName CONTAINS[c] %@",searchText];
    filteredResults = [NSMutableArray arrayWithArray:[friendData filteredArrayUsingPredicate:predicate]];
    //NSLog(@"filteredResults: %@", filteredResults);
    //NSLog(@"filteredResults: %i", filteredResults.count);
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(tableView == self.searchDisplayController.searchResultsTableView){
        return filteredResults.count;
    }
    else{
        return friendData.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CustomCell";
    CustomCell *cell;
    NSDictionary *element = nil;
    
    //determine if we are using the tableview or search display controller
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];   //must go here
        element = [filteredResults objectAtIndex:indexPath.row];
    }
    else{
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];   //must go here
        element = [friendData objectAtIndex:indexPath.row];
    }
    
    NSString *fullName = [self makeFullName:element];
    NSString *totalLikes = [NSString stringWithFormat:@"%@", [[element objectForKey:@"User"] objectForKey:@"totalLikes"]];
    NSString *urlPath = [[element objectForKey:@"User"] objectForKey:@"profilePictureSmall"];
    
    //load the small icon on the list of friends
    //setup the cell
    cell.nameLabel.text = fullName;
    cell.countLabel.text = totalLikes;
    cell.countLabel.textColor = self.navigationController.navigationBar.tintColor;
    cell.urlPath = urlPath;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //cellDownload = cell;
    
    //bug with loading small images...
    //[NSThread detachNewThreadSelector:@selector(downloadAndLoadImageWithCell) toTarget:self withObject:nil];
    //[self performSelectorInBackground:@selector(downloadAndLoadImageWithCell) withObject:nil];
    return cell;
}

- (NSString*) makeFullName:(NSDictionary*) element{
    NSString *firstName = [[element objectForKey:@"User"] objectForKey:@"firstName"];
    NSString *lastName = [[element objectForKey:@"User"] objectForKey:@"lastName"];
    return [NSString stringWithFormat:@"%@ %@", firstName, lastName];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
