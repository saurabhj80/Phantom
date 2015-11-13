//
//  AppDelegate.swift
//  Phantom
//
//  Created by Saurabh Jain on 11/9/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    /// Parse Constants
    private struct ParseConstants {
        static let ApplicationId = "lbQK6NadK4cdWx5LAJblZpRN1giDTc1wDpwE3Cxi"
        static let ClientKey = "QLHzFLueJFugBQmCkfP1XNMMAayWT5hgR885Jj6n"
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // register
        FeedObject .registerSubclass()
        Parse.setApplicationId(ParseConstants.ApplicationId, clientKey: ParseConstants.ClientKey)
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
            return FBSDKApplicationDelegate.sharedInstance().application(application,
                openURL: url,
                sourceApplication: sourceApplication,
                annotation: annotation)
    }
    
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
}

