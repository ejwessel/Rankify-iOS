//
//  CustomCell.m
//  Friendalytics
//
//  Created by Ethan Wessel on 1/20/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell
@synthesize arrayIndex;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
