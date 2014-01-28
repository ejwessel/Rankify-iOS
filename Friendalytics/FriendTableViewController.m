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
    NSLog(@"total friends: %i",(int)friendData.count);
    
    //set the back button here so that it doesn't show "back"
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
//    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStyleBordered target:self action:@selector(shareContent)];
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStylePlain target:self action:@selector(post)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    
    filteredResults = [[NSMutableArray alloc] initWithCapacity:friendData.count];

}

- (void)viewWillAppear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    self.navigationController.navigationBarHidden = false;
    //determine if we are using the search bar or the table view
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        friendObject = [[filteredResults objectAtIndex:indexPath.row] objectForKey:@"User"];
    }
    else{
        friendObject = [[friendData objectAtIndex:indexPath.row] objectForKey:@"User"];
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath]; //warning shouldn't be a problem
    friendName = cell.textLabel.text;
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
//    NSURL *url = [NSURL URLWithString:cellDownload.urlPath];
//    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
//    UIImage *tmpImage = [[UIImage alloc] initWithData:data];
//    cellDownload.imageView.image = tmpImage;
    for (CustomCell *c in [self.tableView visibleCells]) {
        NSURL *url = [NSURL URLWithString:c.urlPath];
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        UIImage *tmpImage = [[UIImage alloc] initWithData:data];
        c.imageView.image = tmpImage;
    }
}

- (void)post{
    [[[UIAlertView alloc] initWithTitle:@"Post to Facebook"
                                message:@"This will post the top 10 people to your facebook. Click \"Post\" below to post to your wall!"
                               delegate:self
                      cancelButtonTitle:@"Cancel"
                      otherButtonTitles:@"Post", nil] show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //if the post button was clicked
    if (buttonIndex == 1){
        NSLog(@"post was clicked");
        [self shareContent];
    }
}
- (void)shareContent{
    
    //if there are at least some friends
    if(friendData.count > 0){
        NSString *topTenFriends = @"Top 10 Friends:";
        
        int count = 10;
        //if the friendData is smaller than top 10, adjust
        if(friendData.count < count){
            count = (int)friendData.count;
        }
        
        for (int i = 0; i < count; i++) {
            NSMutableDictionary *friend = [[friendData objectAtIndex:i] objectForKey:@"User"];
            NSString *name = [friend objectForKey:@"name"];
            NSString *username = [friend objectForKey:@"userName"];
            NSString *total = [friend objectForKey:@"totalLikes"];
            int index = i + 1;
            topTenFriends = [NSString stringWithFormat:@"%@\n %i. %@ : %@ Likes", topTenFriends, index, name, total];
        }
        
        [FBRequestConnection startForPostStatusUpdate:topTenFriends
                                    completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                        if (!error) {
                                            // Status update posted successfully to Facebook
                                            NSLog(@"Top 10 Friends published");
                                            
                                            [[[UIAlertView alloc] initWithTitle:@"Posted to Facebook"
                                                                        message:@""
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil] show];
                                        }
                                        else {
                                            // An error occurred, we need to handle the error
                                            // See: https://developers.facebook.com/docs/ios/errors
                                            NSLog([NSString stringWithFormat:@"%@", error.description]);
                                            
                                            [[[UIAlertView alloc] initWithTitle:@"Error posting to Facebook"
                                                                        message:@"Note: If you hit \"Skip\" on allowing Friendalytics to post to Facebook, you given invalid permissions and will need to clear them by going to Facebook > Settings > Apps > Click \'X\' to remove Friendalytics > Logout of the Friendalytics App and then Log back into the Friendalytics App."
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil] show];
                                        }
                                    }];
    }
    //if there happens to be no friends
    else{
        [[[UIAlertView alloc] initWithTitle:@"Error posting to Facebook - no friends to post"
                                                        message:@""
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil] show];
    }
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    NSLog(@"did end scrolling");
//    [self downloadAndLoadImageWithCell];
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    NSLog(@"did end dragging");
//    [self downloadAndLoadImageWithCell];
//}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.filteredResults removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"User.name CONTAINS[c] %@", searchText];
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
    
    cell.imageView.image = nil;
    
    NSString *fullName = [[element objectForKey:@"User"] objectForKey:@"name"];//[self makeFullName:element];
    NSString *totalLikes = [NSString stringWithFormat:@"%@", [[element objectForKey:@"User"] objectForKey:@"totalLikes"]];
    NSString *urlPath = [[element objectForKey:@"User"] objectForKey:@"profilePictureSmall"];
    
    //load the small icon on the list of friends
    //setup the cell
    //cell.nameLabel.text = fullName;
    cell.textLabel.text = fullName;
    cell.countLabel.text = totalLikes;
    cell.countLabel.textColor = self.navigationController.navigationBar.tintColor;
    cell.urlPath = urlPath;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
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
