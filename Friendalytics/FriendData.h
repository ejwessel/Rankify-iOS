//
//  FriendData.h
//  Friendalytics
//
//  Created by Israel Torres on 1/13/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendData : NSObject

@property int userId;
@property NSString *firstName;
@property NSString *lastName;

@property int albumLikes;
@property int eventLikes;
@property int photoLikes;

- (id) initWithDefault;
- (int) totalLikes;

@end