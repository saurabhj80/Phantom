//
//  PostViewController.swift
//  Phantom
//
//  Created by Saurabh Jain on 11/15/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    // IBOutlets
    @IBOutlet private weak var imgView: UIImageView!
    @IBOutlet private weak var textView: UITextView!
    
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgView.image = self.image
    }

    @IBAction func saveFeed(sender: UIButton) {
        ParseManager.sharedManager.addFeed(image, text: textView.text) { success in
            dispatch_async(dispatch_get_main_queue()) {
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
