//
//  Utilities.swift
//  Phantom
//
//  Created by Saurabh Jain on 11/15/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

import Foundation

extension UIImage {
    
    /// Resizes the image to fit a specific size
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


extension CIFilter {
    
    /// Returns some filters, which are instances of CIFilters
    class func allFilters() -> [CIFilter] {
        
        var filters = [CIFilter]()
        
        // Sepia
        if let sepia = CIFilter(name: "CISepiaTone") {
            filters.append(sepia)
        }
        
        // Blur
        if let blur = CIFilter(name: "CIGaussianBlur", withInputParameters: [kCIInputRadiusKey: 1]) {
            filters.append(blur)
        }
        
        // Instant
        if let instant = CIFilter(name: "CIPhotoEffectInstant") {
            filters.append(instant)
        }
        
        // Noir
        if let noir = CIFilter(name: "CIPhotoEffectNoir") {
            filters.append(noir)
        }

        return filters
    }
    
}