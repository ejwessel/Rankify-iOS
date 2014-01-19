//
//  CalculateViewController.h
//  Friendalytics
//
//  Created by Ethan Wessel on 1/18/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendTableViewController.h"

@interface CalculateViewController : UIViewController

@property NSString *userId;
@property NSString *accessToken;
@property NSArray *friendData;

- (void) requestUsers;

- (void) getFriends;

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
@end
