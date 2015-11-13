//
//  LoginViewController.swift
//  Phantom
//
//  Created by Saurabh Jain on 11/12/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // Login Button
    private var fbLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeLoginButton()
    }
    
    /// Creates and adds the login button to the view
    private func initializeLoginButton() {
        fbLogin = UIButton()
        fbLogin.backgroundColor = UIColor.blackColor()
        fbLogin.setTitle("Login", forState: .Normal)
        fbLogin.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        fbLogin.translatesAutoresizingMaskIntoConstraints = false
        fbLogin.addTarget(self, action: "loginButtonPressed", forControlEvents: .TouchUpInside)
        view.addSubview(fbLogin)
        
        /// returns the constraints for the login button
        func constraintsForButton(button: UIButton) -> [NSLayoutConstraint] {
            
            // Bottom of button to bottom of screen
            let bottomConstraints = NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: -16*2)
            
            // height of button
            let heightConstraint = NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 32)
            
            // width of button
            let widthConstraint = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 32*3)
            
            // x centering
            let xCenter = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1.0, constant: 0)
            
            // return the constraints
            return [bottomConstraints, heightConstraint, widthConstraint, xCenter]
        }
        
        NSLayoutConstraint.activateConstraints(constraintsForButton(fbLogin))
    }
    
    /// Login button Action
    @objc private func loginButtonPressed() {
        
        // permissions to ask
        let permissions = ["email"]
        
        // Log in with permission
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) { (user: PFUser?, error: NSError?) in
            
            // if user does not exist, that means that we had a problem with the login
            guard let _ = user else {
                return
            }
            
            self.performSegueWithIdentifier("loggedInSegue", sender: nil)
        }
        
    }

}
