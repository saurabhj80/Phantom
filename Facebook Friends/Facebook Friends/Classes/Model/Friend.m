//
//  Friend.m
//  Facebook Friends
//
//  Created by Saurabh Jain on 10/15/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

#import "Friend.h"

@implementation Friend

- (instancetype) initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        self.fbid = data[@"id"];
        self.name = data[@"name"];
        self.pictureURL = [NSURL URLWithString:data[@"picture"][@"data"][@"url"]];
    }
    return self;
}

@end
