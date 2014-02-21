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
//@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
    
//    NSString *myHtml = [NSString stringWithFormat:
//                        @"<html><head>"
//                        "<style type=\"text/css\">"
//                        "body{"
//                        "font-family: Helvetica;"
//                        "font-size: 20px;"
//                        "a {color: #FFF;}"
//                        "},</style>"
//                        "</head><body>Hi<a href='%@'>Link text</a></body></html>", @"https://github.com/nicklockwood/AsyncImageView"];
//    
//    [webView loadHTMLString:myHtml baseURL:nil];
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

@end
