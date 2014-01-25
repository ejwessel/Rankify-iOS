//
//  ViewController.h
//  Friendalytics
//
//  Created by Ethan Wessel on 1/12/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "CalculateViewController.h"

@interface LoginViewController : UIViewController

@property NSMutableDictionary *friendList;
@property (strong, nonatomic) FBLoginView *loginView;
@property NSString *userId;
@property NSString *accessToken;
@property (strong, nonatomic) IBOutlet UIButton *calculateButton;
@property (strong, nonatomic) IBOutlet UIButton *aboutButton;

- (void) sendAccessToken:(NSString*)token withUserID:(NSString*)userId;

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@end
