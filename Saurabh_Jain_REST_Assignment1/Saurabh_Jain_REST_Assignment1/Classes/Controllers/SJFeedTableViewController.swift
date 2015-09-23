//
//  SJFeedTableViewController.swift
//  Saurabh_Jain_REST_Assignment1
//
//  Created by Saurabh Jain on 9/19/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

import UIKit

class SJFeedTableViewController: UITableViewController {

    // Data Source
    private var messages: [[NSObject: AnyObject]]?
    
    // Manager
    private let messageManager = SJMessagesManager()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the download manager to download the messages
        messageManager.downloadMessages { (messages, error) -> () in
            dispatch_async(dispatch_get_main_queue()) {
                // There is an error, handle appropriately
                if error != nil {
                    self.showAlert("Error", message: "Cannot download messages")
                } else {
                    self.messages = messages
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // Configure the cell...
        if let message = messages?[indexPath.row][MessageIndexing.Message] as? [NSObject: AnyObject] {
            cell.textLabel?.text = message[MessageIndexing.Message] as? String
            
            var subtitle = ""
            if let name = message[MessageIndexing.Name] as? String {
                subtitle += "by " + name + " "
            }
            if let date = message[MessageIndexing.MessageDate] as? String {
                subtitle += "on " + date
            }
            
            cell.detailTextLabel?.text = subtitle
        }
        

        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            // Display Activity Indicator View
            let activity = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            UIApplication.sharedApplication().windows[0].rootViewController?.view.addSubview(activity)
            let frame = UIScreen.mainScreen().bounds
            activity.center = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
            activity.startAnimating()
            
            // Delete message request
            self.deleteMessage(atIndexPath: indexPath) { (success) -> Void in
                dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                    
                    // Stop the activity indicator view
                    activity.stopAnimating()
                    activity.removeFromSuperview()
                    if success {
                        // Delete the row from the data source
                        self.messages?.removeAtIndex(indexPath.row)
                        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    } else {
                        self.showAlert("Error", message: "Could not delete message")
                    }
                }
            }
        }
    }
    
    // MARK: Helper Functions
    
    private func deleteMessage(atIndexPath indexPath: NSIndexPath, block: (Bool) -> Void) {
        if let message = messages?[indexPath.row][MessageIndexing.Message] as? [NSObject: AnyObject] {
            if let id = message[MessageIndexing.ID] as? Int {
                messageManager.deleteMessage(id) { (error) -> Void in
                    if error != nil {
                        block(false)
                    } else {
                        block(true)
                    }
                }
            } else {
                block(false)
            }
        } else {
            block(false)
        }
    }
}


// Used to index into the message dictionary
public struct MessageIndexing {
    static let Message = "message"
    static let Name = "name"
    static let MessageDate = "message_date"
    static let ID = "id"
}
