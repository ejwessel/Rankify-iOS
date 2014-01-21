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
    
    int indexClicked = [indexPath indexAtPosition:[indexPath length] - 1];
    
    friendObject = [[friendData objectAtIndex:indexClicked] objectForKey:@"User"];
    
    self.navigationController.navigationBarHidden = false;
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

- (void)downloadAndLoadImageWithCell:(CustomCell *)cell withURL:(NSString *)urlPath{
    //THIS FUNCTION IS NOT CURRENTLY USED! COME BACK TO IT
    NSURL *url = [NSURL URLWithString:urlPath];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    UIImage *tmpImage = [[UIImage alloc] initWithData:data];
    cell.image = tmpImage;
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.filteredResults removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
    filteredResults = [NSMutableArray arrayWithArray:[friendData filteredArrayUsingPredicate:predicate]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return friendData.count;
}

- (CustomCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CustomCell";
    
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    int index = [indexPath indexAtPosition:[indexPath length] - 1];
    cell.arrayIndex = index;    //sets the index for the cell so we know where in the friendData to find it
    NSDictionary *element = [friendData objectAtIndex:index];
    
    //make full name to display
    NSString *firstName = [[element objectForKey:@"User"] objectForKey:@"firstName"];
    NSString *lastName = [[element objectForKey:@"User"] objectForKey:@"lastName"];
    NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    NSString *totalLikes = [NSString stringWithFormat:@"%@", [[element objectForKey:@"User"] objectForKey:@"totalLikes"]];
    
    //load the small icon on the list of friends
    //NSString *url = [[element objectForKey:@"User"] objectForKey:@"profilePictureSmall"];
    //[self downloadAndLoadImageWithCell:cell withURL:url];
    //[self performSelectorInBackground:@selector(downloadAndLoadImageWithCell:(CustomCell*)cell withURL:(NSString*)url) withObject:nil];

    //setup the cell
    cell.nameLabel.text = fullName;
    cell.countLabel.text = totalLikes;
    cell.countLabel.textColor = self.navigationController.navigationBar.tintColor;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
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
