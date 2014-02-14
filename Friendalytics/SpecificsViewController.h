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

- (void)downloadAndLoadImage;

- (void)visitFBButtonPressed;

@end
