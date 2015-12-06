//
//  PlayerStatsViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 12/5/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class PlayerStatsViewController: UIViewController, UIPageViewControllerDataSource{
    let model = Model.sharedInstance
    
    
    var pageViewController : UIPageViewController?
    var player : Player!
    var game : Game!
    
    override func viewDidLoad() {
        
        //MARK: View did load PageView Setup
        pageViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("PlayerStatPageViewController") as? UIPageViewController)!
        pageViewController!.dataSource = self
        
        let firstPage = viewControllerAtIndex(0)
        pageViewController!.setViewControllers([firstPage], direction: .Forward, animated: false, completion: nil)
        pageViewController!.view.frame = self.view.bounds
        self.addChildViewController(pageViewController!)
        pageViewController!.didMoveToParentViewController(self)
        self.view.addSubview(pageViewController!.view)
    }
    
    //MARK: Helper Functions
    func viewControllerAtIndex(index:Int) -> UIViewController {
        let contentViewController = self.storyboard!.instantiateViewControllerWithIdentifier("PlayerStatsDetailViewController") as! PlayerStatsDetailViewController
        
        contentViewController.configure(player, game: game, index: index)
        
        return contentViewController
    }
    
    //MARK: PageView Controller Data Source
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let playerStatsDetailViewController = viewController as! PlayerStatsDetailViewController
        var index = playerStatsDetailViewController.pageIndex!
        if index == 0 {
            return nil
        } else {
            index--
            return viewControllerAtIndex(index)
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let contentViewController = viewController as! PlayerStatsDetailViewController
        var index = contentViewController.pageIndex!
        
        //Determine if the game had overtime
        var numPeriods = model.numberOfPeriodTypes()
        if !Bool(game.hasOvertime!) {
            numPeriods--
        }
        
        if index == numPeriods - 1 {
            return nil
            
        } else {
            index++
            return viewControllerAtIndex(index)
        }
    }

    
}