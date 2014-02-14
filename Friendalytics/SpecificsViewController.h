//
//  SpecificsViewController.h
//  Friendalytics
//
//  Created by Ethan Wessel on 1/19/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "LoginViewController.h"

@interface SpecificsViewController : UIViewController <ADBannerViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *totalLikesLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalAlbumLikesLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalPhotoLikesLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalVideoLikesLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalStatusLikesLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalCommentsLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalAlbumCommentsLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalPhotoCommentsLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalVideoCommentsLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalStatusCommentsLabel;
@property (strong, nonatomic) IBOutlet UILabel *rankLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) IBOutlet UILabel *rankHeader;
@property (strong, nonatomic) IBOutlet UILabel *totalHeader;
@property (strong, nonatomic) IBOutlet UILabel *likesHeader;
@property (strong, nonatomic) IBOutlet UILabel *commentsHeader;

@property ADBannerView *banner;


@property NSString *friendName;
@property NSString *totalLikes;
@property NSString *totalAlbumLikes;
@property NSString *totalPhotoLikes;
@property NSString *totalVideoLikes;
@property NSString *totalStatusLikes;
@property NSString *profilePictureURL;
@property NSString *profileId;
@property NSString *totalComments;
@property NSString *totalAlbumComments;
@property NSString *totalPhotoComments;
@property NSString *totalVideoComments;
@property NSString *totalStatusComments;
@property NSString *rank;
@property NSString *total;

- (void)downloadAndLoadImage;

- (void)visitFBButtonPressed;

@end
