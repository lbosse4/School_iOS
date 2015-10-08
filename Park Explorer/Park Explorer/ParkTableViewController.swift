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
    
    var selectedIndexPath = NSIndexPath()
    var isZoomed = false
    var zoomScrollView = UIScrollView()
    var collapsedSections = [Bool]()
    
    override func viewDidLoad() {
        for _ in 0..<model.numberOfParks() {
            collapsedSections.append(false)
        }
    }
    
    override func viewDidLayoutSubviews() {
        if zoomScrollView.superview == tableView {
            let viewSize = view.frame.size
            let frame = CGRect(x: 0.0, y: 0.0, width: viewSize.width, height: viewSize.height)
            //tableView.scrollToRowAtIndexPath(selectedIndexPath, atScrollPosition: .Middle, animated: true)
            zoomScrollView.contentSize = frame.size
            zoomScrollView.subviews[0].frame = frame
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        tableView.scrollEnabled = false
        selectedIndexPath = indexPath
        
        let viewSize = view.bounds.size
       
        let zoomScrollViewFrame = CGRect(x: view.frame.origin.x, y: tableView.contentOffset.y, width: viewSize.width, height: viewSize.height)
        zoomScrollView = UIScrollView(frame: zoomScrollViewFrame)
        zoomScrollView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        view.addSubview(zoomScrollView)
       
        let image = UIImage(named: "\(model.imageNameAtIndexPath(indexPath)).jpg")
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ParkTableViewCell
        let imageFrame = cell.parkImageView.frame
        let convertedFrame = view.convertRect(imageFrame, fromCoordinateSpace: cell.contentView)
        let imageView = UIImageView(image: image)

        imageView.image = image
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        zoomScrollView.addSubview(imageView)
        zoomScrollView.frame = convertedFrame
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "imageViewTapped:")
        tapRecognizer.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tapRecognizer)
        imageView.userInteractionEnabled = true
        
        UIView.animateWithDuration(5.0) { () -> Void in
            
            self.zoomScrollView.frame = self.view.frame
            
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
            
            
            zoomScrollView.removeFromSuperview()
            tableView.scrollEnabled = true
        }
    }
    
//    func imageCoordinatesInCell(indexPath: NSIndexPath) -> ParkTableViewCell{
//        
//        return cell
//    }
    
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












