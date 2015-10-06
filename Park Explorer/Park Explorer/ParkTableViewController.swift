//
//  ParkTableViewController.swift
//  Park Explorer
//
//  Created by Lauren Bosse on 10/5/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class ParkTableViewController: UITableViewController {
    
    let model = Model.sharedInstance
    let minZoomScale : CGFloat = 1.0
    let maxZoomScale : CGFloat = 10.0
    
    var isZoomed = false
    var zoomScrollView = UIScrollView()
    var collapsedSections = [Bool]()
    
    override func viewDidLoad() {
        for _ in 0..<model.numberOfParks() {
            collapsedSections.append(false)
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
        cell.parkImageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: 30.0))
        button.setTitle(model.parkNameForSection(section), forState: .Normal)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.addTarget(self, action: "collapseSection:", forControlEvents: .TouchUpInside)
        button.tag = section
        return button
    }
    
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return model.parkNameForSection(section)
//    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        tableView.scrollEnabled = false
        
        let viewSize = tableView.bounds.size
       
        let zoomScrollViewFrame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: viewSize.width, height: viewSize.height)
        zoomScrollView = UIScrollView(frame: zoomScrollViewFrame)
        tableView.addSubview(zoomScrollView)
        
        let image = UIImage(named: "\(model.imageNameAtIndexPath(indexPath)).jpg")
        let imageView = UIImageView(image: image)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ParkTableCell", forIndexPath: indexPath) as! ParkTableViewCell
        let originalFrame = cell.superview!.convertRect(cell.parkImageView.frame, fromView: tableView)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "imageViewTapped:")
        tapRecognizer.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tapRecognizer)
        imageView.userInteractionEnabled = true
        
        imageView.frame = originalFrame
        //imageView.frame = tab
        
        let frame = CGRect(x: 0.0, y: tableView.contentOffset.y, width: viewSize.width, height: viewSize.height)
        
        
        UIView.animateWithDuration(3.0) { () -> Void in
            imageView.frame = frame
        }
       
        
        zoomScrollView.addSubview(imageView)
        zoomScrollView.delegate = self
        zoomScrollView.minimumZoomScale = minZoomScale
        zoomScrollView.maximumZoomScale = maxZoomScale
        zoomScrollView.contentSize = viewSize
        
        //collapsedSections[indexPath.section] = true
        //stateModel.toggleIsCheckedStateAtIndex(indexPath.row)
        //tableView.reloadData()
    }
    
    func imageViewTapped(recognizer : UITapGestureRecognizer){
        
        if !isZoomed {
            //animate the image back here
            zoomScrollView.removeFromSuperview()
            tableView.scrollEnabled = true
        }
    }
    
    // MARK:  Scrollview delegate
    override func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews[0]
    }
    
    override func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        if scale <= minZoomScale {
            isZoomed = false
        } else {
            isZoomed = true
        }
    }
}












