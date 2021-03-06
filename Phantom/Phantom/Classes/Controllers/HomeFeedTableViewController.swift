//
//  HomeFeedTableViewController.swift
//  Phantom
//
//  Created by Saurabh Jain on 11/9/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

import UIKit

class HomeFeedTableViewController: UITableViewController, UITabBarControllerDelegate {

    // data source
    private var feedArray = [FeedObject]()
    
    // Constants
    private struct Constants {
        static let CellIdentifier = "Cell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check if we are not logged in
        if PFUser.currentUser() == nil {
            return
        }
        
        // register cell
        tableView.registerNib(UINib(nibName: FeedTableViewCell.nib(), bundle: nil), forCellReuseIdentifier: Constants.CellIdentifier)
        tableView.rowHeight = 500
        refreshFeed(nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }

    // Refresh the feed
    private func refreshFeed(completionBlock: (() -> ())?) {
        // fetch the feed
        ParseManager.sharedManager.fetchFeed { (feed, error) in
            guard let objects = feed else {
                return
            }
            
            if objects.count > 0 {
                self.feedArray = objects
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            }
            
            completionBlock?()
        }
    }

    @IBAction func refreshContollerPressed(sender: UIRefreshControl) {
        refreshFeed {
            sender.endRefreshing()
        }
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellIdentifier, forIndexPath: indexPath) as? FeedTableViewCell {
            cell.feed = feedArray[indexPath.row]
            cell.selectionStyle = .None
            return cell
        }
        return UITableViewCell(style: .Default, reuseIdentifier: nil)
    }
}
