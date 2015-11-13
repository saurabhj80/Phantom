//
//  TabBarViewController.swift
//  Phantom
//
//  Created by Saurabh Jain on 11/10/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

import UIKit

/*! @description A subclass of UITabBarController, which manages custom transition */

class TabBarViewController: UITabBarController, UITabBarControllerDelegate, UIViewControllerTransitioningDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if toVC.isKindOfClass(CameraViewController) {
            return CameraAnimatedTransitioning(duration: 1)
        }
        return nil
    }
}
