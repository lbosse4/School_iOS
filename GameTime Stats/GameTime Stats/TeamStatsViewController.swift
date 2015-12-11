//
//  TeamStatsViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 12/5/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

protocol TeamStatsViewedProtocol {
    func dismissMe()
}

class TeamStatsViewController: UIViewController, UIPageViewControllerDataSource {
    let model = Model.sharedInstance

    var pageViewController : UIPageViewController?
    var cancelBlock : (() -> Void)!
    var delegate : TeamStatsViewedProtocol?
    var team : Team!
    var game : Game!
    
    //MARK: Outlets
    @IBOutlet weak var okayButtonView: UIView!
    
    override func viewDidLoad() {
        //MARK: View did load PageView Setup
        pageViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("TeamStatPageViewController") as? UIPageViewController)!
        pageViewController!.dataSource = self
        let firstPage = viewControllerAtIndex(0)
        pageViewController!.setViewControllers([firstPage], direction: .Forward, animated: false, completion: nil)
        pageViewController!.view.frame = self.view.bounds
        self.addChildViewController(pageViewController!)
        pageViewController!.didMoveToParentViewController(self)
        self.view.addSubview(pageViewController!.view)
        self.view.bringSubviewToFront(okayButtonView)
    }
    
    //MARK: Helper Functions
    func viewControllerAtIndex(index:Int) -> UIViewController {
        let contentViewController = self.storyboard!.instantiateViewControllerWithIdentifier("TeamStatsDetailViewController") as! TeamStatsDetailViewController
        
        contentViewController.configure(team, game: game, index: index)
        
        return contentViewController
    }
    
    //MARK: PageView Controller Data Source
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let teamStatsDetailViewController = viewController as! TeamStatsDetailViewController
        var index = teamStatsDetailViewController.pageIndex!
        if index == 0 {
            return nil
        } else {
            index--
            return viewControllerAtIndex(index)
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let teamStatsDetailViewController = viewController as! TeamStatsDetailViewController
        var index = teamStatsDetailViewController.pageIndex!
        
        //Determine if the game had overtime
        //var numPeriods = model.numberOfPeriodTypes()
        let players = team.players!.allObjects as! [Player]
        let numPeriods = model.allStatsForPlayer(players[0], game: game).count
        
        if index == numPeriods - 1 {
            return nil
            
        } else {
            index++
            return viewControllerAtIndex(index)
        }
    }

    @IBAction func okayButtonPressed(sender: UIButton) {
        cancelBlock!()
        delegate?.dismissMe()
    }
    
    
}

