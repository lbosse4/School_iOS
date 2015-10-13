//
//  MasterViewController.swift
//  Park Explorer
//
//  Created by Lauren Bosse on 10/12/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    @IBOutlet weak var titleLabel: UINavigationItem!
    
    let model = Model.sharedInstance
    let buttonHeight : CGFloat = 55.0
    let animationDuration : NSTimeInterval = 1.5
    let maroonColor = UIColor(red: 0.20, green: 0.0, blue: 0.08, alpha: 1.0)
    let titleFont = "Bodoni 72 SmallCaps"
    let titleFontSize : CGFloat = 28
    let buttonBorderWidth : CGFloat = 0.8
    
    var selectedIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    var isZoomed = false
    var zoomScrollView = UIScrollView()
    var collapsedSections = [Bool]()
    var detailViewController: DetailViewController? = nil
    
    override func viewDidLoad() {
        
        for _ in 0..<model.numberOfParks() {
            collapsedSections.append(false)
        }
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    func collapseSection(sender: UIButton){
        collapsedSections[sender.tag] = !collapsedSections[sender.tag]
        let indexSet = NSIndexSet(index: sender.tag)
        tableView.reloadSections(indexSet, withRowAnimation: .Automatic)
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return model.numberOfParks()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if collapsedSections[section] {
            return 0
        } else {
            return model.imageCountForPark(section)
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ParkTableCell", forIndexPath: indexPath) as! ParkTableViewCell
        
        // Configure the cell...
        cell.captionLabel.text = model.imageCaptionAtIndexPath(indexPath)
        let image = UIImage(named: "\(model.imageNameAtIndexPath(indexPath)).jpg")
        cell.parkImageView.image = image
        //cell.parkImageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        return cell
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: buttonHeight))
        button.setTitle(model.parkNameForSection(section), forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.addTarget(self, action: "collapseSection:", forControlEvents: .TouchUpInside)
        button.backgroundColor = UIColor.darkGrayColor()//maroonColor
        button.titleLabel?.font = UIFont(name: titleFont, size: titleFontSize)
        button.tag = section
        button.layer.borderWidth = buttonBorderWidth
        button.layer.borderColor = UIColor.whiteColor().CGColor
        return button
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        //tableView.scrollEnabled = false
        selectedIndexPath = indexPath
        //performSegueWithIdentifier("showDetail", sender: self)

        
//        
//        let masterViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MasterViewController") as! MasterViewController
//        prepareForSegue(masterViewController.segueForUnwindingToViewController(detailViewController!, fromViewController: masterViewController, identifier: "showDetail")!, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                //let object = objects[indexPath.row] as! NSDate
                let imageName = model.imageNameAtIndexPath(indexPath)
                let imageCaption = model.imageCaptionAtIndexPath(indexPath)
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.imageDetail = imageName
                controller.imageCaptionDetail = imageCaption
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
}





















