//
//  PhotoFilter.m
//  Filters and Face Detection
//
//  Created by Saurabh Jain on 10/8/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

#import "PhotoFilter.h"

@implementation PhotoFilter

+ (void) applyFilter:(CIFilter *)filter toImage:(UIImage *)image withBlock:(void (^)(UIImage * image))block
{
    CIImage* img = image.CIImage;

    CIContext* context = [CIContext contextWithOptions:nil];
    [filter setValue:img forKey:kCIInputImageKey];
    CIImage* output = [filter outputImage];
    CGImageRef cgimg = [context createCGImage:output fromRect:[output extent]];
    UIImage* filteredImage = [UIImage imageWithCGImage:cgimg];
    
    if (block) {
        block(filteredImage);
    }
}

@end
