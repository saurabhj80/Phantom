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

    // The custom animation
    private var animation = CameraAnimatedTransitioning(duration: 0.5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        UITabBar.appearance().tintColor = UIColor.blackColor()
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        if selectedIndex == 1{
            tabBarController.tabBar.hidden = true
        }
    }
    
    // Custom Segue
    func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let reversed = selectedIndex == 0 ? false : true
        animation.reverse = reversed
        return animation
    }
}
