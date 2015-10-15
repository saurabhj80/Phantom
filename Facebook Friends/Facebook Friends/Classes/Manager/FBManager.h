//
//  FBManager.h
//  Facebook Friends
//
//  Created by Saurabh Jain on 10/15/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBManager : NSObject

+ (void) getFriends:(void( ^ _Nullable)(NSArray<id> * _Nullable friends, NSError * _Nullable error)) block;

@end
