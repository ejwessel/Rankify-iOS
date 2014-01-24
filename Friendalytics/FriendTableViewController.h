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

@interface FriendTableViewController : UITableViewController <UIScrollViewDelegate,UISearchBarDelegate, UISearchDisplayDelegate>

@property NSArray *friendData;
@property NSMutableArray *filteredResults; //filtered results of friend data
@property NSString *friendName;
@property NSMutableDictionary *friendObject;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property CustomCell *cellDownload;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSString*) makeFullName:(NSDictionary*) element;

- (void)downloadAndLoadImageWithCell;

@end
