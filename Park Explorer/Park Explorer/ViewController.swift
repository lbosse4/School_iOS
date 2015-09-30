//
//  ViewController.swift
//  Park Explorer
//
//  Created by Lauren Bosse on 9/27/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    let model = Model()
    let minZoomScale : CGFloat = 1.0
    let maxZoomScale : CGFloat = 10.0
    let titleLabelHeight : CGFloat = 50.0
    let titleFont = "Bodoni 72 SmallCaps"
    let captionFont = "Bodoni 72"
    let titleFontSize : CGFloat = 55.0
    let captionFontSize : CGFloat = 30.0
    let titleBufferFromTop : CGFloat = 40.0
    let captionBuffer : CGFloat = 55.0
    let numCaptionLines = 2
    let captionHeight : CGFloat = 300.0
    let arrowAppearanceDuration = 1.25
    
    var arrowTimer : NSTimer?
    var previousOffset = CGPoint(x: 0.0,y: 0.0)
    var previousOrigin = CGPoint(x: 0.0, y: 0.0)
    var imageView : UIImageView?
    
    
    @IBOutlet weak var upArrowImageView: UIImageView!
    @IBOutlet weak var downArrowImageView: UIImageView!
    @IBOutlet weak var rightArrowImageView: UIImageView!
    @IBOutlet weak var leftArrowImageView: UIImageView!
    @IBOutlet var arrows: [UIImageView]!
    
    
    @IBOutlet weak var myScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //model.extractParkInformation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    override func viewDidLayoutSubviews() {
        configureScrollView()
    }
    
    func configureScrollView(){

        let viewSize = myScrollView.bounds.size
        var parkCounter = 0
        var maxPhotoCount = 0
        for park in model.parksArray {
            var photoCounter = 0
            for photo in park.images {
                
                let frame = CGRect(x: viewSize.width * CGFloat(parkCounter), y: viewSize.height * CGFloat(photoCounter), width: viewSize.width, height: viewSize.height)
                
                let firstImage = UIImage(named: "\(photo.imageName).jpg")
                let imageView = UIImageView(image: firstImage)
                
                imageView.frame = frame
                myScrollView.addSubview(imageView)
                
                imageView.contentMode = UIViewContentMode.ScaleAspectFit
                myScrollView.delegate = self
                myScrollView.minimumZoomScale = minZoomScale
                myScrollView.maximumZoomScale = maxZoomScale
                if (photoCounter > maxPhotoCount) {
                    maxPhotoCount = photoCounter
                }
                if photoCounter == 0 {
                    let titleFrame = CGRect(x: viewSize.width * CGFloat(parkCounter), y: titleBufferFromTop, width: viewSize.width, height: titleLabelHeight)
                    let titleLabel = UILabel(frame: titleFrame)
                    titleLabel.text = ("\(park.parkName)")
                    titleLabel.font = UIFont(name: titleFont, size: titleFontSize)
                    titleLabel.textAlignment = NSTextAlignment.Center
                    titleLabel.textColor = UIColor.whiteColor()
                    myScrollView.addSubview(titleLabel)
                    myScrollView.bringSubviewToFront(titleLabel)
                }
                
                let captionFrame = CGRect(x: viewSize.width * CGFloat(parkCounter), y: viewSize.height * CGFloat(photoCounter + 1) - imageView.frame.height/2 + captionBuffer, width: viewSize.width, height: captionHeight)
                let captionLabel = UILabel(frame: captionFrame)
                captionLabel.font = UIFont(name: captionFont, size: captionFontSize)
                captionLabel.text = photo.caption
                captionLabel.numberOfLines = numCaptionLines
                captionLabel.textColor = UIColor.whiteColor()
                captionLabel.textAlignment = NSTextAlignment.Center
                myScrollView.addSubview(captionLabel)
                
                photoCounter++
            }
            
            parkCounter++
        }
    
        myScrollView.contentSize = CGSize(width: viewSize.width * CGFloat(model.numParks), height: viewSize.height * CGFloat(maxPhotoCount + 1))
        myScrollView.directionalLockEnabled = true
        myScrollView.alwaysBounceHorizontal = false
        myScrollView.showsVerticalScrollIndicator = false
        myScrollView.showsHorizontalScrollIndicator = false
        
        for arrow in arrows {
            view.bringSubviewToFront(arrow)
            arrow.hidden = true
        }
        
    }
    
    func displayArrows(origin : CGPoint) {
        let pageWidth = myScrollView.bounds.size.width
        let parkNumber = Int(origin.x/pageWidth)
        let pageHeight = myScrollView.bounds.size.height
        let photoNumber = Int(origin.y/pageHeight)
        
        if parkNumber < model.numParks - 1 && photoNumber == 0{
            rightArrowImageView.hidden = false
        } else {
            rightArrowImageView.hidden = true
        }
        if parkNumber > 0 && photoNumber == 0 {
            leftArrowImageView.hidden = false
        } else {
            leftArrowImageView.hidden = true
        }
        
        if photoNumber != 0 {
            upArrowImageView.hidden = false
        } else {
            upArrowImageView.hidden = true
        }
        
        if photoNumber + 1 != model.parksArray[parkNumber].images.count {
            downArrowImageView.hidden = false
        } else {
            downArrowImageView.hidden = true
        }
        
    }
    
    func hideArrows(){
        for arrow in arrows {
            arrow.hidden = true
        }
    }
    
    // MARK:  Scrollview delegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews[0]
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let origin = myScrollView.contentOffset
        displayArrows(origin)
        if origin.y != 0{
            if origin.x - previousOrigin.x != 0 {
                let currentPageOrigin = previousOffset
                myScrollView.contentOffset = currentPageOrigin
            }
            
        }
        previousOrigin = origin
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        previousOffset = myScrollView.contentOffset
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let origin = myScrollView.contentOffset
        let viewSize = myScrollView.bounds.size
        let pageWidth = myScrollView.bounds.size.width
        let parkNumber = Int(origin.x/pageWidth)
        myScrollView.contentSize = CGSize(width: viewSize.width * CGFloat(model.numParks), height: viewSize.height * CGFloat(model.parksArray[parkNumber].images.count))
        
//        if let timer = arrowTimer {
//            timer.invalidate()
//            arrowTimer = nil
//        } else {
            arrowTimer = NSTimer.scheduledTimerWithTimeInterval(arrowAppearanceDuration,target: self, selector: "hideArrows", userInfo: nil, repeats: false)
        //}
    }

}

