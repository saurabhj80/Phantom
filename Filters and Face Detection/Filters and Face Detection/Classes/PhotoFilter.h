//
//  PhotoFilter.h
//  Filters and Face Detection
//
//  Created by Saurabh Jain on 10/8/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>
#import <UIKit/UIKit.h>

@interface PhotoFilter : NSObject

+ (void) applyFilter:(CIFilter *)filter toImage:(UIImage *)image withBlock:(void (^)(UIImage * image))block;

@end
