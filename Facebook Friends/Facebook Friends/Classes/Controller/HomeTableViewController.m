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

#import "Friend.h"

#import "FBManager.h"

@interface HomeTableViewController ()

@property (strong, nonatomic) NSMutableArray<Friend *>* friends;

@end

@implementation HomeTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Manager to fetch the friends
    [FBManager getFriends:^(NSArray<id> * _Nullable friends, NSError * _Nullable error) {
        if (friends) {
            for (NSDictionary* data in friends) {
                Friend* friend = [[Friend alloc] initWithData:data];
                [self.friends addObject:friend];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
    
}

#pragma mark - Getter

-(NSMutableArray<Friend *> *)friends
{
    if (!_friends) {
        _friends = [[NSMutableArray alloc] init];
    }
    return _friends;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = self.friends[indexPath.row].name;
    
    return cell;
}


@end
