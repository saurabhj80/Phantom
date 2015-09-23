//
//  SJPostMessageViewController.swift
//  Saurabh_Jain_REST_Assignment1
//
//  Created by Saurabh Jain on 9/19/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

import UIKit

class SJPostMessageViewController: UIViewController {

    // IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    
    // Manager
    private let messageManager = SJMessagesManager()
    
    // Lazy properties because are expensive to create
    private lazy var formatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        return formatter
    }()
    
    // MARK: IBActions

    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveMessageButtonPressed(sender: UIBarButtonItem) {
        
        // Display Activity Indicator View
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        let frame = UIScreen.mainScreen().bounds
        activity.center = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        self.view.addSubview(activity)
        activity.startAnimating()

        let message = [MessageIndexing.Name: nameTextField.text,
                       MessageIndexing.Message: messageTextView.text,
                       MessageIndexing.MessageDate: formatter.stringFromDate(NSDate())]
        
        let post = [MessageIndexing.Message: message]
        
        let data = try? NSJSONSerialization.dataWithJSONObject(post, options: NSJSONWritingOptions.PrettyPrinted)
        
        messageManager.postMessage(data!) { (error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                activity.stopAnimating()
                activity.removeFromSuperview()
                
                // Show Error
                if error != nil {
                    self.showAlert("Error", message: "Cannot Post")
                } else {
                    self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
    }

}
