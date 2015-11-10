//
//  ParseManager.swift
//  Phantom
//
//  Created by Saurabh Jain on 11/9/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

import UIKit

public class ParseManager: NSObject {
    
    private override init() {}
    
    // Singleton
    public static let sharedManager = ParseManager()
    
    // fetches the feed from parse
    public func fetchFeed(block: ([FeedObject]?, NSError?) -> ()) {
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geopoint, error) -> Void in
            
            if let geo = geopoint {
                
                let query = PFQuery(className: FeedObject.parseClassName())
                query.includeKey("user")
                query.whereKey("location", nearGeoPoint: geo, withinMiles: 5)
                query.findObjectsInBackgroundWithBlock { (object, error) in
                    
                    // if objects exist
                    if let objects = object as? [FeedObject] {
                        block(objects, error)
                    } else {
                        block(nil, error)
                    }
                }
            } else {
                block(nil, error)
            }
        }
    }
    
}
