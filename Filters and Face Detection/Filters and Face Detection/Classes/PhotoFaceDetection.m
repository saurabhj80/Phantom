//
//  PhotoFaceDetection.m
//  Filters and Face Detection
//
//  Created by Saurabh Jain on 10/8/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

#import "PhotoFaceDetection.h"

@implementation PhotoFaceDetection

+ (void) detectFeaturesInImage:(UIImage *) image withCompletionBlock:(void (^)(NSUInteger count, NSArray* features))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        // Image to be detected
        CIImage *detectImage = [CIImage imageWithCGImage:[image CGImage]];
        
        NSDictionary *options = @{CIDetectorAccuracy : CIDetectorAccuracyHigh};
        
        CIDetector *faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace
                                                      context:nil
                                                      options:options];
        
        // Perform the long running operation
        NSArray *features = [faceDetector featuresInImage:detectImage];

        if (block) {
            block(features.count, features);
        }
    });
}

@end
