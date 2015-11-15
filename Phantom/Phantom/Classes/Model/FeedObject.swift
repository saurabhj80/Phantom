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
    
    dynamic var postImage: PFFile!
    dynamic var user: PFUser!
    dynamic var location: PFGeoPoint!
    dynamic var text: String!
}
