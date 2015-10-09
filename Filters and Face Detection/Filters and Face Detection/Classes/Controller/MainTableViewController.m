//
//  MainTableViewController.m
//  Background Tasks
//
//  Created by Saurabh Jain on 9/29/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

#import "MainTableViewController.h"
#import "ImageViewController.h"
#import "UIImage+Resize.h"
#import "PhotoFaceDetection.h"

@interface MainTableViewController ()

@property (strong, nonatomic) NSArray<NSString *>* links;
@property (strong, nonatomic) NSMutableArray<UIImage *>* images;
@property (strong, nonatomic) NSArray<CIFilter *>* filters;
@property (strong, nonatomic) NSMutableArray<NSArray *>* faceFeatures;

@property (nonatomic) BOOL isDownloading;

@end

@implementation MainTableViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
        
    self.links = @[@"https://upload.wikimedia.org/wikipedia/commons/d/d8/NASA_Mars_Rover.jpg",
                   @"http://www.wired.com/wp-content/uploads/images_blogs/wiredscience/2012/08/Mars-in-95-Rover1.jpg",
                   @"http://news.brown.edu/files/article_images/MarsRover1.jpg",
                   @"http://www.nasa.gov/images/content/482643main_msl20100916-full.jpg",
                   @"https://upload.wikimedia.org/wikipedia/commons/f/fa/Martian_rover_Curiosity_using_ChemCam_Msl20111115_PIA14760_MSL_PIcture-3-br2.jpg",
                   @"http://mars.nasa.gov/msl/images/msl20110602_PIA14175.jpg",
                   @"http://i.kinja-img.com/gawker-media/image/upload/iftylroaoeej16deefkn.jpg",
                   @"http://www.nasa.gov/sites/default/files/thumbnails/image/journey_to_mars.jpeg",
                   @"http://www.cheneywadentist.com/wp-content/uploads/2012/01/family-2.jpg",
                   @"http://www.peoplebeforepolitics.org/images/people_photo_high_res.jpeg"];
    
    self.filters = [self allFilters];
    
    self.images = [[NSMutableArray alloc] init];
    self.faceFeatures = [[NSMutableArray alloc] initWithCapacity:2];
    
    self.isDownloading = false;
    
    // Start the download
    [self beginDownload:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.images.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Face detection
    if (indexPath.row > 7) {
        
        if (indexPath.row - 8 < self.faceFeatures.count) {
            cell.textLabel.text = [NSString stringWithFormat:@"%lu", self.faceFeatures[indexPath.row-8].count];
        } else {
            cell.textLabel.text = @"Loading";
        }
        
    } else {
        cell.textLabel.text = self.filters[indexPath.row].name;
    }
    
    // Configure the cell...
    cell.imageView.image = self.images[indexPath.row];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showImageSegue" sender:indexPath];
}

#pragma mark - Filters

- (NSArray<CIFilter*>*) allFilters
{
    CIFilter* gaussianFilter = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:nil];
    [gaussianFilter setValue:@4.0 forKey:@"inputRadius"];

    CIFilter* zoomBlur = [CIFilter filterWithName:@"CIZoomBlur" keysAndValues:nil];
    [zoomBlur setValue:@2 forKey:@"inputAmount"];
    
    CIFilter* colorClamp = [CIFilter filterWithName:@"CIColorClamp" keysAndValues:nil];
    CIFilter* colorMatrix = [CIFilter filterWithName:@"CIColorMatrix" keysAndValues:nil];
    CIFilter* toneCurve = [CIFilter filterWithName:@"CIToneCurve" keysAndValues: nil];
    CIFilter* hue = [CIFilter filterWithName:@"CIHueAdjust" keysAndValues: nil];
    CIFilter* cube = [CIFilter filterWithName:@"CIColorCube" keysAndValues: nil];
    CIFilter* noir = [CIFilter filterWithName:@"CIPhotoEffectNoir" keysAndValues: nil];
    
    return @[gaussianFilter, zoomBlur, colorClamp, colorMatrix, toneCurve, hue, cube, noir];
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showImageSegue"]) {
        NSIndexPath* path = sender;
        
        ImageViewController* vc = (ImageViewController *)segue.destinationViewController;
        vc.image = self.images[path.row];

        // Face Detectio
        if (path.row > 7) {
            vc.features = self.faceFeatures[path.row-8];
        } else {
            vc.filter = self.filters[path.row];
        }
    }
}

#pragma mark - IBAction

- (void) beginDownload:(void (^)())block
{
    // if we are already downloading then return
    if (self.isDownloading) {
        return;
    }
    
    self.isDownloading = true;
    
    // Make sure that all the images are deleted, and table view rows deleted.
    // before downloading.
    if ([self.images count] > 0) {
        [self.images removeAllObjects];
        [self.tableView reloadData];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        UIBackgroundTaskIdentifier __block identifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            [[UIApplication sharedApplication] endBackgroundTask:identifier];
            identifier = UIBackgroundTaskInvalid;
        }];
        
        for (NSString* link in self.links) {
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:link]]];
            image = [image resizeImageToSize:CGSizeMake(300, 300)];
            [self.images addObject:image];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.images.count-1 inSection:0];
                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            });
            
            // Run face detection
            if ([self.images count] > 8) {
                [PhotoFaceDetection detectFeaturesInImage:image withCompletionBlock:^(NSUInteger count, NSArray *features) {
                    [self.faceFeatures addObject:features];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.images.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    });
                }];
            }
        }
        
        self.isDownloading = false;
        [[UIApplication sharedApplication] endBackgroundTask:identifier];
        identifier = UIBackgroundTaskInvalid;
    });
    
}

@end
