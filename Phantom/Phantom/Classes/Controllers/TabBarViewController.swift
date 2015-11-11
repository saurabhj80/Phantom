//
//  TabBarViewController.swift
//  Phantom
//
//  Created by Saurabh Jain on 11/10/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate, UIViewControllerTransitioningDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.delegate = self
    }
    
//    // Custom transition
//    func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        if toVC.isKindOfClass(CameraViewController.self) {
//            return CameraAnimatedTransitioning(duration: 1)
//        }
//        return nil
//    }
}
