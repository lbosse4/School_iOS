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
    
    var zoomScrollView = UIScrollView()
    var isZoomed = false
    
    private let insets = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        //TODO: Always Comment this out!!!!
        // Register cell classes
        //self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
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
    
    
    
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //collectionView.deselectItemAtIndexPath(indexPath, animated: false)
        collectionView.scrollEnabled = false
        
        let viewSize = view.bounds.size
        
        let zoomScrollViewFrame = CGRect(x: view.frame.origin.x, y: collectionView.frame.origin.y, width: viewSize.width, height: viewSize.height)
        zoomScrollView = UIScrollView(frame: zoomScrollViewFrame)
        view.addSubview(zoomScrollView)
        
        let image = UIImage(named: "\(model.imageNameAtIndexPath(indexPath)).jpg")
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ParkCollectionViewCell
        let imageFrame = cell.parkImageView.frame
        let convertedFrame = cell.parkImageView.convertRect(imageFrame, fromCoordinateSpace: cell.parkImageView!)
        let imageView = UIImageView(frame: convertedFrame)
        
        let frameInCell = cell.parkImageView.frame
        imageView.frame.origin.y += viewSize.height/CGFloat(2.0) - frameInCell.origin.y
        imageView.frame.origin.x -= 16.0
        
        imageView.image = image
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        zoomScrollView.addSubview(imageView)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "imageViewTapped:")
        tapRecognizer.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tapRecognizer)
        imageView.userInteractionEnabled = true

        //let frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y /*+ collectionView.contentOffset.y*/, width: viewSize.width, height: viewSize.height)
        UIView.animateWithDuration(3.0) { () -> Void in
            self.zoomScrollView.addSubview(imageView)
            imageView.frame = zoomScrollViewFrame
            
            self.collectionView?.bringSubviewToFront(self.zoomScrollView)
        }
        zoomScrollView.delegate = self
        zoomScrollView.minimumZoomScale = minZoomScale
        zoomScrollView.maximumZoomScale = maxZoomScale
        zoomScrollView.contentSize = viewSize
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
    
    func imageViewTapped(recognizer : UITapGestureRecognizer){
        if !isZoomed {
            //animate the image back here
            zoomScrollView.removeFromSuperview()
            collectionView!.scrollEnabled = true
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
