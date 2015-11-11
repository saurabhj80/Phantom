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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register cell
        tableView.registerNib(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        refreshFeed()
        
        tabBarController?.delegate = self
        
    }
    
    func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CameraAnimatedTransitioning(duration: 1)
    }

    private func refreshFeed() {
        // fetch the feed
        ParseManager.sharedManager.fetchFeed { (feed, error) in
            guard let objects = feed else {
                return
            }
            
            if objects.count > 0 {
                self.feedArray = objects
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func refreshContollerPressed(sender: UIRefreshControl) {
        refreshFeed()
    }
    
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! FeedTableViewCell
        cell.feed = feedArray[indexPath.row]
        return cell
    }

}
