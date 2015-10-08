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
    
    var selectedIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    var isZoomed = false
    var zoomScrollView = UIScrollView()
    var collapsedSections = [Bool]()
    
    override func viewDidLoad() {
        for _ in 0..<model.numberOfParks() {
            collapsedSections.append(false)
        }
        zoomScrollView.showsHorizontalScrollIndicator = false
        zoomScrollView.showsVerticalScrollIndicator = false
    }
    
    override func viewDidLayoutSubviews() {
        if zoomScrollView.superview == tableView {
//            let viewSize = view.frame.size
//            let frame = CGRect(x: 0.0, y: 0.0, width: viewSize.width, height: viewSize.height)
            //zoomScrollView.contentSize = view.frame.size
            zoomScrollView.backgroundColor = UIColor.blackColor()
//            zoomScrollView.subviews[0].frame = frame
        }
    }
    
    override func shouldAutorotate() -> Bool {
        //dont let them animate while rotating
        return true
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        //tableView.scrollToRowAtIndexPath(selectedIndexPath, atScrollPosition: .Middle, animated: true)
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

        imageView.image = image
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        imageView.frame = zoomScrollView.bounds
        zoomScrollView.addSubview(imageView)
        zoomScrollView.frame = convertedFrame
        zoomScrollView.contentSize = convertedFrame.size
        
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "imageViewTapped:")
        tapRecognizer.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tapRecognizer)
        imageView.userInteractionEnabled = true
        
        UIView.animateWithDuration(1.0) { () -> Void in
            
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
            
            UIView.animateWithDuration(2.0, animations: { () -> Void in
                self.zoomScrollView.frame = convertedFrame
                }, completion: { (finished) -> Void in
                    self.zoomScrollView.removeFromSuperview()
                    self.tableView.scrollEnabled = true
            })
            
        }
    }
    
    func selectedCell(indexPath: NSIndexPath) -> ParkTableViewCell{
        let cell = tableView.cellForRowAtIndexPath(selectedIndexPath) as! ParkTableViewCell
        return cell
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












