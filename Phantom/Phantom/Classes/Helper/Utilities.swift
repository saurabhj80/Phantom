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