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
@synthesize photoData;
@synthesize albumData;
@synthesize videoData;
@synthesize statusData;
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
@synthesize retryButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    continueButton.layer.borderWidth = 1;
    continueButton.layer.cornerRadius = 5;
    continueButton.layer.borderColor = self.navigationController.navigationBar.tintColor.CGColor;
    
    gatheringFriendsColor.backgroundColor = [UIColor yellowColor];
    gatheringFriendsColor.layer.cornerRadius = 10;
    gatheringFriendsColor.layer.borderWidth = .5;
    
    gatheringAlbumsColor.backgroundColor = [UIColor yellowColor];
    gatheringAlbumsColor.layer.cornerRadius = 10;
    gatheringAlbumsColor.layer.borderWidth = .5;
    
    gatheringPhotosColor.backgroundColor = [UIColor yellowColor];
    gatheringPhotosColor.layer.cornerRadius = 10;
    gatheringPhotosColor.layer.borderWidth = .5;
    
    gatheringVideosColor.backgroundColor = [UIColor yellowColor];
    gatheringVideosColor.layer.cornerRadius = 10;
    gatheringVideosColor.layer.borderWidth = .5;
    
    gatheringStatusColor.backgroundColor = [UIColor yellowColor];
    gatheringStatusColor.layer.cornerRadius = 10;
    gatheringStatusColor.layer.borderWidth = .5;
    
    continueButton.layer.cornerRadius = 5;
    continueButton.layer.borderWidth = 1;
    continueButton.layer.borderColor = self.navigationController.navigationBar.tintColor.CGColor;
    
    retryButton.layer.cornerRadius = 5;
    retryButton.layer.borderWidth = 1;
    retryButton.layer.borderColor = self.navigationController.navigationBar.tintColor.CGColor;
    
    [self startGatheringData];
    [retryButton addTarget:self action:@selector(startGatheringData) forControlEvents:UIControlEventTouchUpInside];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(allDataReady)
//                                                 name:nil
//                                               object:nil];
}

