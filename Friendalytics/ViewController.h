//
//  ViewController.h
//  Friendalytics
//
//  Created by Ethan Wessel on 1/12/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property NSMutableDictionary *friendList;

- (void) getFriends;
- (void) sendAccessToken:(NSString*)token withUserID:(NSString*)userId;

@end
