//
//  ImageViewController.m
//  Filters and Face Detection
//
//  Created by Saurabh Jain on 10/8/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

#import "ImageViewController.h"
#import "PhotoFilter.h"
#import "UIImage+Resize.h"

@interface ImageViewController ()

@property (strong, nonatomic) UIImageView *imgView;

@end

@implementation ImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.filter.name;

    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 100, self.image.size.width, self.image.size.height)];
    [self.view addSubview:self.imgView];
    
    // If we have features, then display the features
    if (self.features) {
       self.title = @"Face Detection";
        self.imgView.image = self.image;
        [self displayFeatures:self.features withImage:self.image];
    }
    
    else {  // Apply the photo filter
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [PhotoFilter applyFilter:self.filter toImage:self.image withBlock:^(UIImage *image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.imgView.image = image;
                });
            }];
        });
    }
}

- (void) displayFeatures:(NSArray *) features withImage:(UIImage *)facePicture
{
    
    // Enumerate the features
    [features enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

        // If we have a face feature
        if([obj isKindOfClass:[CIFaceFeature class]]){

            CIFaceFeature * faceObject = obj;
            
            CGRect modifiedFaceBounds = faceObject.bounds;
            modifiedFaceBounds.origin.y = facePicture.size.height-faceObject.bounds.size.height-faceObject.bounds.origin.y;
            
            [self addSubViewWithFrame:modifiedFaceBounds];
            
//            if(faceObject.hasLeftEyePosition)
//            {
//                
//                CGRect leftEye = CGRectMake(faceObject.leftEyePosition.x,(facePicture.size.height-faceObject.leftEyePosition.y), 10, 10);
//                [self addSubViewWithFrame:leftEye];
//            }
//            
//            if(faceObject.hasRightEyePosition)
//            {
//                
//                CGRect rightEye = CGRectMake(faceObject.rightEyePosition.x, (facePicture.size.height-faceObject.rightEyePosition.y), 10, 10);
//                [self addSubViewWithFrame:rightEye];
//                
//            }
//            if(faceObject.hasMouthPosition)
//            {
//                CGRect  mouth = CGRectMake(faceObject.mouthPosition.x,facePicture.size.height-faceObject.mouthPosition.y,10, 10);
//                [self addSubViewWithFrame:mouth];
//            }
        }
    }];
}

-(void)addSubViewWithFrame:(CGRect)frame
{
    UIView* highlitView = [[UIView alloc] initWithFrame:frame];
    highlitView.layer.borderWidth = 2;
    highlitView.layer.borderColor = [[UIColor redColor] CGColor];
    [self.imgView addSubview:highlitView];
}



@end
