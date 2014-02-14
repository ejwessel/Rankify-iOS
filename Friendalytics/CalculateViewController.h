//
//  CalculateViewController.h
//  Friendalytics
//
//  Created by Ethan Wessel on 1/18/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendTableViewController.h"
#import "LoginViewController.h"

@interface CalculateViewController : UIViewController <ADBannerViewDelegate>

@property NSString *userId;
@property NSString *accessToken;
@property NSArray *friendData;
@property Boolean pullFriendsFlag;
@property Boolean pullPhotosFlag;
@property Boolean pullAlbumsFlag;
@property Boolean pullVideosFlag;
@property Boolean pullStatusFlag;
@property Boolean retrieveStatusFlag;
@property (strong, nonatomic) IBOutlet UILabel *gatheringFriendsColor;
@property (strong, nonatomic) IBOutlet UILabel *gatheringAlbumsColor;
@property (strong, nonatomic) IBOutlet UILabel *gatheringPhotosColor;
@property (strong, nonatomic) IBOutlet UILabel *gatheringVideosColor;
@property (strong, nonatomic) IBOutlet UILabel *gatheringStatusColor;
@property (strong, nonatomic) IBOutlet UILabel *retrievingDataColor;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *statusFriends;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *statusAlbums;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *statusPhotos;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *statusVideos;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *statusStatus;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *retrievingStatus;
@property (strong, nonatomic) IBOutlet UIButton *continueButton;
@property (strong, nonatomic) IBOutlet UIButton *recomputeButton;
@property ADBannerView *banner;

- (void) requestUsers;

- (void) pullFriends;

- (void) pullPhotos;

- (void) pullAlbums;

- (void) pullVideos;

- (void) pullStatuses;

- (void) getFriendData;

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@end
