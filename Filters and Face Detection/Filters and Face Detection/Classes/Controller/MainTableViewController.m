//
//  MainTableViewController.m
//  Background Tasks
//
//  Created by Saurabh Jain on 9/29/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

#import "MainTableViewController.h"
#import "ImageViewController.h"

@interface MainTableViewController ()

@property (strong, nonatomic) NSArray<NSString *>* links;
@property (strong, nonatomic) NSMutableArray<UIImage *>* images;

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
                   @"http://i.space.com/images/i/000/021/072/original/mars-one-colony-2025.jpg?1375634917",
                   @"http://cdn.phys.org/newman/gfx/news/hires/2015/earthandmars.png"];
    
    self.images = [[NSMutableArray alloc] init];
    
    self.isDownloading = false;
    
    // Start the download
    [self beginDownload];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.images.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = self.links[indexPath.row];
    cell.imageView.image = self.images[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageViewController* vc = [[ImageViewController alloc] initWithImage:[self.images objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - IBAction

- (void) beginDownload
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
            [self.images addObject:image];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.images.count-1 inSection:0];
                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            });
        }
        
        self.isDownloading = false;
        [[UIApplication sharedApplication] endBackgroundTask:identifier];
        identifier = UIBackgroundTaskInvalid;
        
    });
    
}


@end
