//
//  ViewController.m
//  Friendalytics
//
//  Created by Ethan Wessel on 1/12/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

NSString const *SITE_PATH = @"http://e-wit.co.uk/friendalytics/";
NSString const *FACEBOOK_APP_ID_VALUE = @"1397650163819409"; //this MUST match Friendalytics-Info.plist value for FacebookAppId
BOOL const ADS_ACTIVATED = 1;
BOOL isRetina;

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
@synthesize permissions;
@synthesize integratedLoginLabel;
@synthesize banner;
@synthesize activityIndicator;
@synthesize userHaveIntegrataedFacebookAccountSetup;
@synthesize userLoginPhoto;
@synthesize friendData;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //check if we have retina or non retina screen
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2){
        isRetina = YES;
    } else {
        isRetina = NO;
    }
    
    NSLog(@"is retina: %hhd", isRetina);
    
    //ADS
    if(ADS_ACTIVATED){
        banner = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, self.view.frame.size.height)];
        banner.delegate = self;
        banner.AutoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:banner];
        [self hideBanner];
    }

    userLoginPhoto.image = [UIImage imageNamed:@"rank.png"];
    integratedLoginLabel.hidden = true;
    permissions = [NSArray arrayWithObjects:@"user_birthday", @"user_videos", @"user_status", @"user_photos", @"user_friends", @"friends_birthday", @"friends_videos", @"friends_status", @"friends_photos", nil];
    userHaveIntegrataedFacebookAccountSetup = ([SLComposeViewController class] != nil) && ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]);
    
    //If the user has the integrated facebook account set up
    if(userHaveIntegrataedFacebookAccountSetup){
        NSLog(@"Facebook Integrated Account is set up");
        [self integratedFacebookRequest];
    }
    //If the user doesn't have the integrated facebook account set up
    else{
         NSLog(@"Facebook Integrated Account is not set up");
        [self facebookAppRequest];
     }
    
    
    //Other UI Setup
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

- (void)getUserPhoto{
    NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/%@/?fields=picture.type(large)&access_token=%@", userId, accessToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseData options: NSJSONReadingMutableContainers error: &requestError];
    
    NSString *urlPath = [[[jsonData objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
    //NSLog(@"userId:%@ accessToken:%@ urlPath: %@", userId, accessToken, urlPath);
    NSURL *pictureUrl = [NSURL URLWithString:urlPath];
    NSData *data = [[NSData alloc] initWithContentsOfURL:pictureUrl];
    UIImage *tmpImage = [[UIImage alloc] initWithData:data];
    userLoginPhoto.image = tmpImage;
    userLoginPhoto.hidden = false;
}

- (void)integratedFacebookRequest{
    
    //UI Setup if integrated is set
    integratedLoginLabel.hidden = false;
    integratedLoginLabel.text = @"Logging You In, Please Wait";
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.transform = CGAffineTransformMakeScale(2.5f, 2.5f);
    activityIndicator.hidden = false;
    activityIndicator.center = CGPointMake(self.view.center.x, self.view.center.y * .60);
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    //begin integrated request
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *facebookAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook]; //obtains the integrated account we have stored on the iphone
    NSDictionary *options = @{ACFacebookAppIdKey: FACEBOOK_APP_ID_VALUE,
                              ACFacebookPermissionsKey: permissions,
                              ACFacebookAudienceKey:ACFacebookAudienceFriends};
    
    // Request access to the Facebook account.
    // The user will see an alert view when you perform this method.
    [accountStore requestAccessToAccountsWithType:facebookAccountType
                                          options:options
                                       completion:^(BOOL granted, NSError *error) {
                                           if (granted) {
                                               
                                               NSLog(@"Facebook Successfully granted access");
                                               NSArray *accounts = [accountStore accountsWithAccountType:facebookAccountType];
                                               facebookAccount = [accounts lastObject];
                                               
                                               //need to set userId
                                               accessToken = [[facebookAccount credential] oauthToken];        //this sets the access token
                                               [self setUserInfo]; //this will set the user id
                                           }
                                           else{
                                               //update ui on a login fail
                                               [self performSelectorOnMainThread:@selector(updateUIFail) withObject:nil waitUntilDone:YES];
                                               NSLog(@"Facebook Failed to grant access\n%@", error);
                                           }
                                       }];
}
- (void)facebookAppRequest{
    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:permissions];
    //loginView.publishPermissions = @[@"publish_actions"];
    //loginView.defaultAudience = FBSessionDefaultAudienceFriends;
    loginView.delegate = self;
    loginView.frame = CGRectMake(61, 252, 200, 45);
    [self.view addSubview:loginView];
}

- (void)setUserInfo{
    NSURL *userURL = [NSURL URLWithString:@"https://graph.facebook.com/me"];
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                            requestMethod:SLRequestMethodGET
                                                      URL:userURL
                                               parameters:nil];
    request.account = facebookAccount;
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *response, NSError *error) {
        NSMutableDictionary * jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        
        userId = [jsonData objectForKey:@"id"];
        
        //send login data to the database
        [self sendLoginDataToDatabase:userId with:accessToken];
        
        //update ui only after we have obtained user id inside of database
        [self performSelectorOnMainThread:@selector(updateUISuccess) withObject:nil waitUntilDone:NO];
        NSLog(@"userId: %@", userId);       //this sets the user id
        
        [self performSelectorOnMainThread:@selector(getUserPhoto) withObject:nil waitUntilDone:NO];

    }];
}

