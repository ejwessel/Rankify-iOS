//
//  CalculateViewController.m
//  Friendalytics
//
//  Created by Ethan Wessel on 1/18/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import "CalculateViewController.h"

@interface CalculateViewController ()

@end

@implementation CalculateViewController
@synthesize friendData;
@synthesize userId;
@synthesize accessToken;
@synthesize gatheringFriendsCheck;
@synthesize gatheringAlbumsCheck;
@synthesize gatheringVideosCheck;
@synthesize gatheringStatusesCheck;
@synthesize gatheringPhotosCheck;
@synthesize retrievingDataCheck;
@synthesize statusFriends;
@synthesize statusAlbums;
@synthesize statusPhotos;
@synthesize statusVideos;
@synthesize statusStatus;
@synthesize continueButton;
@synthesize recomputeButton;
@synthesize pullFriendsFlag;
@synthesize pullPhotosFlag;
@synthesize pullAlbumsFlag;
@synthesize pullVideosFlag;
@synthesize pullStatusFlag;
@synthesize retrievingStatus;
@synthesize retrieveStatusFlag;
@synthesize banner;
@synthesize recentlyPulled;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    //ADS
    if(ADS_ACTIVATED){
        banner = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, self.view.frame.size.height)];
        banner.delegate = self;
        banner.AutoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:banner];
        [self hideBanner];
    }
    
    //change back button text
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    continueButton.layer.cornerRadius = 5;
    continueButton.layer.borderWidth = 1;
    continueButton.backgroundColor = [UIColor whiteColor];
    continueButton.layer.borderColor = [UIColor lightGrayColor].CGColor;//self.navigationController.navigationBar.tintColor.CGColor;
    [continueButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    recomputeButton.layer.cornerRadius = 5;
    recomputeButton.layer.borderWidth = 1;
    recomputeButton.backgroundColor = [UIColor whiteColor];
    recomputeButton.layer.borderColor = [UIColor lightGrayColor].CGColor;//self.navigationController.navigationBar.tintColor.CGColor;
    [recomputeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [recomputeButton addTarget:self action:@selector(startCompute) forControlEvents:UIControlEventTouchUpInside];

    statusFriends.hidden = true;
    statusAlbums.hidden = true;
    statusPhotos.hidden = true;
    statusVideos.hidden = true;
    statusStatus.hidden = true;
    retrievingStatus.hidden = true;
    
    if(recentlyPulled){
        [self enableUI];
        [self getFriendData];
    }
    else{
        [self startCompute];
    }
}

- (void) hideBanner{
    [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
    banner.frame = CGRectOffset(banner.frame, 0, 50);
    banner.hidden = YES;
    [UIView commitAnimations];
}

- (void) showBanner{
    [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
    banner.frame = CGRectOffset(banner.frame, 0, -50);
    banner.hidden = NO;
    [UIView commitAnimations];
}

- (void) bannerViewDidLoadAd:(ADBannerView *)bannerAd{
    NSLog(@"Banner Loaded an Ad");
    if(bannerAd.hidden){
        [self showBanner];
    }
}

- (void) bannerView:(ADBannerView *)bannerAd didFailToReceiveAdWithError:(NSError *)error{
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

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) startCompute{
    self.navigationItem.hidesBackButton = true;
    
    gatheringFriendsCheck.hidden = true;
    gatheringAlbumsCheck.hidden = true;
    gatheringVideosCheck.hidden = true;
    gatheringStatusesCheck.hidden = true;
    gatheringPhotosCheck.hidden = true;
    retrievingDataCheck.hidden = true;
    
    continueButton.enabled = false;
    continueButton.backgroundColor = [UIColor clearColor];
    continueButton.layer.borderColor = [UIColor grayColor].CGColor;
    [continueButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    recomputeButton.enabled = false;
    recomputeButton.backgroundColor = [UIColor clearColor];
    recomputeButton.layer.borderColor = [UIColor grayColor].CGColor;
    [recomputeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    pullFriendsFlag = false;
    pullAlbumsFlag = false;
    pullPhotosFlag = false;
    pullVideosFlag = false;
    pullStatusFlag = false;
    
    [statusFriends startAnimating];
    statusFriends.hidden = false;
    [self performSelectorInBackground:@selector(pullFriends) withObject:nil];
}

- (void) getFriendsWithUserID:(NSString *)passedUserId {
    //make url request
    //send url request to israel's database
    NSString *urlString = [NSString stringWithFormat:@"http://leovander.com/friendalytics/users/refreshToken/%@", passedUserId];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"Token and userId sent? %@", responseString);
}

- (void) requestUsers{
    //this function is used primarily for testing
    NSString *urlString = [NSString stringWithFormat:@"http://leovander.com/friendalytics/users"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    
    //obtain the json data
    NSError *err;
    friendData = [NSJSONSerialization JSONObjectWithData:responseData
                                                               options:NSJSONReadingMutableContainers
                                                                 error:&err];
    
    if(!friendData){
        NSLog(@"Error Parsing JSON: %@", err);
    }
    else{
        NSLog(@"Parsing JSON Successful");
        //NSLog(@"JSON: %@", friendData);
    }
}

- (void) enableUI{
    self.navigationItem.hidesBackButton = false;
    
    continueButton.enabled = true;
    continueButton.backgroundColor = self.navigationController.navigationBar.tintColor;
    continueButton.layer.borderColor = self.navigationController.navigationBar.tintColor.CGColor;
    [continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    recomputeButton.enabled = true;
    recomputeButton.backgroundColor = [UIColor whiteColor];
    recomputeButton.layer.borderColor = self.navigationController.navigationBar.tintColor.CGColor;
    [recomputeButton setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
}

- (void) pullFriends{
    
    NSLog(@"pullFriends Started");
    NSString *urlString = [NSString stringWithFormat:@"%@users/pullFriends/%@/%@", SITE_PATH, userId, accessToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    NSMutableDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&requestError];
    NSLog(@"pullFriends status:%@", [jsonData objectForKey:@"status"]);
    
    [statusFriends stopAnimating];
    statusFriends.hidden = true;
    if([[jsonData objectForKey:@"status"] isEqualToString:@"success"]){
        pullFriendsFlag = true;
        UIImage *checkMark = [UIImage imageNamed:@"check.png"];
        gatheringFriendsCheck.image = checkMark;
        gatheringFriendsCheck.hidden = false;
        [statusAlbums startAnimating];
        statusAlbums.hidden = false;
        [self performSelectorInBackground:@selector(pullAlbums) withObject:nil];
    }
    else{
        UIImage *xMark = [UIImage imageNamed:@"x_mark.png"];
        gatheringFriendsCheck.image = xMark;
        gatheringFriendsCheck.hidden = false;
        recomputeButton.enabled = true;
        [self enableUI];
    }
    NSLog(@"pullFriends Finished");
}

- (void) pullAlbums{
    NSLog(@"pullAlbums Started");
    NSString *urlString = [NSString stringWithFormat:@"%@/albums/pullAlbums/%@/%@", SITE_PATH, userId, accessToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    NSMutableDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&requestError];
    NSLog(@"pullAlbums status:%@", [jsonData objectForKey:@"status"]);
    
    [statusAlbums stopAnimating];
    statusAlbums.hidden = true;
    if([[jsonData objectForKey:@"status"] isEqualToString:@"success"]){
        pullAlbumsFlag = true;
        NSLog(@"obtained albumData successfully");
        UIImage *checkMark = [UIImage imageNamed:@"check.png"];
        gatheringAlbumsCheck.image = checkMark;
        gatheringAlbumsCheck.hidden = false;
        [statusVideos startAnimating];
        statusVideos.hidden = false;
        [self performSelectorInBackground:@selector(pullVideos) withObject:nil];
    }
    else{
        NSLog(@"unable to obtain albumData successfully");
        UIImage *xMark = [UIImage imageNamed:@"x_mark.png"];
        gatheringAlbumsCheck.image = xMark;
        gatheringAlbumsCheck.hidden = false;
        recomputeButton.enabled = true;
        [self enableUI];
    }
    NSLog(@"pullAlbums Finished");
}

- (void) pullPhotos{
    
    NSLog(@"pullPhotos Started");
    NSString *urlString = [NSString stringWithFormat:@"%@photos/pullPhotos/%@/%@", SITE_PATH, userId, accessToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    NSMutableDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&requestError];
    NSLog(@"pullPhotos status:%@", [jsonData objectForKey:@"status"]);
    
    [statusPhotos stopAnimating];
    statusPhotos.hidden = true;
    if([[jsonData objectForKey:@"status"] isEqualToString:@"success"]){
        pullPhotosFlag = true;
        NSLog(@"obtained photoData successfully");
        UIImage *checkMark = [UIImage imageNamed:@"check.png"];
        gatheringPhotosCheck.image = checkMark;
        gatheringPhotosCheck.hidden = false;
        [retrievingStatus startAnimating];
        retrievingStatus.hidden = false;
        [self performSelectorInBackground:@selector(getFriendData) withObject:nil];

    }
    else{
        NSLog(@"unable to obtain photo successfully");
        UIImage *xMark = [UIImage imageNamed:@"x_mark.png"];
        gatheringPhotosCheck.image = xMark;
        gatheringPhotosCheck.hidden = false;
        recomputeButton.enabled = true;
        [self enableUI];
    }
    NSLog(@"pullPhotos Finished");
}

- (void) pullVideos{
    NSLog(@"pullVideos Started");
    NSString *urlString = [NSString stringWithFormat:@"%@videos/pullVideos/%@/%@", SITE_PATH, userId, accessToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    NSMutableDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&requestError];
    NSLog(@"pullVideos status:%@", [jsonData objectForKey:@"status"]);
    
    [statusVideos stopAnimating];
    statusVideos.hidden = true;
    if([[jsonData objectForKey:@"status"] isEqualToString:@"success"]){
        pullVideosFlag = true;
        NSLog(@"obtained videoData successfully");
        UIImage *checkMark = [UIImage imageNamed:@"check.png"];
        gatheringVideosCheck.image = checkMark;
        gatheringVideosCheck.hidden = false;
        [statusStatus startAnimating];
        statusStatus.hidden = false;
        [self performSelectorInBackground:@selector(pullStatuses) withObject:nil];
    }
    else{
        NSLog(@"unable to obtain friendData successfully");
        UIImage *xMark = [UIImage imageNamed:@"x_mark.png"];
        gatheringVideosCheck.image = xMark;
        gatheringVideosCheck.hidden = false;
        recomputeButton.enabled = true;
        [self enableUI];
    }
    NSLog(@"pullVideos Finished");
 }

- (void) pullStatuses{
    NSLog(@"pullStatuses Started");
    NSString *urlString = [NSString stringWithFormat:@"%@statuses/pullStatuses/%@/%@", SITE_PATH, userId, accessToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    NSMutableDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&requestError];
    NSLog(@"pullStatuses status:%@", [jsonData objectForKey:@"status"]);
    
    [statusStatus stopAnimating];
    statusStatus.hidden = true;
    if([[jsonData objectForKey:@"status"] isEqualToString:@"success"]){
        pullStatusFlag = true;
        NSLog(@"obtained friendData successfully");
        UIImage *checkMark = [UIImage imageNamed:@"check.png"];
        gatheringStatusesCheck.image = checkMark;
        gatheringStatusesCheck.hidden = false;
        [statusPhotos startAnimating];
        statusPhotos.hidden = false;
        [self performSelectorInBackground:@selector(pullPhotos) withObject:nil];
    }
    else{
        NSLog(@"unable to obtain friendData successfully");
        UIImage *xMark = [UIImage imageNamed:@"x_mark.png"];
        gatheringStatusesCheck.image = xMark;
        gatheringStatusesCheck.hidden = false;
        recomputeButton.enabled = true;
        [self enableUI];
    }
    NSLog(@"pullStatuses Finished");
}

- (void) getFriendData {
    
    NSLog(@"getFriendData Started");
    NSString *urlString = [NSString stringWithFormat:@"%@users/getFriendsData/%@", SITE_PATH, userId];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    
    //obtain the json data
    NSError *err;
    friendData = [NSJSONSerialization JSONObjectWithData:responseData
                                                 options:NSJSONReadingMutableContainers
                                                   error:&err];
    [retrievingStatus stopAnimating];
    retrievingStatus.hidden = true;
    
    //check returned data
    if(friendData != nil){
        retrieveStatusFlag = true;
        NSLog(@"obtained friendData successfully");
        UIImage *checkMark = [UIImage imageNamed:@"check.png"];
        retrievingDataCheck.image = checkMark;
        retrievingDataCheck.hidden = false;
        
        [self enableUI];
    }
    else{
        NSLog(@"unable to obtain friendData successfully");
        UIImage *xMark = [UIImage imageNamed:@"check.png"];
        retrievingDataCheck.image = xMark;
        retrievingDataCheck.hidden = false;
        recomputeButton.enabled = true;
    }
    NSLog(@"getFriendData Finished");
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"segueToFriendList"]){
        FriendTableViewController *controller = (FriendTableViewController *)segue.destinationViewController;
        controller.friendData = nil; //need to clear data before we pass new data
        controller.friendData = friendData;
    }
}

@end
