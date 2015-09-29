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
        
//        var xOrigin : CGFloat = 0.0
//        for park in model.parksArray {
//            var yOrigin : CGFloat = 0.0
//            for photo in park.images {
//                let image = UIImage(named: "\(photo.imageName).jpg")
//                let imageView = UIImageView(image: image)
//                let frame = CGRect(x: xOrigin, y: yOrigin, width: view.frame.width, height: view.frame.height * 2.0)
//                yOrigin += imageView.bounds.height
//                imageView.frame = frame
//                myScrollView.addSubview(imageView)
//               
//                //myScrollView.contentSize =
//                
//                let currentWidth = imageView.frame.width
//                if currentWidth > largestImageWidths[park.parkNumber] {
//                    largestImageWidths[park.parkNumber] = currentWidth
//                }
//                
//            }
//            xOrigin += largestImageWidths[park.parkNumber]
//        }
        let viewSize = myScrollView.bounds.size
        for park in model.parksArray {
            
            let frame = CGRect(x: viewSize.width * CGFloat(park.parkNumber), y: 0.0, width: viewSize.width, height: viewSize.height)
            //let pageView = UIView(frame: frame)
            //myScrollView.addSubview(pageView)
            //Maybe pick color scheme
            //pageView.backgroundColor = UIColor.random()
            
            let firstImage = UIImage(named: "\(park.images[0].imageName).jpg")
            let imageView = UIImageView(image: firstImage)
            //imageView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight]
            //pageView.addSubview(imageView)
            
            imageView.frame = frame
            myScrollView.addSubview(imageView)
            //imageView.frame.width = pageView.frame.width
            //imageView.frame.origin = pageView.frame.origin
            
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            
            myScrollView.delegate = self
            myScrollView.minimumZoomScale = 1.0
            myScrollView.maximumZoomScale = 10.0
            
        }
        
//        let viewSize = myScrollView.bounds.size
//        for i in 0..<model.count() {
//            
//            let frame = CGRect(x: viewSize.width*(CGFloat(i)), y: 0.0, width: viewSize.width, height: viewSize.height)
//            let pageView = UIView(frame: frame)
//            myScrollView.addSubview(pageView)
//            pageView.backgroundColor = UIColor.random()
//            
//        }
        myScrollView.contentSize = CGSize(width: viewSize.width*CGFloat(model.numParks), height: viewSize.height)
        
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

