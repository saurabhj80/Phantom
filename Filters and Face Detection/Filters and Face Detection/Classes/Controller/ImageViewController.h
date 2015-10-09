//
//  ImageViewController.h
//  Filters and Face Detection
//
//  Created by Saurabh Jain on 10/8/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController

@property (weak, nonatomic) CIFilter* filter;
@property (weak, nonatomic) UIImage* image;
@property (strong, nonatomic) NSArray* features;

@end
