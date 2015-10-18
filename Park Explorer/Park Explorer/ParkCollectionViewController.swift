//
//  ParkCollectionViewController.swift
//  Park Explorer
//
//  Created by Lauren Bosse on 10/5/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ParkCollectionCell"

class ParkCollectionViewController : UICollectionViewController{
    let model = Model.sharedInstance
    let minZoomScale : CGFloat = 1.0
    let maxZoomScale : CGFloat = 10.0
    let animationDuration : NSTimeInterval = 1.5
    
    var selectedIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    var zoomScrollView = UIScrollView(frame: CGRectZero)
    var isZoomed = false
    
    private let insets = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
     
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return model.numberOfParks()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return model.imageCountForPark(section)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ParkCollectionViewCell
        
        let image = UIImage(named: "\(model.imageNameAtIndexPath(indexPath)).jpg")
        
        cell.parkImageView.image = image
        cell.parkImageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        return cell
    }

    
    
    //USE view NOT collectionView EMMA SAID THAT WOULD FIX IT 
    
    
    
    func parkImageFrameLocationInCell(indexPath: NSIndexPath) -> CGRect {
        let cell = collectionView!.cellForItemAtIndexPath(selectedIndexPath) as! ParkCollectionViewCell
        let imageFrame = cell.parkImageView.frame
        let convertedFrame = view.convertRect(imageFrame, fromCoordinateSpace: cell.contentView)
        return convertedFrame
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: false)
        collectionView.scrollEnabled = false
        selectedIndexPath = indexPath
        
        let viewSize = view.bounds.size
        
        zoomScrollView = UIScrollView(frame: CGRectZero)
        zoomScrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        view.addSubview(zoomScrollView)
        
        let image = UIImage(named: "\(model.imageNameAtIndexPath(indexPath)).jpg")
        let convertedFrame = parkImageFrameLocationInCell(indexPath)
        let imageView = UIImageView(image: image)
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        imageView.frame = zoomScrollView.bounds
        zoomScrollView.addSubview(imageView)
        zoomScrollView.frame = convertedFrame
        zoomScrollView.contentSize = convertedFrame.size
        zoomScrollView.showsVerticalScrollIndicator = false
        zoomScrollView.showsHorizontalScrollIndicator = false
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "imageViewTapped:")
        tapRecognizer.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tapRecognizer)
        imageView.userInteractionEnabled = true

        UIView.animateWithDuration(animationDuration){ () -> Void in
            self.zoomScrollView.frame = self.view.bounds
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
                    self.collectionView?.scrollEnabled = true
            })
        }
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "CollectionHeader", forIndexPath: indexPath) as! ParkCollectionReusableView
            headerView.sectionLabel.text! = model.parkNameForSection(indexPath.section)
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return insets
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
