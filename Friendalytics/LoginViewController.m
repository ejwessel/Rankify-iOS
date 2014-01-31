//
//  ViewController.m
//  Friendalytics
//
//  Created by Ethan Wessel on 1/12/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

NSString const *sitePath = @"http://e-wit.co.uk/friendalytics/";
NSString const *facebookAppIdValue = @"1397650163819409"; //this MUST match Friendalytics-Info.plist value for FacebookAppId
//leovander.com
//e-wit.co.uk

@interface LoginViewController () <FBLoginViewDelegate>
@end

@implementation LoginViewController

@synthesize friendList;
@synthesize userId;
@synthesize accessToken;
@synthesize calculateButton;
@synthesize aboutButton;
@synthesize facebookAccount;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSArray *permissions = @[@"user_birthday", @"user_videos", @"user_status", @"user_photos", @"user_friends", @"friends_birthday", @"friends_videos", @"friends_status", @"friends_photos"];
    
    BOOL haveIntegratedFacebookAtAll = ([SLComposeViewController class] != nil);
    BOOL userHaveIntegrataedFacebookAccountSetup = haveIntegratedFacebookAtAll && ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]);
    
    //If the user has the integrated facebook account set up
    if(userHaveIntegrataedFacebookAccountSetup){
        NSLog(@"Integrated Account is set up");
        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        ACAccountType *facebookAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
        
        NSDictionary *options = @{ACFacebookAppIdKey: facebookAppIdValue,
                                  ACFacebookPermissionsKey: permissions,
                                  ACFacebookAudienceKey:ACFacebookAudienceFriends};
        
        // Request access to the Facebook account.
        // The user will see an alert view when you perform this method.
        [accountStore requestAccessToAccountsWithType:facebookAccountType
                                              options:options
                                           completion:^(BOOL granted, NSError *error) {
                                                    if (granted) {
                                                        NSArray *accounts = [accountStore accountsWithAccountType:facebookAccountType];
                                                        facebookAccount = [accounts lastObject];
                                                        
                                                        //need to set userId
                                                        accessToken = [[facebookAccount credential] oauthToken];        //this sets the access token
                                                        [self getUserInfo]; //this will set the user id
                                                        [self enableComputeButton];
                                                    }
                                                    else{
                                                        NSLog(@"Failed to grant access\n%@", error);
                                                    }
                                            }];
    }
    //If the user doesn't have the integrated facebook account set up
    else{
         NSLog(@"Integrated Account is not set up");
        FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:permissions];
        //loginView.publishPermissions = @[@"publish_actions"];
        //loginView.defaultAudience = FBSessionDefaultAudienceFriends;
        loginView.delegate = self;
        loginView.frame = CGRectMake(0,0, 280, 100);
        loginView.frame = CGRectOffset(loginView.frame,
                                       (self.view.center.x - (loginView.frame.size.width / 2)),
                                       (self.view.center.y - (loginView.frame.size.height / 2)));
        [self.view addSubview:loginView];
    }
    
    
    UIColor *navColor = self.navigationController.navigationBar.tintColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: navColor};
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    calculateButton.enabled = false;
    calculateButton.layer.borderWidth = 1.0;
    calculateButton.layer.cornerRadius = 5;
    calculateButton.layer.borderColor = [UIColor lightGrayColor].CGColor;//self.navigationController.navigationBar.tintColor.CGColor;

    aboutButton.layer.borderWidth = 1.0;
    aboutButton.layer.cornerRadius = 5;
    aboutButton.layer.borderColor = self.navigationController.navigationBar.tintColor.CGColor;
    
//#ifdef __IPHONE_7_0
//#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
//    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
//        loginView.frame = CGRectOffset(loginView.frame, 5, 25);
//    }
//#endif
//#endif
//#endif
}

- (void) getUserInfo{
    NSURL *userURL = [NSURL URLWithString:@"https://graph.facebook.com/me"];
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                              requestMethod:SLRequestMethodGET
                                                        URL:userURL
                                                 parameters:nil];
    request.account = facebookAccount;
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *response, NSError *error) {
        NSMutableDictionary * jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        userId = [jsonData objectForKey:@"id"];
        NSLog(@"userId: %@", userId);       //this sets the user id
    }];
}

- (void)enableComputeButton{
    calculateButton.enabled = true;
    calculateButton.backgroundColor = self.navigationController.navigationBar.tintColor;
    calculateButton.layer.borderColor = self.navigationController.navigationBar.tintColor.CGColor;
    [calculateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = true;
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    [self enableComputeButton];
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    calculateButton.enabled = false;
    calculateButton.backgroundColor = [UIColor whiteColor];
    calculateButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [calculateButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
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
                              } else {
                                  // An error occurred, we need to handle the error
                                  // See: https://developers.facebook.com/docs/ios/errors
                                  NSLog(@"data not retrieved");
                              }
                          }];
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    // see https://developers.facebook.com/docs/reference/api/errors/ for general guidance on error handling for Facebook API
    // our policy here is to let the login view handle errors, but to log the results
    NSLog(@"FBLoginView encountered an error=%@", error);
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) sendAccessToken:(NSString *)token withUserID:(NSString *)idNumber {
    //make url request
    //send url request to israel's database
    NSString *urlString = [NSString stringWithFormat:@"%@users/login/%@/%@", sitePath, idNumber, token];
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
