//
//  Utility.swift
//  Saurabh_Jain_REST_Assignment1
//
//  Created by Saurabh Jain on 9/19/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

import UIKit

public extension UIViewController {
    // Automatically adds a Dismiss Action
    func showAlert(title: String?, message: String?, action: UIAlertAction? = nil) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        if let action = action {
            controller.addAction(action)
        }
        let action = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
        controller.addAction(action)
        presentViewController(controller, animated: true, completion: nil)
    }
}