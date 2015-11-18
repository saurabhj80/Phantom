//
//  FeedTableViewCell.swift
//  Phantom
//
//  Created by Saurabh Jain on 11/9/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    // IBOutlets
    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            let radius = min(profileImageView.bounds.size.width, profileImageView.bounds.size.height)/2
            profileImageView.layer.cornerRadius = radius
        }
    }
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    // Model
    var feed: FeedObject? {
        willSet {
            if newValue == feed {
                return
            }
        }
        didSet {
            guard let f = feed else {
                return
            }
            updateGUI(f)
        }
    }
    
    class func nib() -> String {
        return "FeedTableViewCell"
    }
    
    // Updates the GUI
    private func updateGUI(feed: FeedObject) {
        
        // post image
        if let str = feed.postImage.url {
            if let url = NSURL(string: str) {
                imgView.sd_setImageWithURL(url)
            }
        }
        
        // Profile image
        if let str = feed.user.valueForKey("picture") as? String {
            if let url = NSURL(string: str) {
                profileImageView.sd_setImageWithURL(url)
            }
        }
        
        usernameLabel?.text = feed.text
    }
    
}
