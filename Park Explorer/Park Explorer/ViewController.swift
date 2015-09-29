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
    
    var imageView : UIImageView?
    var largestImageWidths = [CGFloat]()
    
    
    @IBOutlet weak var myScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //model.extractParkInformation()
        for var i = 0; i < model.numParks; i++ {
            largestImageWidths.append(0)
        }
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
                
                let captionFrame = CGRect(x: viewSize.width * CGFloat(parkCounter), y: viewSize.height * CGFloat(photoCounter + 1) - imageView.frame.height/2 + captionBuffer, width: viewSize.width, height: 300.0)
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
    
        myScrollView.contentSize = CGSize(width: viewSize.width * CGFloat(model.numParks), height: viewSize.height * CGFloat(maxPhotoCount))
        
    }
    
    // MARK:  Scrollview delegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews[0]
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
    //scrollview did end declerating
    //instance variable for where scrollview was previously
}
