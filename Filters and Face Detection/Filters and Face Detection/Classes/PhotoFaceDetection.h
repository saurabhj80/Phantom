//
//  PhotoFaceDetection.h
//  Filters and Face Detection
//
//  Created by Saurabh Jain on 10/8/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface PhotoFaceDetection : NSObject

+ (void) detectFeaturesInImage:(UIImage *) image withCompletionBlock:(void (^)(NSUInteger count, NSArray* features))block;

@end
