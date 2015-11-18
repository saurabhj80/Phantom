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
}

class PostViewController: UIViewController {

    // Delegate
    weak var delegate: PostViewControllerDelegate?
    
    // IBOutlets
    @IBOutlet private weak var imgView: UIImageView!
    @IBOutlet private weak var textView: UITextView!
    
    // image to save to parse
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgView.image = self.image
    }

    /// Post to Parse
    @IBAction func saveFeed(sender: UIButton) {
        
        let maxWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        let img = image.resizeImageToSize(CGSize(width: maxWidth, height: 1.25 * maxWidth))
        
        ParseManager.sharedManager.addFeed(img, text: textView.text) { success in
            dispatch_async(dispatch_get_main_queue()) { [weak self] in
                self?.delegate?.postViewControllerDidSaveObject(self!)
            }
        }
    }
}
