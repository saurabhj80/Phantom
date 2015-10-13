//
//  PhotoFilter.m
//  Filters and Face Detection
//
//  Created by Saurabh Jain on 10/8/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

#import "PhotoFilter.h"

@implementation PhotoFilter

#pragma mark - Helper Function

+ (void) applyFilter:(CIFilter *)filter toImage:(UIImage *)image withBlock:(void (^)(UIImage * image))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // Create CGImage
        CIImage *inputImage  = [CIImage imageWithCGImage:[image CGImage]];
        
        // Create a context
        CIContext *context = [CIContext contextWithOptions:nil];
        
        // Set the input image to the filter
        [filter setValue:inputImage forKey:kCIInputImageKey];
        
        // Get the resultant image
        CIImage *resultImage = [filter valueForKey:kCIOutputImageKey];
        
        // CGImage from CIImage
        CGImageRef filteredCGImage = [context createCGImage:resultImage fromRect:[resultImage extent]];
        
        // UIImage
        UIImage *filteredImage =  [UIImage imageWithCGImage:filteredCGImage];
        
        if (block) {
            block(filteredImage);
        }
    });
}

@end
