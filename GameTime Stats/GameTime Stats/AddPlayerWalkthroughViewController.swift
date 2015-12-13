//
//  AddPlayerWalkthroughViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 12/12/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class AddPlayerWalkthroughViewController : UIViewController, UIPageViewControllerDataSource, APWalkthroughCompletedProtocol {
    let model = Model.sharedInstance
    
    var pageViewController : UIPageViewController?
    var cancelBlock : (() -> Void)!
    
    @IBOutlet weak var okayButtonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("AddPlayerWalkthroughPageViewController") as? UIPageViewController)!
        pageViewController!.dataSource = self
        
        let firstPage = viewControllerAtIndex(0)
        pageViewController!.setViewControllers([firstPage], direction: .Forward, animated: false, completion: nil)
        pageViewController!.view.frame = self.view.bounds
        self.addChildViewController(pageViewController!)
        pageViewController!.didMoveToParentViewController(self)
        self.view.addSubview(pageViewController!.view)
        //self.view.bringSubviewToFront(okayButtonView)
    }
    
    func viewControllerAtIndex(index:Int) -> UIViewController {
        let detailViewController = self.storyboard!.instantiateViewControllerWithIdentifier("AddPlayerWalkthroughDetailViewController") as! AddPlayerWalkthroughDetailViewController
        detailViewController.delegate = self
        
        let pageInstructionImage = model.addPlayerWalkthroughImageStringAtIndex(index)
        detailViewController.configure(pageInstructionImage, index: index)
        
        return detailViewController
    }

    func dismissMe() {
        cancelBlock()
    }
    
    @IBAction func okayButtonPressed(sender: UIButton) {
        cancelBlock()
    }
    
    //MARK: PageView Controller Data Source
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let contentViewController = viewController as! AddPlayerWalkthroughDetailViewController
        var index = contentViewController.pageIndex!
        //checkPageIndex(index)
        if index == 0 {
            return nil
        } else {
            index--
            return viewControllerAtIndex(index)
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let contentViewController = viewController as! AddPlayerWalkthroughDetailViewController
        var index = contentViewController.pageIndex!
        //checkPageIndex(index)
        if index == model.numAPWalkthroughImages() - 1 {
            return nil
            
        } else {
            index++
            return viewControllerAtIndex(index)
        }
    }

}
