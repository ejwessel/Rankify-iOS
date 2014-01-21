//
//  SpecificsViewController.m
//  Friendalytics
//
//  Created by Ethan Wessel on 1/19/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import "SpecificsViewController.h"

@interface SpecificsViewController ()

@end

@implementation SpecificsViewController
@synthesize totalLikesLabel;
@synthesize totalAlbumLikesLabel;
@synthesize totalPhotoLikesLabel;
@synthesize totalVideoLikesLabel;
@synthesize totalStatusLikesLabel;
@synthesize friendName;
@synthesize totalLikes;
@synthesize totalAlbumLikes;
@synthesize totalPhotoLikes;
@synthesize totalVideoLikes;
@synthesize totalStatusLikes;
@synthesize profilePictureURL;
@synthesize profilePicture;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.title = friendName;
    totalLikesLabel.text = totalLikes;
    totalStatusLikesLabel.text = totalStatusLikes;
    totalVideoLikesLabel.text = totalVideoLikes;
    totalPhotoLikesLabel.text = totalPhotoLikes;
    totalAlbumLikesLabel.text = totalAlbumLikes;
    profilePicture.layer.cornerRadius = 10;
    profilePicture.layer.borderWidth = .5;
    
    //load the profile picture in the background to prevent blocking main thread
    [self performSelectorInBackground:@selector(downloadAndLoadImage) withObject:nil];
    //[NSThread detachNewThreadSelector:@selector(downloadAndLoadImage) toTarget:self withObject:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:totalLikes style:UIBarButtonItemStyleDone target:self action:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)downloadAndLoadImage{
    NSURL *url = [NSURL URLWithString:profilePictureURL];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    UIImage *tmpImage = [[UIImage alloc] initWithData:data];
    profilePicture.image = tmpImage;
    profilePicture.layer.cornerRadius = 10;
    profilePicture.layer.masksToBounds = YES;
}

@end
