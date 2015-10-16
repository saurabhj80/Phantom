//
//  HomeTableViewController.m
//  Facebook Friends
//
//  Created by Saurabh Jain on 10/15/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

#import "HomeTableViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "Friend.h"

#import "FBManager.h"

@interface HomeTableViewController ()

@property (strong, nonatomic) NSArray<Friend *>* friends;

@end

@implementation HomeTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Manager to fetch the friends
    [FBManager getFriends:^(NSArray<id> * _Nullable friends, NSError * _Nullable error) {
        if (friends) {
            
            NSMutableArray<Friend *>* f = [NSMutableArray new];
            
            for (NSDictionary* data in friends) {
                Friend* friend = [[Friend alloc] initWithData:data];
                [f addObject:friend];
            }
            
            // Sort the array based on the first name
            NSSortDescriptor* sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
            self.friends = [f sortedArrayUsingDescriptors:@[sort]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = self.friends[indexPath.row].name;
    [cell.imageView setImageWithURL:self.friends[indexPath.row].pictureURL];
    return cell;
}


@end
