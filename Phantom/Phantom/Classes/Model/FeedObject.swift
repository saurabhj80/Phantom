//
//  FeedObject.swift
//  Phantom
//
//  Created by Saurabh Jain on 11/9/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

import UIKit

public class FeedObject: PFObject, PFSubclassing {
    
    // PFSubclassing
    public class func parseClassName() -> String {
        return "FeedObject"
    }
    
    @NSManaged var postImage: PFFile!
    @NSManaged var user: PFUser!
    @NSManaged var location: PFGeoPoint!
    @NSManaged var text: String!
}
