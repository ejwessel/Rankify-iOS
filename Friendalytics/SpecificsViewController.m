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
@synthesize profileId;
@synthesize totalCommentsLabel;
@synthesize totalAlbumCommentsLabel;
@synthesize totalPhotoCommentsLabel;
@synthesize totalVideoCommentsLabel;
@synthesize totalStatusCommentsLabel;
@synthesize totalComments;
@synthesize totalAlbumComments;
@synthesize totalPhotoComments;
@synthesize totalVideoComments;
@synthesize totalStatusComments;
@synthesize rank;
@synthesize total;
@synthesize rankLabel;
@synthesize totalLabel;
@synthesize rankHeader;
@synthesize totalHeader;
@synthesize likesHeader;
@synthesize commentsHeader;
@synthesize banner;

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

    if(ADS_ACTIVATED){
        banner = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, self.view.frame.size.height)];
        //banner.backgroundColor = [UIColor redColor];
        banner.layer.borderWidth = .5;
        banner.delegate = self;
        banner.AutoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:banner];
        [self hideBanner];
    }
    
    self.title = friendName;
    
    NSMutableArray *colorOptions =[[NSMutableArray alloc] init];
    UIColor *blue, *red, *green, *orange;
    
    blue = [UIColor colorWithRed:(0/255.f) green:(121/255.f) blue:(225/255.f) alpha:1.0f];
    red = [UIColor colorWithRed:(255/255.f) green:(0/255.f) blue:(0/255.f) alpha:1.0f];
    green = [UIColor colorWithRed:(0/255.f) green:(255/255.f) blue:(0/255.f) alpha:1.0f];
    orange = [UIColor colorWithRed:(255/255.f) green:(154/255.f) blue:(0/255.f) alpha:1.0f];
    
    [colorOptions addObject:blue];
    [colorOptions addObject:red];
    [colorOptions addObject:green];
    [colorOptions addObject:orange];
    
    NSUInteger randomIndex = arc4random() % [colorOptions count];
    
    totalLikesLabel.text = totalLikes;
    totalStatusLikesLabel.text = totalStatusLikes;
    totalVideoLikesLabel.text = totalVideoLikes;
    totalPhotoLikesLabel.text = totalPhotoLikes;
    totalAlbumLikesLabel.text = totalAlbumLikes;
    totalCommentsLabel.text = totalComments;
    totalAlbumCommentsLabel.text = totalAlbumComments;
    totalPhotoCommentsLabel.text = totalPhotoComments;
    totalVideoCommentsLabel.text = totalVideoComments;
    totalStatusCommentsLabel.text = totalStatusComments;
    rankLabel.text = rank;
    totalLabel.text = total;
    rankHeader.textColor = [colorOptions objectAtIndex:randomIndex];
    totalHeader.textColor = [colorOptions objectAtIndex:randomIndex];
    likesHeader.textColor = [colorOptions objectAtIndex:randomIndex];
    commentsHeader.textColor = [colorOptions objectAtIndex:randomIndex];
    profilePicture.layer.cornerRadius = 10;
    
    //load the profile picture in the background to prevent blocking main thread
    [self performSelectorInBackground:@selector(downloadAndLoadImage) withObject:nil];
    
    UIImage *fbImage = [UIImage imageNamed:@"fb_Image_bar.png"];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:rank style:UIBarButtonItemStyleDone target:self action:nil];
    //======================
    UIBarButtonItem *facebookIconButton = [[UIBarButtonItem alloc] initWithImage:fbImage style:UIBarButtonItemStyleDone target:self action:@selector(visitFBButtonPressed)];
    self.navigationItem.rightBarButtonItem = facebookIconButton;
    
}

- (void)hideBanner{
    [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
    banner.frame = CGRectOffset(banner.frame, 0, 50);
    banner.hidden = YES;
    [UIView commitAnimations];
}

- (void)showBanner{
    [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
    banner.frame = CGRectOffset(banner.frame, 0, -50);
    banner.hidden = NO;
    [UIView commitAnimations];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)bannerAd{
    NSLog(@"Banner Loaded an Ad");
    if(bannerAd.hidden){
        [self showBanner];
    }
}

- (void)bannerView:(ADBannerView *)bannerAd didFailToReceiveAdWithError:(NSError *)error{
    NSLog(@"Banner Failed");
    switch ([error code]) {
        case 1:
            NSLog(@"Error Code %i, Server Failure", [error code]);
            [self hideBanner];
            break;
        case 2:
            NSLog(@"Error Code %i, Loading Throttled", [error code]);
            break;
        case 3:
            NSLog(@"Error Code %i, Inventory Unavailable", [error code]);
            [self hideBanner];
            break;
        case 4:
            NSLog(@"Error Code %i, Configuration Error", [error code]);
            break;
        case 5:
            NSLog(@"Error Code %i, Banner Visible Without Content", [error code]);
            [self hideBanner];
            break;
        case 6:
            NSLog(@"Error Code %i, Application Inactive", [error code]);
            break;
        case 7:
            NSLog(@"Error Code %i, Ad Unloaded", [error code]);
            [self hideBanner];
            break;
        default:
            break;
    }
}

- (void)visitFBButtonPressed{
    NSLog(@"visit FB Button pressed");
    BOOL isInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]];
    
    if (isInstalled) {
        NSString *urlString = [NSString stringWithFormat:@"fb://profile/%@", profileId];
        NSURL *theURL = [NSURL URLWithString:urlString];
        [[UIApplication sharedApplication] openURL:theURL];
    } else {
        NSString *urlString = [NSString stringWithFormat:@"https://www.facebook.com/%@", profileId];
        NSURL *url = [NSURL URLWithString:urlString];
        NSLog(@"%@", profileId);
        if (![[UIApplication sharedApplication] openURL:url])
            NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
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
