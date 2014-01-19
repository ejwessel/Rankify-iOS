//
//  ViewController.h
//  Friendalytics
//
//  Created by Ethan Wessel on 1/12/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController : UIViewController

@property NSMutableDictionary *friendList;
@property (strong, nonatomic) IBOutlet FBLoginView *loginView;
@property (strong, nonatomic) IBOutlet UIButton *calculateButton;

- (void) getFriends;
- (void) sendAccessToken:(NSString*)token withUserID:(NSString*)userId;
- (void) requestUsers;
- (void) calculateButtonClicked;
@end
