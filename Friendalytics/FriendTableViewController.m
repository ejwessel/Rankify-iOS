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
@synthesize permissions;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    permissions = [NSArray arrayWithObjects:@"user_birthday", @"user_videos", @"user_status", @"user_photos", @"user_friends", @"friends_birthday", @"friends_videos", @"friends_status", @"friends_photos", @"publish_actions", nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSLog(@"total friends: %i",(int)friendData.count);
    
    //set the back button here so that it doesn't show "back"
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStylePlain target:self action:@selector(post)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    filteredResults = [[NSMutableArray alloc] initWithCapacity:friendData.count];

    //multiple ways to hide the search bar, but this was one was the most direct,
    //I originally wanted to show the search bar and then scroll up and hide it, but ios is being a fucktard
    [self.tableView setContentOffset:CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height)];
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
//    self.tableView.contentOffset = CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);
//    [UIView animateWithDuration:0.1
//                          delay:0.5
//                        options:UIViewAnimationOptionTransitionNone
//                     animations:^{ self.tableView.contentOffset = CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height); }
//                     completion:nil];

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
    
    CustomCell *cell = (CustomCell*)[tableView cellForRowAtIndexPath:indexPath]; //warning shouldn't be a problem
    //friendName = cell.nameLabel.text;
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
        controller.totalComments = [NSString stringWithFormat:@"%@", [friendObject objectForKey:@"totalComments"]];
        controller.totalAlbumComments = [NSString stringWithFormat:@"%@", [friendObject objectForKey:@"albumComments"]];
        controller.totalPhotoComments = [NSString stringWithFormat:@"%@", [friendObject objectForKey:@"photoComments"]];
        controller.totalVideoComments = [NSString stringWithFormat:@"%@", [friendObject objectForKey:@"videoComments"]];
        controller.totalStatusComments = [NSString stringWithFormat:@"%@", [friendObject objectForKey:@"statusComments"]];
        controller.profilePictureURL = [friendObject objectForKey:@"profilePictureLarge"];
        controller.profileId = [NSString stringWithFormat:@"%@", [friendObject objectForKey:@"userId"]];
        int total = [[friendObject objectForKey:@"totalLikes"] intValue] + [[friendObject objectForKey:@"totalComments"] intValue];
        controller.rank = [NSString stringWithFormat:@"%@", [friendObject objectForKey:@"rank"]];
        controller.total = [NSString stringWithFormat:@"%d", total];
        
    }
}

//alertView that alerts the user of what they're about to do
- (void)post{
    [[[UIAlertView alloc] initWithTitle:@"Post to Facebook"
                                message:@"This will post the top 10 people to your facebook. Click \"Post\" below to post to your wall!"
                               delegate:self
                      cancelButtonTitle:@"Cancel"
                      otherButtonTitles:@"Post", nil] show];
    
}

- (void)postSuccessful {
    [[[UIAlertView alloc] initWithTitle:@"Posted to Facebook"
                                message:@""
                               delegate:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil] show];
}

- (void)postUnsuccessful {
    [[[UIAlertView alloc] initWithTitle:@"Error posting to Facebook"
                                message:@"Facebook disallows pushing of redundant content"
                               delegate:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil] show];
}

//what happens when the Post button is clicked
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //if the post button was clicked
    if (buttonIndex == 1){
        NSLog(@"post was clicked");
        
        BOOL haveIntegratedFacebookAtAll = ([SLComposeViewController class] != nil);
        BOOL userHaveIntegrataedFacebookAccountSetup = haveIntegratedFacebookAtAll && ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]);
        
        //if the user has integrated facebook set up we will post using it
        if(userHaveIntegrataedFacebookAccountSetup){
            [self integratedFacebookRequest];
        }
        //else if the user doesn't have integrated facebook set up we will post using the other method
        else{
            [self facebookAppRequest];
        }
    }
}

