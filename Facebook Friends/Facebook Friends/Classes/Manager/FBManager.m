//
//  FBManager.m
//  Facebook Friends
//
//  Created by Saurabh Jain on 10/15/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

#import "FBManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@implementation FBManager

+ (void) getFriends:(void(^ _Nullable)( NSArray<id> * _Nullable friends,  NSError* _Nullable error)) block
{
    FBSDKGraphRequest* req = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/me/taggable_friends?limit=10000" parameters:@{@"fields": @"id, name, picture"}];
    
    // if have access to friends
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"user_friends"]) {
        [req startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (block) {
                if (result) {
                    block(result[@"data"], nil);
                } else if (error) {
                    block(nil, error);
                }
            }
        }];
    } else {    // we do not have permission
        NSError* error = [NSError errorWithDomain:@"FBError" code:1 userInfo:@{@"Description": @"We do not have access to user_friends"}];
        block(nil, error);
    }

}

@end
