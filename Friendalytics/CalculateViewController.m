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
@synthesize gatheringFriendsColor;
@synthesize gatheringAlbumsColor;
@synthesize gatheringPhotosColor;
@synthesize gatheringVideosColor;
@synthesize gatheringStatusColor;
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
@synthesize retrievingDataColor;
@synthesize retrievingStatus;
@synthesize retrieveStatusFlag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    continueButton.layer.borderWidth = 1;
    continueButton.layer.cornerRadius = 5;
    continueButton.layer.borderColor = self.navigationController.navigationBar.tintColor.CGColor;
    
    gatheringFriendsColor.backgroundColor = [UIColor grayColor];
    gatheringFriendsColor.layer.cornerRadius = 10;
    gatheringFriendsColor.layer.borderWidth = .5;
    
    gatheringAlbumsColor.backgroundColor = [UIColor grayColor];
    gatheringAlbumsColor.layer.cornerRadius = 10;
    gatheringAlbumsColor.layer.borderWidth = .5;
    
    gatheringPhotosColor.backgroundColor = [UIColor grayColor];
    gatheringPhotosColor.layer.cornerRadius = 10;
    gatheringPhotosColor.layer.borderWidth = .5;
    
    gatheringVideosColor.backgroundColor = [UIColor grayColor];
    gatheringVideosColor.layer.cornerRadius = 10;
    gatheringVideosColor.layer.borderWidth = .5;
    
    gatheringStatusColor.backgroundColor = [UIColor grayColor];
    gatheringStatusColor.layer.cornerRadius = 10;
    gatheringStatusColor.layer.borderWidth = .5;
    
    retrievingDataColor.backgroundColor = [UIColor grayColor];
    retrievingDataColor.layer.cornerRadius = 10;
    retrievingDataColor.layer.borderWidth = .5;
    
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
    

    continueButton.enabled = false;
    recomputeButton.enabled = false;
    
    self.statusAlbums.hidden = true;
    self.statusPhotos.hidden = true;
    self.statusVideos.hidden = true;
    self.statusStatus.hidden = true;
    self.retrievingStatus.hidden = true;
    
    pullFriendsFlag = false;
    pullAlbumsFlag = false;
    pullPhotosFlag = false;
    pullVideosFlag = false;
    pullStatusFlag = false;
    
    //==========================================================================
    
    [statusFriends startAnimating];
    statusFriends.hidden = false;
    gatheringFriendsColor.backgroundColor = [UIColor yellowColor];
    [self performSelectorInBackground:@selector(pullFriends) withObject:nil];
