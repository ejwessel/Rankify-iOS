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
@property (strong, nonatomic) IBOutlet UILabel *gatheringFriendsColor;
@property (strong, nonatomic) IBOutlet UILabel *gatheringAlbumsColor;
@property (strong, nonatomic) IBOutlet UILabel *gatheringPhotosColor;
@property (strong, nonatomic) IBOutlet UILabel *gatheringVideosColor;
@property (strong, nonatomic) IBOutlet UILabel *gatheringStatusColor;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *statusFriends;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *statusAlbums;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *statusPhotos;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *statusVideos;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *statusStatus;
- (void) requestUsers;

- (void) addNewFriends;

- (void) getFriends;

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@end
