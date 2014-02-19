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
@synthesize webView;

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
//    self.navigationController.navigationBarHidden = false;
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [info objectForKey:@"CFBundleShortVersionString"];
    version = [NSString stringWithFormat:@"Version %@", version];
    versionLabel.text = version;
    
    NSString *myHtml = [NSString stringWithFormat:
                        @"<html><head>"
                        "<style type=\"text/css\">"
                        "body{"
                        "font-family: Helvetica;"
                        "font-size: 20px;"
                        "a {color: #FFF;}"
                        "},</style>"
                        "</head><body>Hi<a href='%@'>Link text</a></body></html>", @"https://github.com/nicklockwood/AsyncImageView"];
    
    [webView loadHTMLString:myHtml baseURL:nil];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
