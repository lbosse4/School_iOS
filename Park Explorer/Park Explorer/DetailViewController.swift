//
//  DetailViewController.swift
//  Park Explorer
//
//  Created by Lauren Bosse on 10/12/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var parkImageView: UIImageView!
    
    var imageDetail: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    var imageCaptionDetail: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        
        if let detail = self.imageDetail {
            if let imageView = self.parkImageView {
                imageView.image = UIImage(named: "\(detail.description).jpg")
                imageView.contentMode = UIViewContentMode.ScaleAspectFit
            }
        }
        
        if let captionDetail = self.imageCaptionDetail {
            if let label = self.captionLabel {
                label.text = captionDetail.description
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
}
