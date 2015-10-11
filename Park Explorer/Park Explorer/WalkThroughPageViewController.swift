//
//  WalkThroughPageViewController.swift
//  Park Explorer
//
//  Created by Lauren Bosse on 10/11/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class  WalkThroughPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    let model = Model.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        //let firstPage =
    }
    
    func viewControllerAtIndex(index:Int) -> UIViewController {
        let contentViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
//        let state = stateModel.stateAtIndex(index)
//        let flagName = stateModel.flagNameAtIndex(index)
//        let info = stateModel.infoAtIndex(index)
        contentViewController.configureWithTitle(state, flagName: flagName, info: info, index: index)
        
        return contentViewController
    }
    
    //MARK: PageView Controller Data Source
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let contentViewController = viewController as! ContentViewController
        var index = contentViewController.pageIndex!
        if index == 0 {
            return nil
        } else {
            index--
            return viewControllerAtIndex(index)
        }
        return contentViewController
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let contentViewController = viewController as! ContentViewController
//        var index = contentViewController.stateIndex!
//        if index == model.numWalkThroughPages() - 1 {
//            return nil
//        } else {
//            index++
//            return viewControllerAtIndex(index)
//        }
        return contentViewController
    }

}