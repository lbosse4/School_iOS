//
//  AppDelegate.swift
//  Park Explorer
//
//  Created by Lauren Bosse on 9/27/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

enum UIUserInterfaceIdiom : Int {
    case Unspecified
    
    case Phone // iPhone and iPod touch style UI
    case Pad // iPad style UI
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        
        let aSplitViewController = self.window!.rootViewController as! UISplitViewController
        let navigationController = aSplitViewController.viewControllers[aSplitViewController.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = aSplitViewController.displayModeButtonItem()
        aSplitViewController.delegate = self

        
        let rootViewController = aSplitViewController.viewControllers[0] as! UINavigationController
        splitViewController(aSplitViewController, showViewController: rootViewController.viewControllers[0], sender: aSplitViewController)
        
        //splitViewController(<#T##splitViewController: UISplitViewController##UISplitViewController#>, showViewController: <#T##UIViewController#>, sender: <#T##AnyObject?#>)
        //splitViewController(splitViewController, collapseSecondaryViewController: , ontoPrimaryViewController: <#T##UIViewController#>)
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Split view
    
//    func splitViewController(splitViewController: UISplitViewController, showDetailViewController vc: UIViewController, sender: AnyObject?) -> Bool {
//        
//        return true
//    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
       
        //let iPad = UIUserInterfaceIdiom.Pad
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad{
            return false
        }
        if topAsDetailController.imageDetail == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        if topAsDetailController.imageCaptionDetail == nil {
            return true
        }
        return false
    }

    func splitViewController(splitViewController: UISplitViewController, showViewController vc: UIViewController, sender: AnyObject?) -> Bool {
        return true
    }
    
}

