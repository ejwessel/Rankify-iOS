//
//  AboutViewController.h
//  Friendalytics
//
//  Created by Ethan Wessel on 1/23/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;
//@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIButton *supportButton;
#define URLEMail @"mailto:support.rankify@e-wit.co.uk?subject=Rankify Support"
@end
