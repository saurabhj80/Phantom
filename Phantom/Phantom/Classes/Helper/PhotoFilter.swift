//
//  PhotoFilter.swift
//  Phantom
//
//  Created by Saurabh Jain on 11/18/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

import UIKit

protocol PhotoFilterProtocol: class {
    func applyFilter(filter: CIFilter, onImage image: UIImage, withCompletionBlock block:(UIImage?) -> ())
}

class PhotoFilter: PhotoFilterProtocol {

    // Context object
    private var context = CIContext()
    
    // Singleton
    private init() {}
    static let sharedFilter = PhotoFilter()
    
    // MARK: PhotoFilter Protocol
    
    func applyFilter(filter: CIFilter, onImage image: UIImage, withCompletionBlock block:(UIImage?) -> ()) {
        
        // get the CGimage
        guard let cgimage = image.CGImage else  {
            block(nil)
            return
        }
        
        // Do the filtering on a background thread
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
            // Get the CIImage
            let ciimage = CIImage(CGImage: cgimage)
            
            // Input to filter
            filter.setValue(ciimage, forKey: kCIInputImageKey)
            
            let orientation = image.imageOrientation
            let scale = image.scale
            
            // Get the output image
            if let img = filter.outputImage {
                let rect = img.extent
                let image = self.context.createCGImage(img, fromRect: rect)
                block(UIImage(CGImage: image, scale: scale, orientation: orientation))
            } else {
                block(nil)
            }
        }
        
    }
    
}
