//
//  FilterViewController.swift
//  Phantom
//
//  Created by Saurabh Jain on 11/18/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

import UIKit

/// Filtered image to store the image and the filters to be applied
public struct FilterImage {
    var image: UIImage
    var filters: [CIFilter]
    
    init(image: UIImage, filters: [CIFilter]) {
        self.image = image
        self.filters = filters
    }
}

/// FilterViewControllerDelegate: Used for passing information to Post View Controller
protocol FilterViewControllerDelegate: NSObjectProtocol {
    func filterViewController(viewController: FilterViewController, didSelectFilteredImage image: UIImage)
}

/// Collection View which shows the image with filters applied
class FilterViewController: UICollectionViewController {

    // Model object
    var filteredImage: FilterImage?
    
    // Delegate
    weak var delegate: FilterViewControllerDelegate?
    
    // MARK: Collection view data source
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredImage?.filters.count ?? 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // if the cell is a FilterCollectionView Cell
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FilterCell", forIndexPath: indexPath) as? FilterCollectionViewCell {
            
            // Filter the image with a filter
            PhotoFilter.sharedFilter.applyFilter(filteredImage!.filters[indexPath.row], onImage: filteredImage!.image) { image in
                dispatch_async(dispatch_get_main_queue()) {
                    cell.imgView.image = image
                }
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    // MARK: Collection View Delegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? FilterCollectionViewCell {
            delegate?.filterViewController(self, didSelectFilteredImage: cell.imgView.image!)
        }
    }
    
}
