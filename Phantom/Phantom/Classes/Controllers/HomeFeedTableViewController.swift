//
//  HomeFeedTableViewController.swift
//  Phantom
//
//  Created by Saurabh Jain on 11/9/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

import UIKit
import AVFoundation

class HomeFeedTableViewController: UITableViewController, UITabBarControllerDelegate {

    // data source
    private var feedArray = [FeedObject]()
    
    // Constants
    private struct Constants {
        static let CellIdentifier = "Cell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check if we are logged in
        
        
        // register cell
        tableView.registerNib(UINib(nibName: FeedTableViewCell.nib(), bundle: nil), forCellReuseIdentifier: Constants.CellIdentifier)
        //refreshFeed()
        
        print(AVCaptureDevice.devices())
        
        for device in AVCaptureDevice.devices() {
            if let dev = device as? AVCaptureDevice {
                print(dev.localizedName)
            }
        }
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
        if let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellIdentifier, forIndexPath: indexPath) as? FeedTableViewCell {
            cell.feed = feedArray[indexPath.row]
            return cell
        }
        return UITableViewCell(style: .Default, reuseIdentifier: nil)
    }

}
