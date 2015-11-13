//
//  LoginViewController.swift
//  Phantom
//
//  Created by Saurabh Jain on 11/12/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    private var fbLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeLoginButton()
    }
    
    /// Creates and adds the login button to the view
    private func initializeLoginButton() {
        fbLogin = UIButton()
        fbLogin.backgroundColor = UIColor.blueColor()
        fbLogin.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fbLogin)
        
        /// returns the constraints for the login button
        func constraintsForButton(button: UIButton) -> [NSLayoutConstraint] {
            
            // Bottom of button to bottom of screen
            let bottomConstraints = NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: -16)
            
            // height of button
            let heightConstraint = NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 32)
            
            // width of button
            let widthConstraint = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 50)
            
            // x centering
            let xCenter = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1.0, constant: 0)
            
            // return the constraints
            return [bottomConstraints, heightConstraint, widthConstraint, xCenter]
        }
        
        NSLayoutConstraint.activateConstraints(constraintsForButton(fbLogin))
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
