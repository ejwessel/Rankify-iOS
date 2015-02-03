//
//  AboutViewController.h
//  Friendalytics
//
//  Created by Ethan Wessel on 1/23/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "LoginViewController.h"

@interface AboutViewController : UIViewController <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;
//@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIButton *supportButton;
//@property (strong, nonatomic) IBOutlet UIButton *removeAdsButton;
#define URLEMail @"mailto:ejwessel@gmail.com?subject=Rankify Support"

@end
