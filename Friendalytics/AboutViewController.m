//
//  AboutViewController.m
//  Friendalytics
//
//  Created by Ethan Wessel on 1/23/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController
@synthesize versionLabel;
@synthesize supportButton;
//@synthesize removeAdsButton;
//@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//- (void)viewWillAppear:(BOOL)animated{
////    if(!ADS_ACTIVATED){
////        [removeAdsButton setTitle:@"Premium Version" forState:UIControlStateNormal];
////        removeAdsButton.enabled = false;
////        //removeAdsButton.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:250.0/255.0 blue:0 alpha:1.0]; //gold color for premium?
////        removeAdsButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
////    }
//}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [info objectForKey:@"CFBundleShortVersionString"];
    version = [NSString stringWithFormat:@"Version %@", version];
    versionLabel.text = version;
    
    supportButton.layer.borderWidth = 1;
    supportButton.layer.cornerRadius = 5;
    supportButton.layer.borderColor = self.navigationController.navigationBar.tintColor.CGColor;
    [supportButton addTarget:self action:@selector(messageButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
//    removeAdsButton.layer.borderWidth = 1;
//    removeAdsButton.layer.cornerRadius = 5;
//    removeAdsButton.layer.borderColor = self.navigationController.navigationBar.tintColor.CGColor;
//    [removeAdsButton addTarget:self action:@selector(removeAdsButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)messageButtonClicked{
    NSLog(@"Message Button is clicked");
    NSString *url = [URLEMail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)removeAdsButtonClicked{
    SKProductsRequest *request= [[SKProductsRequest alloc]
                                 initWithProductIdentifiers: [NSSet setWithObject: @"RankifyRemoveAds"]];
    request.delegate = self;
    [request start];
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"Transaction Completed");
    // You can create a method to record the transaction.
    // [self recordTransaction: transaction];
    
    // You should make the update to your app based on what was purchased and inform user.
    // [self provideContent: transaction.payment.productIdentifier];
    
    // Finally, remove the transaction from the payment queue.

//    [removeAdsButton setTitle:@"Premium Version" forState:UIControlStateNormal];
//    removeAdsButton.enabled = false;
//    removeAdsButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    ADS_ACTIVATED = 0; //turn off ads for rest of app
    [[[UIAlertView alloc] initWithTitle:@"Ads Removed" message:@"Thank you" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
- (void) restoreTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"Transaction Restored");
    // You can create a method to record the transaction.
    // [self recordTransaction: transaction];
    
    // You should make the update to your app based on what was purchased and inform user.
    // [self provideContent: transaction.payment.productIdentifier];
    
    // Finally, remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
- (void) failedTransaction: (SKPaymentTransaction *)transaction{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // Display an error here.
        [[[UIAlertView alloc] initWithTitle:@"Purchase Unsuccessful"
                                    message:@"Your purchase failed. Please try again."
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    
    // Finally, remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    NSArray *myProduct = response.products;
    NSLog(@"%@",[[myProduct objectAtIndex:0] productIdentifier]);
    
    //Since only one product, we do not need to choose from the array. Proceed directly to payment.
    
    SKPayment *newPayment = [SKPayment paymentWithProduct:[myProduct objectAtIndex:0]];
    [[SKPaymentQueue defaultQueue] addPayment:newPayment];
 
}
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}
@end