- (void)integratedFacebookRequest{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    NSArray *accounts = [accountStore accountsWithAccountType:accountType];
    ACAccount *account = [accounts lastObject];
    
    //NEED TO ASK FOR PUBLISH PERMISSIONS HERE!!!!!!!!!!
    NSDictionary *options = @{ACFacebookAppIdKey: FACEBOOK_APP_ID_VALUE,
                              ACFacebookPermissionsKey: permissions,
                              ACFacebookAudienceKey:ACFacebookAudienceFriends};
    
    [accountStore requestAccessToAccountsWithType:accountType
                                          options:options
                                       completion:^(BOOL granted, NSError *error){
                                           if (granted){
                                               
                                               // Create the parameters dictionary and the URL (!use HTTPS!)
                                               NSDictionary *parameters = @{@"message" : [self getTopFriends]};
                                               NSURL *URL = [NSURL URLWithString:@"https://graph.facebook.com/me/feed"];
                                               
                                               // Create request
                                               SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                                                                       requestMethod:SLRequestMethodPOST
                                                                                                 URL:URL
                                                                                          parameters:parameters];
                                               
                                               // Since we are performing a method that requires authorization we can simply
                                               // add the ACAccount to the SLRequest
                                               [request setAccount:account];
                                               
                                               // Perform request
                                               [request performRequestWithHandler:^(NSData *respData, NSHTTPURLResponse *urlResp, NSError *error) {
                                                   NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:respData
                                                                                                                      options:kNilOptions
                                                                                                                        error:&error];
                                                   
                                                   // Check for errors in the responseDictionary
                                                   if ([responseDictionary objectForKey:@"id"] != nil) {
                                                       // Status update posted successfully to Facebook
                                                       NSLog(@"Top 10 Friends published");
                                                       
                                                       [self performSelectorOnMainThread:@selector(postSuccessful) withObject:nil waitUntilDone:YES];
                                                   }
                                                   else {
                                                       // An error occurred, we need to handle the error
                                                       // See: https://developers.facebook.com/docs/ios/errors
                                                       NSLog([NSString stringWithFormat:@"%@", [responseDictionary objectForKey:@"error"]]);
                                                       
                                                       [self performSelectorOnMainThread:@selector(postUnsuccessful) withObject:nil waitUntilDone:YES];
                                                   }
                                               }];
                                               
                                           }
                                           else {
                                               NSLog(@"Error accessing account: %@", [error localizedDescription]);
                                           }
                                       }];
}

- (void)facebookAppRequest{
    //if there are no publish permissions then we need to authorize first
    if(![FBSession.activeSession.permissions containsObject:@"publish_actions"]){
        [FBSession.activeSession requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                __block NSString *alertText;
                                                __block NSString *alertTitle;
                                                if (!error) {
                                                    if ([FBSession.activeSession.permissions
                                                         indexOfObject:@"publish_actions"] == NSNotFound){
                                                        // Permission not granted, tell the user we will not publish
                                                        alertTitle = @"Permission not granted";
                                                        alertText = @"Your action will not be published to Facebook.";
                                                        [[[UIAlertView alloc] initWithTitle:alertTitle
                                                                                    message:alertText
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"Ok"
                                                                          otherButtonTitles:nil] show];
                                                    }
                                                    else {
                                                        // Permission granted, publish the OG story
                                                        NSLog(@"permissions granted");
                                                        [self facebookAppShare:[self getTopFriends]];
                                                    }
                                                }
                                                else {
                                                    // There was an error, handle it
                                                    // See https://developers.facebook.com/docs/ios/errors/
                                                    NSLog(@"There was an error with publishing");
                                                }
                                            }];
    }
    else{
        //if we already have publish permissions then go ahead and publish
        [self facebookAppShare:[self getTopFriends]];
    }
}

- (NSString*)getTopFriends{
    
    NSString *topFriends = @"";
    //if there are at least some friends
    if(friendData.count > 0){
        
        topFriends = @"Top 10 Friends:";
        
        int count = 10;
        //if the friendData is smaller than top 10, adjust
        if(friendData.count < count){
            count = (int)friendData.count;
        }
        
        for (int i = 0; i < count; i++) {
            NSMutableDictionary *friend = [[friendData objectAtIndex:i] objectForKey:@"User"];
            NSString *name = [friend objectForKey:@"name"];
            NSString *totalLikes = [friend objectForKey:@"totalLikes"];
            NSString *totalComments = [friend objectForKey:@"totalComments"];
            int index = i + 1;
            topFriends = [NSString stringWithFormat:@"%@\n %i. %@ : [%@ Likes, %@ Comments]", topFriends, index, name, totalLikes, totalComments];
        }
    }
    //if there happens to be no friends
    else{
        [[[UIAlertView alloc] initWithTitle:@"Error posting to Facebook"
                                    message:@"No friends to post"
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
    }
    
    return topFriends;
}

//the actual sharing of content after post button authentication is clicked
- (void)facebookAppShare:(NSString*)topTenFriends{
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
                                                                    message:@"Facebook disallows pushing of redundant content"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil] show];
                                    }
                                }];
}

#pragma mark Content Filtering
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.filteredResults removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"User.name CONTAINS[c] %@", searchText];
    filteredResults = [NSMutableArray arrayWithArray:[friendData filteredArrayUsingPredicate:predicate]];
    //NSLog(@"filteredResults: %@", filteredResults);
    //NSLog(@"filteredResults: %i", filteredResults.count);
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
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
    
    NSString *fullName = [[element objectForKey:@"User"] objectForKey:@"name"];
    int rank = [[[element objectForKey:@"User"] objectForKey:@"totalLikes"] intValue] + [[[element objectForKey:@"User"] objectForKey:@"totalComments"] intValue];
    NSString *rankNumber = [NSString stringWithFormat:@"%d", rank];
    NSString *urlPath = [[element objectForKey:@"User"] objectForKey:@"profilePictureSmall"];
    
    cell.nameLabel.text = fullName;
    cell.rankLabel.text = rankNumber;
    cell.rankLabel.textColor = self.navigationController.navigationBar.tintColor;
    cell.smallImageView.imageURL = [NSURL URLWithString:urlPath];
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
