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
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    
    var feed: FeedObject? {
        didSet {
            guard let f = feed else {
                return
            }
            updateGUI(f)
        }
    }
    
    // Updates the GUI
    private func updateGUI(feed: FeedObject) {
        
        // post image
        if let str = feed.postImage.url {
            if let url = NSURL(string: str) {
                imgView.sd_setImageWithURL(url)
            }
        }
        
        
        
    }
    
}
