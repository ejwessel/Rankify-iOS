//
//  FriendTableViewController.h
//  Friendalytics
//
//  Created by Ethan Wessel on 1/18/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecificsViewController.h"

@interface FriendTableViewController : UITableViewController

@property NSArray *friendData;
@property NSString *friendName;
@property NSMutableDictionary *friendObject;

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
