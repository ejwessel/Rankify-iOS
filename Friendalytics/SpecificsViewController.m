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
@synthesize friendNameLabel;
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
    
    friendNameLabel.text = friendName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
