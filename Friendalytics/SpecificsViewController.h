//
//  SpecificsViewController.h
//  Friendalytics
//
//  Created by Ethan Wessel on 1/19/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecificsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *totalLikesLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalAlbumLikesLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalPhotoLikesLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalVideoLikesLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalStatusLikesLabel;
@property (strong, nonatomic) IBOutlet UIButton *fbButton;

@property NSString *friendName;
@property NSString *totalLikes;
@property NSString *totalAlbumLikes;
@property NSString *totalPhotoLikes;
@property NSString *totalVideoLikes;
@property NSString *totalStatusLikes;
@property NSString *profilePictureURL;
@property NSString *profileId;

- (void)downloadAndLoadImage;

- (void)visitFBButtonPressed;

@end
