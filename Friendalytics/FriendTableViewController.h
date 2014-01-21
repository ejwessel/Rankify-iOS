//
//  FriendTableViewController.h
//  Friendalytics
//
//  Created by Ethan Wessel on 1/18/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecificsViewController.h"
#import "CustomCell.h"

@interface FriendTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property NSArray *friendData;
@property NSString *friendName;
@property NSMutableDictionary *friendObject;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSMutableArray *filteredResults;

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)downloadAndLoadImageWithCell:(CustomCell*)cell withURL:(NSString*)url;

@end
