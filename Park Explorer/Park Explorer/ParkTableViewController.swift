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
    let buttonHeight : CGFloat = 30.0
    let animationDuration : NSTimeInterval = 1.5
    let maroonColor = UIColor(red: 0.20, green: 0.0, blue: 0.08, alpha: 1.0)

    let titleFont = "Bodoni 72 SmallCaps"
    let titleFontSize : CGFloat = 25
    let buttonBorderWidth : CGFloat = 0.8
    
    var selectedIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    var isZoomed = false
    var zoomScrollView = UIScrollView()
    var collapsedSections = [Bool]()
    
    override func viewDidLoad() {
        for _ in 0..<model.numberOfParks() {
            collapsedSections.append(false)
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
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
        let button = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: buttonHeight))
        button.setTitle(model.parkNameForSection(section), forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.addTarget(self, action: "collapseSection:", forControlEvents: .TouchUpInside)
        button.backgroundColor = maroonColor
        button.titleLabel?.font = UIFont(name: titleFont, size: titleFontSize)
        button.tag = section
        button.layer.borderWidth = buttonBorderWidth
        button.layer.borderColor = UIColor.whiteColor().CGColor
        return button
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        tableView.scrollEnabled = false
        selectedIndexPath = indexPath
       
        let viewSize = view.bounds.size
       
        //let zoomScrollViewFrame = CGRect(x: view.frame.origin.x, y: tableView.contentOffset.y, width: viewSize.width, height: viewSize.height)
        zoomScrollView = UIScrollView(frame: CGRectZero)
        zoomScrollView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        view.addSubview(zoomScrollView)
       
        let image = UIImage(named: "\(model.imageNameAtIndexPath(indexPath)).jpg")
        let convertedFrame = parkImageFrameLocationInCell(indexPath)
        let imageView = UIImageView(image: image)

        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        imageView.frame = zoomScrollView.bounds
        zoomScrollView.addSubview(imageView)
        zoomScrollView.frame = convertedFrame
        zoomScrollView.contentSize = convertedFrame.size
         zoomScrollView.backgroundColor = maroonColor
        zoomScrollView.showsVerticalScrollIndicator = false
        zoomScrollView.showsHorizontalScrollIndicator = false
        
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "imageViewTapped:")
        tapRecognizer.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tapRecognizer)
        imageView.userInteractionEnabled = true
        
        UIView.animateWithDuration(animationDuration) { () -> Void in
            self.zoomScrollView.frame = self.view.bounds
            self.tableView.bringSubviewToFront(self.zoomScrollView)
            
        }
       
        zoomScrollView.delegate = self
        zoomScrollView.minimumZoomScale = minZoomScale
        zoomScrollView.maximumZoomScale = maxZoomScale
        zoomScrollView.contentSize = viewSize
    }
    
    func imageViewTapped(recognizer : UITapGestureRecognizer){
        if !isZoomed {
            //animate the image back here
            let convertedFrame = parkImageFrameLocationInCell(selectedIndexPath)
            
            
            
            UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                self.zoomScrollView.frame = convertedFrame
                }, completion: { (finished) -> Void in
                    self.zoomScrollView.removeFromSuperview()
                    self.tableView.scrollEnabled = true
            })
            
        }
    }
    
    func parkImageFrameLocationInCell(indexPath: NSIndexPath) -> CGRect {
        let cell = tableView.cellForRowAtIndexPath(selectedIndexPath) as! ParkTableViewCell
        let imageFrame = cell.parkImageView.frame
        let convertedFrame = view.convertRect(imageFrame, fromCoordinateSpace: cell.contentView)
        return convertedFrame
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













