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
    
    [self.statusFriends startAnimating];
    [self.statusAlbums startAnimating];
    [self.statusPhotos startAnimating];
    [self.statusVideos startAnimating];
    [self.statusStatus startAnimating];
    
    [self performSelectorInBackground:@selector(getFriends) withObject:nil];
    [self performSelectorInBackground:@selector(getPhotos) withObject:nil];
    [self performSelectorInBackground:@selector(getAlbums) withObject:nil];
    [self performSelectorInBackground:@selector(getVideos) withObject:nil];
    [self performSelectorInBackground:@selector(getStatuses) withObject:nil];
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

- (void) addNewFriends{
    NSString *urlString = [NSString stringWithFormat:@"http://leovander.com/friendalytics/users/newFriends/%@/%@", userId, accessToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"addNewFriends: %@", responseString);
}

- (void) getFriends {
    NSString *urlString = [NSString stringWithFormat:@"http://leovander.com/friendalytics/users/getFriends/%@", userId];
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
        [statusFriends stopAnimating];
        statusFriends.hidden = true;
        gatheringFriendsColor.backgroundColor = [UIColor greenColor];
    }
    else{
        [statusFriends stopAnimating];
        statusFriends.hidden = true;
        gatheringFriendsColor.backgroundColor = [UIColor redColor];
    }
    
    NSLog(@"friendData: %@", friendData);
}

- (void) getPhotos{
    NSString *urlString = [NSString stringWithFormat:@"http://leovander.com/friendalytics/photos/getPhotos/%@/%@", userId, accessToken];
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
        [statusPhotos stopAnimating];
        statusPhotos.hidden = true;
        gatheringPhotosColor.backgroundColor = [UIColor greenColor];
    }
    else{
        [statusPhotos stopAnimating];
        statusPhotos.hidden = true;
        gatheringPhotosColor.backgroundColor = [UIColor redColor];
    }

    NSLog(@"photoData: %@", photoData);
}

- (void) getAlbums{
    NSString *urlString = [NSString stringWithFormat:@"http://leovander.com/friendalytics/albums/getAlbums/%@/%@", userId, accessToken];
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
        [statusAlbums stopAnimating];
        statusAlbums.hidden = true;
        gatheringAlbumsColor.backgroundColor = [UIColor greenColor];
    }
    else{
        [statusPhotos stopAnimating];
        statusAlbums.hidden = true;
        gatheringAlbumsColor.backgroundColor = [UIColor redColor];
    }
    
    NSLog(@"albumData: %@", albumData);
}

- (void) getVideos{
    NSString *urlString = [NSString stringWithFormat:@"http://leovander.com/friendalytics/videos/getVideos/%@/%@", userId, accessToken];
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
        [statusVideos stopAnimating];
        statusVideos.hidden = true;
        gatheringVideosColor.backgroundColor = [UIColor greenColor];
    }
    else{
        [statusVideos stopAnimating];
        statusVideos.hidden = true;
        gatheringVideosColor.backgroundColor = [UIColor redColor];
    }
    
    NSLog(@"videoData: %@", videoData);
}

- (void) getStatuses{
    NSString *urlString = [NSString stringWithFormat:@"http://leovander.com/friendalytics/photos/getPhotos/%@/%@", userId, accessToken];
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
        [statusStatus stopAnimating];
        statusStatus.hidden = true;
        gatheringStatusColor.backgroundColor = [UIColor greenColor];
    }
    else{
        [statusStatus stopAnimating];
        statusStatus.hidden = true;
        gatheringStatusColor.backgroundColor = [UIColor redColor];
    }
    
    NSLog(@"statusData: %@", statusData);
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"segueToFriendList"]){
        FriendTableViewController *controller = (FriendTableViewController *)segue.destinationViewController;
        controller.friendData = friendData;
    }
}

@end
