//
//  CustomCell.h
//  Friendalytics
//
//  Created by Ethan Wessel on 1/20/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property int arrayIndex;

@end