- (void)updateUIFail{
    if(userHaveIntegrataedFacebookAccountSetup){
        integratedLoginLabel.text = @"Login Failed";
        [activityIndicator stopAnimating];
    }
}
- (void)updateUISuccess{
    
    if(userHaveIntegrataedFacebookAccountSetup){
        integratedLoginLabel.text = @"Logged In";
    }
    [activityIndicator stopAnimating];
    calculateButton.enabled = true;
    calculateButton.backgroundColor = self.navigationController.navigationBar.tintColor;
    calculateButton.layer.borderColor = self.navigationController.navigationBar.tintColor.CGColor;
    [calculateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = true;
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    //[self updateUISuccess];
    [activityIndicator stopAnimating];
}
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    calculateButton.enabled = false;
    calculateButton.backgroundColor = [UIColor whiteColor];
    calculateButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [calculateButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    userLoginPhoto.image = [UIImage imageNamed:@"rank.png"];; //show our logo instead
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
    
    //UI Setup if integrated is set
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.transform = CGAffineTransformMakeScale(2.5f, 2.5f);
    activityIndicator.hidden = false;
    activityIndicator.center = CGPointMake(self.view.center.x, self.view.center.y * .60);
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    [FBRequestConnection startWithGraphPath:@"me/?fields=id"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  //send the access token and user id if successfully logged in.
                                  userId = [result objectForKey:@"id"];
                                  FBAccessTokenData *token = [[FBSession activeSession] accessTokenData];
                                  accessToken = (NSString*)token;
                                  [self sendAccessToken:accessToken withUserID:userId];
                                  [self performSelectorOnMainThread:@selector(getUserPhoto) withObject:nil waitUntilDone:NO];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendAccessToken:(NSString *)token withUserID:(NSString *)idNumber {
    //make url request
    //send url request to database
    NSString *urlString = [NSString stringWithFormat:@"%@users/login/%@/%@", SITE_PATH, idNumber, token];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    NSMutableDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&requestError];
    
    if([[jsonData objectForKey:@"status"] isEqualToString:@"success"]){
        [self performSelectorOnMainThread:@selector(updateUISuccess) withObject:nil waitUntilDone:NO];
        NSLog(@"database login successful integrated");
    }
}
- (void)sendLoginDataToDatabase:(NSString*)userIDNumber with:(NSString*)accessID{
        
    NSString *urlString = [NSString stringWithFormat:@"%@users/login/%@/%@", SITE_PATH, userIDNumber, accessID];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
   NSMutableDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&requestError];
    
    if([[jsonData objectForKey:@"status"] isEqualToString:@"success"]){
        [self performSelectorOnMainThread:@selector(updateUISuccess) withObject:nil waitUntilDone:NO];
        NSLog(@"database login successful");
    }
    else{
        NSLog(@"database did not receive login info");
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"segueToCompute"]){
        CalculateViewController *controller = (CalculateViewController *)segue.destinationViewController;
        //pass data to the next view controller
        controller.userId = userId;
        controller.accessToken = accessToken;
        
        NSLog(@"getFriendData Started");
        NSString *urlString = [NSString stringWithFormat:@"%@users/doesFriendDataExist/%@", SITE_PATH, userId];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
        NSURLResponse *response = NULL;
        NSError *requestError = NULL;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
        //obtain the json data
        NSMutableDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&requestError];

        NSLog(@"json Data %@", jsonData);
        
        NSLog(@"hasFriends: %hhd", [[jsonData objectForKey:@"hasFriends"] boolValue]);
        controller.recentlyPulled = [[jsonData objectForKey:@"hasFriends"] boolValue];
    }
}

@end
