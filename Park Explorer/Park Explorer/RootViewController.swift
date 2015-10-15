//
//  RootViewController.swift
//  Park Explorer
//
//  Created by Lauren Bosse on 10/11/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

protocol WalkThroughDelegateProtocol {
    func dismissWalkThrough()
}

class RootViewController : UIViewController, UIPageViewControllerDataSource{
    
    @IBOutlet weak var segueButton: UIButton!
    @IBOutlet weak var directionLabel: UILabel!
    
    let model = Model.sharedInstance
    let greenColor = UIColor(red: 0.0, green: 0.502, blue: 0.004, alpha: 1.0)
    //var isDisplayingPageInstructions : Bool = true
    var pageViewController : UIPageViewController?
    var completionBlock : (() -> Void)?
    var delegate : WalkThroughDelegateProtocol?
    
    //var currentPageIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segueButton.backgroundColor = greenColor
        segueButton.userInteractionEnabled = true
        pageViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as? UIPageViewController)!
        pageViewController!.dataSource = self
        
        let firstPage = viewControllerAtIndex(0)
        pageViewController!.setViewControllers([firstPage], direction: .Forward, animated: false, completion: nil)
        pageViewController!.view.frame = self.view.bounds
        self.addChildViewController(pageViewController!)
        pageViewController!.didMoveToParentViewController(self)
        self.view.addSubview(pageViewController!.view)
    }
    
    override func shouldAutorotate() -> Bool {
        //dont let them rotate while animating
//        if isDisplayingPageInstructions {
//            return false
//        } else {
//            return true
//        }
        return false
    }
    
    override func viewDidLayoutSubviews() {
        view.bringSubviewToFront(segueButton)
    }
    
    func viewControllerAtIndex(index:Int) -> UIViewController {
        let contentViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad{
            let pageInstructionImage =  model.pageInstructionImageAtIndex(index + model.numberOfWalkThroughPages())
            contentViewController.configure(pageInstructionImage, index: index)
        } else {
            let pageInstructionImage =  model.pageInstructionImageAtIndex(index)
            contentViewController.configure(pageInstructionImage, index: index)
        }

        return contentViewController
    }
    
    func checkPageIndex(index:Int) {
        UIView.animateWithDuration(NSTimeInterval(0.0), delay: NSTimeInterval(1.0), options: UIViewAnimationOptions.LayoutSubviews, animations: { () -> Void in
            if index == self.model.numWalkThroughPages - 1 {
                self.segueButton.hidden = false
                self.directionLabel.hidden = true
            } else {
                self.segueButton.hidden = true
                self.directionLabel.hidden = false
            }
            }) { (finished) -> Void in
        }
    }
    
    
    
    @IBAction func returnFromWalkThrough(segue: UIStoryboardSegue){
        
    }
    
    @IBAction func segueButtonPressed(sender: UIButton) {
        delegate!.dismissWalkThrough()
        //isDisplayingPageInstructions = false
   
    }
    
    
    
    @IBAction func dismissByCompletion(sender: AnyObject) {
       
        if let closure = completionBlock {
            closure()
        }
    }
    
    //MARK: PageView Controller Data Source
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let contentViewController = viewController as! ContentViewController
        var index = contentViewController.pageIndex!
        checkPageIndex(index)
        if index == 0 {
            return nil
        } else {
            index--
            return viewControllerAtIndex(index)
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let contentViewController = viewController as! ContentViewController
        var index = contentViewController.pageIndex!
        checkPageIndex(index)
        if index == model.numberOfWalkThroughPages() - 1 {
            return nil
            
        } else {
            index++
            return viewControllerAtIndex(index)
        }
    }
    
    

}
