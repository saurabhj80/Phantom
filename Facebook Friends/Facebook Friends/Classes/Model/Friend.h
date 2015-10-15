//
//  Friend.h
//  Facebook Friends
//
//  Created by Saurabh Jain on 10/15/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Friend : NSObject

- (instancetype) initWithData:(NSDictionary *)data;

@property (strong, nonatomic) NSString * fbid;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSURL* pictureURL;

@end
