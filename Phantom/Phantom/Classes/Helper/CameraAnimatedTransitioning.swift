//
//  CameraAnimatedTransitioning.swift
//  Phantom
//
//  Created by Saurabh Jain on 11/10/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

import UIKit

internal class CameraAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    // Duration of the animation
    internal var duration: NSTimeInterval
    
    init(duration: NSTimeInterval) {
        self.duration = duration
    }
    
    // performs reverse animation
    internal var reverse = false
    
    // MARK: UIViewControllerAnimatedTransitioning
    // Responsible for carrying out the animation and the transition
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let containerView = transitionContext.containerView()
        
        guard let toVC = toViewController, fromVC = fromViewController, cv = containerView else {
            return
        }
        
        let height = CGRectGetHeight(UIScreen.mainScreen().bounds)
        var frame = CGRectOffset(UIScreen.mainScreen().bounds, 0, height)

        if reverse {
            toVC.view.frame = frame
            cv.addSubview(toVC.view)
            frame = CGRectOffset(frame, 0, -height)
            
            UIView.animateWithDuration(0.5, animations: { toVC.view.frame = frame }) { success in
                fromVC.view.removeFromSuperview()
                transitionContext.completeTransition(success)
            }
            
        } else {
            // insert below the from view controller
            cv.insertSubview(toVC.view, belowSubview: fromVC.view)
            
            UIView.animateWithDuration(0.5, animations: { fromVC.view.frame = frame }) { success in
                fromVC.view.removeFromSuperview()
                transitionContext.completeTransition(success)
            }
        }
    }
    
}
