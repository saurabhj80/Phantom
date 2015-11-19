//
//  PostViewController.swift
//  Phantom
//
//  Created by Saurabh Jain on 11/15/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

import UIKit

protocol PostViewControllerDelegate: class {
    func postViewControllerDidSaveObject(controller: PostViewController)
    func postViewController(controller: PostViewController, didPressCancelButton sender: UIButton)
}

class PostViewController: UIViewController, FilterViewControllerDelegate {

    // Delegate
    weak var delegate: PostViewControllerDelegate?
    
    // IBOutlets
    @IBOutlet private weak var imgView: UIImageView!
    @IBOutlet private weak var captionField: UITextField!
    
    // image to save to parse
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgView.image = self.image
    }
    
    // Status bar hidden
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    /// Post to Parse
    @IBAction func saveFeed(sender: UIButton) {
        
        let maxWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        let img = imgView.image!.resizeImageToSize(CGSize(width: maxWidth, height: 1.25 * maxWidth))
        
        ParseManager.sharedManager.addFeed(img, text: captionField.text) { success in
            dispatch_async(dispatch_get_main_queue()) { [weak self] in
                self?.delegate?.postViewControllerDidSaveObject(self!)
            }
        }
    }
    
    @IBAction func backButtonPressed(sender: UIButton) {
        delegate?.postViewController(self, didPressCancelButton: sender)
    }
    
    // MARK: Navigation
    
    private struct Storyboard {
        static let FilterSegue = "FilterSegue"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.FilterSegue {
            if let vc = segue.destinationViewController as? FilterViewController {
                let model = FilterImage(image: image, filters: CIFilter.allFilters())
                vc.filteredImage = model
                vc.delegate = self
            }
        }
    }
    
    // MARK: FilterViewController Delegate
    
    func filterViewController(viewController: FilterViewController, didSelectFilteredImage image: UIImage) {
        imgView.image = image
    }
}
