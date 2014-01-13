//
//  FriendData.m
//  Friendalytics
//
//  Created by Israel Torres on 1/13/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import "FriendData.h"

@implementation FriendData

@synthesize userId;
@synthesize firstName;
@synthesize lastName;

@synthesize albumLikes;
@synthesize eventLikes;
@synthesize photoLikes;

- (id) initWithDefault {
    self = [super init];
    
    userId = 0;
    firstName = @"";
    lastName = @"";
    
    albumLikes = 0;
    eventLikes = 0;
    photoLikes = 0;
    
    return self;
}

- (int) totalLikes {
    return albumLikes + eventLikes + photoLikes;
}

@end