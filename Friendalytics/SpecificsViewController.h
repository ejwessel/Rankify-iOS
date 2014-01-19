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
@property (strong, nonatomic) IBOutlet UILabel *friendNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalLikesLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalAlbumLikesLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalPhotoLikesLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalVideoLikesLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalStatusLikesLabel;

@property NSString *friendName;
@property int totalLikes;
@property int totalAlbumLikes;
@property int totalPhotoLikes;
@property int totalVideoLikes;
@property int totalStatusLikes;

@end
