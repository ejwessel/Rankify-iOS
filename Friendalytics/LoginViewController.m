//
//  ViewController.m
//  Friendalytics
//
//  Created by Ethan Wessel on 1/12/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController () <FBLoginViewDelegate>

@end

@implementation LoginViewController

@synthesize friendList;
@synthesize loginView;
@synthesize userId;
@synthesize accessToken;
@synthesize calculateButton;

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSArray *permissions = @[@"user_birthday",
                             @"user_videos",
                             @"user_status",
                             @"user_photos",
                             @"user_friends",
                             @"friends_birthday",
                             @"friends_videos",
                             @"friends_status",
                             @"friends_photos",
                             @"read_stream",
                             @"export_stream"];
    
    loginView = [[FBLoginView alloc] initWithReadPermissions:permissions];
    loginView.delegate = self;
    calculateButton.enabled = false;
    calculateButton.layer.borderWidth = 1.0;
    calculateButton.layer.cornerRadius = 5;
    calculateButton.layer.borderColor = calculateButton.titleLabel.textColor.CGColor;
    
//    loginView.frame = CGRectOffset(loginView.frame, 5, 5);
//#ifdef __IPHONE_7_0
//#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
//    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
//        loginView.frame = CGRectOffset(loginView.frame, 5, 25);
//    }
//#endif
//#endif
//#endif
//    [self.view addSubview:loginView];
//    [loginView sizeToFit];
    
}

- (void) loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
//    // here we use helper properties of FBGraphUser to dot-through to first_name and
//    // id properties of the json response from the server; alternatively we could use
//    // NSDictionary methods such as objectForKey to get values from the my json object
//    self.labelFirstName.text = [NSString stringWithFormat:@"Hello %@!", user.first_name];
//    // setting the profileID property of the FBProfilePictureView instance
//    // causes the control to fetch and display the profile picture for the user
//    self.profilePic.profileID = user.id;
//    self.loggedInUser = user;
    
    [FBRequestConnection startWithGraphPath:@"me/?fields=id"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  //send the access token and user id if successfully logged in.
                                  userId = [result objectForKey:@"id"];
                                  FBAccessTokenData *token = [[FBSession activeSession] accessTokenData];
                                  accessToken = (NSString*)token;
                                  [self sendAccessToken:accessToken withUserID:userId];
                                  calculateButton.enabled = true;
                                  calculateButton.layer.borderColor = calculateButton.titleLabel.textColor.CGColor;
                              } else {
                                  // An error occurred, we need to handle the error
                                  // See: https://developers.facebook.com/docs/ios/errors
                                  NSLog(@"data not retrieved");
                              }
                          }];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void) getFriends {
//    [FBRequestConnection startWithGraphPath:@"me/?fields=friends"
//                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//                              if (!error) {
//                                  //NSLog(@"%@", result);
//                                  
//                                  NSArray *friendArray = [[result objectForKey:@"friends"] objectForKey:@"data"];
//                                  //NSLog(@"%@", friendArray);
//                                  
//                                  for (NSDictionary *friend in friendArray ){
//                                      NSString *user_id = [friend objectForKey:@"id"];
//                                      //FriendData *friendObject = [[FriendData alloc] initWithDefault];
//                                      [friendList setObject:[[FriendData alloc] initWithDefault] forKey:user_id];
//                                      
//                                  }
//                                  
//                                  
//                                  NSLog(@"%@", friendList);
//                                  
//                                  NSLog(@"%i", [[friendList objectForKey:(@"100000054880541")] totalLikes]);
//                              } else {
//                                  NSLog(@"%@", error);
//                              }
//                          }];
//}

- (void) sendAccessToken:(NSString *)token withUserID:(NSString *)userId {
    //make url request
    //send url request to israel's database
    NSString *urlString = [NSString stringWithFormat:@"http://leovander.com/friendalytics/users/refreshToken/%@/%@", userId, token];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"Token and userId sent? %@", responseString);
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"segueToCompute"]){
        CalculateViewController *controller = (CalculateViewController *)segue.destinationViewController;
        //pass data to the next view controller
        controller.userId = userId;
        controller.accessToken = accessToken;
    }
}

@end