- (void)didReceiveMemoryWarning {
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

- (void) requestUsers {
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

- (void) startGatheringData{
    
    continueButton.hidden = true;
    
    self.statusFriends.hidden = false;
    self.statusAlbums.hidden = false;
    self.statusPhotos.hidden = false;
    self.statusVideos.hidden = false;
    self.statusStatus.hidden = false;
    
    [self.statusFriends startAnimating];
    [self.statusAlbums startAnimating];
    [self.statusPhotos startAnimating];
    [self.statusVideos startAnimating];
    [self.statusStatus startAnimating];
    
    [self performSelectorInBackground:@selector(pullFriends) withObject:nil];
    [self performSelectorInBackground:@selector(pullPhotos) withObject:nil];
    [self performSelectorInBackground:@selector(pullAlbums) withObject:nil];
    [self performSelectorInBackground:@selector(pullVideos) withObject:nil];
    [self performSelectorInBackground:@selector(pullStatuses) withObject:nil];
}

- (void) pullFriends{
    NSString *urlString = [NSString stringWithFormat:@"http://leovander.com/friendalytics/users/pullFriends/%@/%@", userId, accessToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"pullFriends: %@", responseString);

    NSLog(@"obtained friends successfully");
    [statusFriends stopAnimating];
    statusFriends.hidden = true;
    gatheringFriendsColor.backgroundColor = [UIColor greenColor];
    
    //still need to make a check if pulling friends was successful
    
}

- (void) pullPhotos{
    NSString *urlString = [NSString stringWithFormat:@"http://leovander.com/friendalytics/photos/pullPhotos/%@/%@", userId, accessToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    
    //obtain the json data
    NSError *err;
    photoData = [NSJSONSerialization JSONObjectWithData:responseData
                                                 options:NSJSONReadingMutableContainers
                                                   error:&err];
    
    if(photoData != nil){
        NSLog(@"obtained photoData successfully");
        [statusPhotos stopAnimating];
        statusPhotos.hidden = true;
        gatheringPhotosColor.backgroundColor = [UIColor greenColor];
    }
    else{
        NSLog(@"unable to obtain photo successfully");
        [statusPhotos stopAnimating];
        statusPhotos.hidden = true;
        gatheringPhotosColor.backgroundColor = [UIColor redColor];
    }

    //NSLog(@"photoData: %@", photoData);
}

- (void) pullAlbums{
    NSString *urlString = [NSString stringWithFormat:@"http://leovander.com/friendalytics/albums/pullAlbums/%@/%@", userId, accessToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    
    //obtain the json data
    NSError *err;
    albumData = [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers
                                                  error:&err];
    if(albumData != nil){
        NSLog(@"obtained albumData successfully");
        [statusAlbums stopAnimating];
        statusAlbums.hidden = true;
        gatheringAlbumsColor.backgroundColor = [UIColor greenColor];
    }
    else{
        NSLog(@"unable to obtain albumData successfully");
        [statusPhotos stopAnimating];
        statusAlbums.hidden = true;
        gatheringAlbumsColor.backgroundColor = [UIColor redColor];
    }
    
    //NSLog(@"albumData: %@", albumData);
}

- (void) pullVideos{
    NSString *urlString = [NSString stringWithFormat:@"http://leovander.com/friendalytics/videos/pullVideos/%@/%@", userId, accessToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    
    //obtain the json data
    NSError *err;
    videoData = [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers
                                                  error:&err];
    
    if(videoData != nil){
        NSLog(@"obtained videoData successfully");
        [statusVideos stopAnimating];
        statusVideos.hidden = true;
        gatheringVideosColor.backgroundColor = [UIColor greenColor];
    }
    else{
        NSLog(@"unable to obtain friendData successfully");
        [statusVideos stopAnimating];
        statusVideos.hidden = true;
        gatheringVideosColor.backgroundColor = [UIColor redColor];
    }
    
    //NSLog(@"videoData: %@", videoData);
}

- (void) pullStatuses{
    NSString *urlString = [NSString stringWithFormat:@"http://leovander.com/friendalytics/photos/pullPhotos/%@/%@", userId, accessToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    
    //obtain the json data
    NSError *err;
    statusData = [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers
                                                  error:&err];
   
    if(statusData != nil){
        NSLog(@"obtained friendData successfully");
        [statusStatus stopAnimating];
        statusStatus.hidden = true;
        gatheringStatusColor.backgroundColor = [UIColor greenColor];
    }
    else{
        NSLog(@"unable to obtain friendData successfully");
        [statusStatus stopAnimating];
        statusStatus.hidden = true;
        gatheringStatusColor.backgroundColor = [UIColor redColor];
    }
    
    //NSLog(@"statusData: %@", statusData);
}

- (void) getFriendData {
    NSString *urlString = [NSString stringWithFormat:@"http://leovander.com/friendalytics/users/getFriendData/%@", userId];
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
    
    if(friendData != nil){
        NSLog(@"obtained friendData successfully");
        [statusFriends stopAnimating];
        statusFriends.hidden = true;
        gatheringFriendsColor.backgroundColor = [UIColor greenColor];
    }
    else{
        NSLog(@"unable to obtain friendData successfully");
        [statusFriends stopAnimating];
        statusFriends.hidden = true;
        gatheringFriendsColor.backgroundColor = [UIColor redColor];
    }
    
    //NSLog(@"friendData: %@", friendData);
}

- (void) allDataReady{
//    if(friendData != nil
//       && photoData != nil
//       && albumData != nil
//       && videoData != nil
//       && statusData != nil){
//        NSLog(@"ALL ARE READY!");
//        [[NSNotificationCenter defaultCenter] removeObserver:self];
//        [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:YES];
//    }
//    else{
//        NSLog(@"at least one failed keep waiting");
//    }
    
    if(friendData != nil){
        NSLog(@"friendData IS READY!");
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:YES];
    }
    else{
        NSLog(@"friendData not ready");
    }
}

- (void) updateUI{
    continueButton.hidden = false;
    retryButton.hidden = true;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"segueToFriendList"]){
        FriendTableViewController *controller = (FriendTableViewController *)segue.destinationViewController;
        controller.friendData = friendData;
    }
}

@end
