//
//  Utilities.swift
//  Phantom
//
//  Created by Saurabh Jain on 11/15/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

import Foundation

extension UIImage {
    
    func resizeImageToSize(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        let rect = CGRectMake(0, 0, size.width, size.height);
        drawInRect(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img;
    }
}

extension PFUser {
    
    // Stores the facebook info on parse
    public func storeFacebookInfo(info: [NSObject: NSObject]) {
        self.email = info["email"] as? String
        if let picture = info["picture"] as? [NSObject: NSObject] {
            if let data = picture["data"] as? [NSObject: NSObject] {
                if let url = data["url"] as? String {
                    setValue(url, forKey: "picture")
                }
            }
        }
        self.saveEventually()
    }
}