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
    
    /// Fetches the feed from parse
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
    
    /// Method used for adding a post to parse
    public func addFeed(image: UIImage, completionBlock:(Bool)->()) {
        
        // handle the case when the user is not logged in
        guard let currentUser = PFUser.currentUser() else {
            completionBlock(false)
            return
        }
        
        // fetch the current location
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geopoint, error) -> Void in
            
            // if we have the location
            if let location = geopoint {
                
                // cannot convert the image to data
                guard let data = UIImageJPEGRepresentation(image, 0.7) else {
                    completionBlock(false)
                    return
                }
                
                // create the object to save to parse
                let object = FeedObject()
                object.postImage = PFFile(data: data)
                object.user = currentUser
                object.location = location
                
                // save the object
                object.saveInBackgroundWithBlock { (success, error) in
                    completionBlock(success)
                }
                
            } else {
                completionBlock(false)
            }
        }
        
    }
}
