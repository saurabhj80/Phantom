//
//  ParseManager.swift
//  Phantom
//
//  Created by Saurabh Jain on 11/9/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

import UIKit

public class ParseManager: NSObject {
    
    // fetches the feed from parse
    public func fetchFeed(block: ([FeedObject]?, NSError?) -> ()) {
        let query = PFQuery(className: FeedObject.parseClassName())
        query.findObjectsInBackgroundWithBlock { (object, error) -> Void in
            
            // if objects exist
            if let objects = object {
                if let feed = objects as? [FeedObject] {
                    block(feed, error)
                    return
                }
            }
            
            block(nil, error)
        }
    }
    
}
