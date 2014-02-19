//
//  ViewController.h
//  Friendalytics
//
//  Created by Ethan Wessel on 1/12/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import <iAd/iAd.h>
#import "CalculateViewController.h"

extern NSString const *SITE_PATH;
extern NSString const *FACEBOOK_APP_ID_VALUE;
extern BOOL const ADS_ACTIVATED;
extern BOOL isRetina;

@interface LoginViewController : UIViewController <ADBannerViewDelegate>

@property NSMutableDictionary *friendList;
@property NSString *userId;
@property NSString *accessToken;
@property (strong, nonatomic) IBOutlet UIButton *calculateButton;
@property (strong, nonatomic) IBOutlet UIButton *aboutButton;
@property ACAccount *facebookAccount;
@property NSArray *permissions;
@property (strong, nonatomic) IBOutlet UILabel *integratedLoginLabel;
@property ADBannerView *banner;
@property UIActivityIndicatorView *activityIndicator;
@property BOOL userHaveIntegrataedFacebookAccountSetup;
@property (strong, nonatomic) IBOutlet UIImageView *userLoginPhoto;
@property NSArray *friendData;

- (void) sendAccessToken:(NSString*)token withUserID:(NSString*)userId;
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;


@end