//    [self startPhase1];
    [recomputeButton addTarget:self action:@selector(viewDidLoad) forControlEvents:UIControlEventTouchUpInside];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allDataReady) name:@"allDataReadyNotification" object:nil];

}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void) enabledRecomputeColor{
    recomputeButton.backgroundColor = [UIColor whiteColor];
    recomputeButton.layer.borderColor = self.navigationController.navigationBar.tintColor.CGColor;
    [recomputeButton setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
}

- (void) pullFriends{
    
    NSLog(@"pullFriends Started");
    NSString *urlString = [NSString stringWithFormat:@"%@users/pullFriends/%@/%@", sitePath, userId, accessToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    //NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
  
    //NSLog(@"responseString:%@", responseString);
    
    [statusFriends stopAnimating];
    statusFriends.hidden = true;
    if(responseData != nil){
        pullFriendsFlag = true;
        gatheringFriendsColor.backgroundColor = [UIColor greenColor];
        gatheringAlbumsColor.backgroundColor = [UIColor yellowColor];
        [statusAlbums startAnimating];
        statusAlbums.hidden = false;
        [self performSelectorInBackground:@selector(pullAlbums) withObject:nil];
    }
    else{
        gatheringFriendsColor.backgroundColor = [UIColor redColor];
        recomputeButton.enabled = true;
        [self enabledRecomputeColor];
    }
    NSLog(@"pullFriends Finished");
}

- (void) pullAlbums{
    NSLog(@"pullAlbums Started");
    NSString *urlString = [NSString stringWithFormat:@"%@/albums/pullAlbums/%@/%@", sitePath, userId, accessToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    
    [statusAlbums stopAnimating];
    statusAlbums.hidden = true;
    if(responseData != nil){
        pullAlbumsFlag = true;
        NSLog(@"obtained albumData successfully");
        gatheringAlbumsColor.backgroundColor = [UIColor greenColor];
        gatheringPhotosColor.backgroundColor = [UIColor yellowColor];
        [statusPhotos startAnimating];
        statusPhotos.hidden = false;
        [self performSelectorInBackground:@selector(pullPhotos) withObject:nil];
    }
    else{
        NSLog(@"unable to obtain albumData successfully");
        gatheringAlbumsColor.backgroundColor = [UIColor redColor];
        recomputeButton.enabled = true;
        [self enabledRecomputeColor];
    }
    NSLog(@"pullAlbums Finished");
}

- (void) pullPhotos{
    
    NSLog(@"pullPhotos Started");
    NSString *urlString = [NSString stringWithFormat:@"%@photos/pullPhotos/%@/%@", sitePath, userId, accessToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    
    [statusPhotos stopAnimating];
    statusPhotos.hidden = true;
    if(responseData != nil){
        pullPhotosFlag = true;
        NSLog(@"obtained photoData successfully");
        gatheringPhotosColor.backgroundColor = [UIColor greenColor];
        gatheringVideosColor.backgroundColor = [UIColor yellowColor];
        [statusVideos startAnimating];
        statusVideos.hidden = false;
        [self performSelectorInBackground:@selector(pullVideos) withObject:nil];
    }
    else{
        NSLog(@"unable to obtain photo successfully");
        gatheringPhotosColor.backgroundColor = [UIColor redColor];
        recomputeButton.enabled = true;
        [self enabledRecomputeColor];
    }
    NSLog(@"pullPhotos Finished");
}

- (void) pullVideos{
    NSLog(@"pullVideos Started");
    NSString *urlString = [NSString stringWithFormat:@"%@videos/pullVideos/%@/%@", sitePath, userId, accessToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    
    [statusVideos stopAnimating];
    statusVideos.hidden = true;
    if(responseData != nil){
        pullVideosFlag = true;
        NSLog(@"obtained videoData successfully");
        gatheringVideosColor.backgroundColor = [UIColor greenColor];
        gatheringStatusColor.backgroundColor = [UIColor yellowColor];
        [statusStatus startAnimating];
        statusStatus.hidden = false;
        [self performSelectorInBackground:@selector(pullStatuses) withObject:nil];
    }
    else{
        NSLog(@"unable to obtain friendData successfully");
        gatheringVideosColor.backgroundColor = [UIColor redColor];
        recomputeButton.enabled = true;
        [self enabledRecomputeColor];
    }
    NSLog(@"pullVideos Finished");
 }

- (void) pullStatuses{
    NSLog(@"pullStatuses Started");
    NSString *urlString = [NSString stringWithFormat:@"%@statuses/pullStatuses/%@/%@", sitePath, userId, accessToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    
    [statusStatus stopAnimating];
    statusStatus.hidden = true;
    if(responseData != nil){
        pullStatusFlag = true;
        NSLog(@"obtained friendData successfully");
        gatheringStatusColor.backgroundColor = [UIColor greenColor];
        retrievingDataColor.backgroundColor = [UIColor yellowColor];
        [retrievingStatus startAnimating];
        retrievingStatus.hidden = false;
        [self performSelectorInBackground:@selector(getFriendData) withObject:nil];
    }
    else{
        NSLog(@"unable to obtain friendData successfully");
        gatheringStatusColor.backgroundColor = [UIColor redColor];
        recomputeButton.enabled = true;
        [self enabledRecomputeColor];
    }
    NSLog(@"pullStatuses Finished");
}

- (void) getFriendData {
    
    NSLog(@"getFriendData Started");
    NSString *urlString = [NSString stringWithFormat:@"%@users/getFriendsData/%@", sitePath, userId];
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
    [retrievingStatus stopAnimating];
    retrievingStatus.hidden = true;
    
    //check returned data
    if(friendData != nil){
        retrieveStatusFlag = true;
        NSLog(@"obtained friendData successfully");
        retrievingDataColor.backgroundColor = [UIColor greenColor];
        
        continueButton.enabled = true;
        continueButton.backgroundColor = self.navigationController.navigationBar.tintColor;
        continueButton.layer.borderColor = self.navigationController.navigationBar.tintColor.CGColor;
        [continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        recomputeButton.enabled = true;
        [self enabledRecomputeColor];
    }
    else{
        NSLog(@"unable to obtain friendData successfully");
        retrievingDataColor.backgroundColor = [UIColor redColor];
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
