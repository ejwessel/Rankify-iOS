//
//  ViewController.m
//  Friendalytics
//
//  Created by Ethan Wessel on 1/12/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

//@"http://e-wit.co.uk/rankify/";
NSString const *SITE_PATH = @"http://ewit.me/rankify/";
NSString const *FACEBOOK_APP_ID_VALUE = @"1397650163819409"; //this MUST match Friendalytics-Info.plist value for FacebookAppId
NSString const *RANKIFY_WEBSITE = @"http://e-wit.co.uk/rankifyapp/index.php";
BOOL ADS_ACTIVATED = 1;
double const TIMEOUT = 180.0;

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
@synthesize receiptStoreString;

//- (void)viewWillAppear:(BOOL)animated{
//    //hides ad banner, this is mainly after coming back from the about viewController
//    if(!ADS_ACTIVATED){
//        [self hideBanner];
//    }
//}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //Is screen retina?
    NSLog(@"Retina: %i",([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2) ? 1 : 0);
   
    if(ADS_ACTIVATED){
        banner = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, self.view.frame.size.height)];
        banner.delegate = self;
        banner.AutoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:banner];
        [self hideBanner];
    }
    
    receiptStoreString = @"https://buy.itunes.apple.com/verifyReceipt";//@"https://sandbox.itunes.apple.com/verifyReceipt"; //
    [self getUserReceipt];  //gather whether user has already bought 'remove ads'
    
    userLoginPhoto.image = [UIImage imageNamed:@"rank.png"];
    integratedLoginLabel.hidden = true;
    permissions = [NSArray arrayWithObjects: @"user_videos", @"user_status", @"user_photos", @"user_friends", nil];
    //@"user_birthday", @"friends_birthday", @"friends_videos", @"friends_status", @"friends_photos",
    
    userHaveIntegrataedFacebookAccountSetup = ([SLComposeViewController class] != nil) && ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]);
    if(userHaveIntegrataedFacebookAccountSetup){
        NSLog(@"Facebook Integrated Account is set up");
        [self integratedFacebookRequest];
    }
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
    calculateButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    aboutButton.layer.borderWidth = 1.0;
    aboutButton.layer.cornerRadius = 5;
    aboutButton.layer.borderColor = self.navigationController.navigationBar.tintColor.CGColor;
}

- (void)getUserReceipt{
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
    if (!receipt) {
        NSLog(@"no local receipt data available");
    }
    //if a receipt exists
    else{
        // Create the JSON object that describes the request
        NSError *error;
        NSDictionary *requestContents = @{@"receipt-data": [receipt base64EncodedStringWithOptions:0]};
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                              options:0
                                                                error:&error];
        if (!requestData) {
            NSLog(@"no request data");
        }
        else{
            // Create a POST request with the receipt data.
            NSURL *storeURL = [NSURL URLWithString: receiptStoreString];
            NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
            [storeRequest setHTTPMethod:@"POST"];
            [storeRequest setHTTPBody:requestData];
            
            // Make a connection to the iTunes Store on a background queue.
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            [NSURLConnection sendAsynchronousRequest:storeRequest
                                               queue:queue
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                       if (connectionError) {
                                           NSLog(@"There was a connection error while verifying receipt");
                                       }
                                       else {
                                           NSError *error;
                                           NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                           if (!jsonResponse) {
                                               NSLog(@"Error with jsonResponse while verifying receipt");
                                           }
                                           else{
//                                               NSLog(@"jsonResponse: %@", jsonResponse);
                                               //we first need to check if the array is empty, if it is then there is no in app data
                                               if([[[jsonResponse objectForKey:@"receipt"] objectForKey:@"in_app"] count] != 0){
                                                   NSString *productId = [[[[jsonResponse objectForKey:@"receipt"] objectForKey:@"in_app"] objectAtIndex:0] objectForKey:@"product_id"];
                                                   if([productId isEqualToString:@"RankifyRemoveAds"]){
                                                       NSLog(@"iAd has been disabled");
                                                       ADS_ACTIVATED = 0; //turn off ads for the rest of the app
                                                       [self hideBanner]; //hide the banner on the login page
                                                   }
                                               }
                                               else{
                                                   NSLog(@"jsonResponse.receipt.in_app is empty, user has not bought remove ads");
                                                   //this means we do nothing
                                               }
                                           }
                                       }
                                   }];
        }
    }
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
            NSLog(@"Error Code %li, Server Failure", (long)[error code]);
            [self hideBanner];
            break;
        case 2:
            NSLog(@"Error Code %li, Loading Throttled", (long)[error code]);
            break;
        case 3:
            NSLog(@"Error Code %li, Inventory Unavailable", (long)[error code]);
            [self hideBanner];
            break;
        case 4:
            NSLog(@"Error Code %li, Configuration Error", (long)[error code]);
            break;
        case 5:
            NSLog(@"Error Code %li, Banner Visible Without Content", (long)[error code]);
            [self hideBanner];
            break;
        case 6:
            NSLog(@"Error Code %li, Application Inactive", (long)[error code]);
            break;
        case 7:
            NSLog(@"Error Code %li, Ad Unloaded", (long)[error code]);
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
                                               NSLog(@"Facebook Failed to grant access\n%@", error);
                                               if(error == nil){
                                                   [self performSelectorOnMainThread:@selector(updateUIFail) withObject:nil waitUntilDone:YES];
                                               }
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
        [[[UIAlertView alloc] initWithTitle:@"User Permissions Disabled"
                                    message:@"Enable Permissions by going to Settings > Facebook > Rankify and then restarting Rankify"
                                   delegate:self
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
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

//- (void)viewDidAppear:(BOOL)animated{
////    self.navigationController.navigationBarHidden = true;
//}

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
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:TIMEOUT];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    NSMutableDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&requestError];
    
    if([[jsonData objectForKey:@"status"] isEqualToString:@"success"]){
        [self performSelectorOnMainThread:@selector(updateUISuccess) withObject:nil waitUntilDone:NO];
        NSLog(@"database login successful");
    }
}
- (void)sendLoginDataToDatabase:(NSString*)userIDNumber with:(NSString*)accessID{
        
    NSString *urlString = [NSString stringWithFormat:@"%@users/login/%@/%@", SITE_PATH, userIDNumber, accessID];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:TIMEOUT];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
   NSMutableDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&requestError];
    
    if([[jsonData objectForKey:@"status"] isEqualToString:@"success"]){
        [self performSelectorOnMainThread:@selector(updateUISuccess) withObject:nil waitUntilDone:NO];
        NSLog(@"database login successful integrated"); //integrated
    }
    else{
        [[[UIAlertView alloc] initWithTitle:@"Rankify Database Error"
                                    message:@"Rankify database failed to receive access data."
                                   delegate:self
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
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
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:TIMEOUT];
        NSURLResponse *response = NULL;
        NSError *requestError = NULL;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
        //obtain the json data
        NSMutableDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&requestError];

        NSLog(@"json Data %@", jsonData);
        
        NSLog(@"hasFriends: %d", [[jsonData objectForKey:@"hasFriends"] boolValue]);
        controller.recentlyPulled = [[jsonData objectForKey:@"hasFriends"] boolValue];
    }
}

@end
