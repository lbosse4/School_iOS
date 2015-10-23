//
//  ViewController.swift
//  Campus Walk
//
//  Created by Lauren Bosse on 10/19/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, buildingTableDelegateProtocol, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var showFavoritesButton: UIButton!

    let model = Model.sharedInstance
    let locationManager = CLLocationManager()
    let initialLatitude = 40.7961
    let initialLongitude = -77.8628
    let initialSpanX : CLLocationDegrees = 0.01
    let initialSpanY : CLLocationDegrees = 0.01
    let zoomedSpanX : CLLocationDegrees = 0.0055
    let zoomedSpanY : CLLocationDegrees = 0.0055
    let animationDuration : NSTimeInterval = 3.0
    
    var isShowingFavorites = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let initialLocation = CLLocation(latitude: initialLatitude, longitude: initialLongitude)
        centerMapOnLocation(initialLocation, spanX: initialSpanX, spanY: initialSpanY)
        
        //mapView.addAnnotations(model.placesToPlot())
        //mapView.addAnnotations(model.favoriteBuildingsToPlot())
        
        mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.navigationItem.rightBarButtonItem = MKUserTrackingBarButtonItem(mapView: mapView)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if CLLocationManager.locationServicesEnabled()  {
            if CLLocationManager.authorizationStatus() == .NotDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateFavoritePins()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func mapTypeSegmentedControlTriggered(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.mapType = MKMapType.Standard
        case 1:
            mapView.mapType = MKMapType.Satellite
        case 2:
            mapView.mapType = MKMapType.Hybrid
        default:
            break
        }
    }
    
    @IBAction func currentLocationButtonPressed(sender: UIBarButtonItem) {
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func showFavoritesButtonPressed(sender: UIButton) {
        isShowingFavorites = !isShowingFavorites
        if isShowingFavorites {
            let image = UIImage(named: "filledStar.png")
            showFavoritesButton.setImage(image, forState: .Normal)
            updateFavoritePins()
        } else {
            let image = UIImage(named: "StarBarBackground.png")
            showFavoritesButton.setImage(image, forState: .Normal)
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotations(model.userPlottedPinsToPlot())
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "TableViewSegue":
            let destinationViewController = segue.destinationViewController as! BuildingTableViewController
            destinationViewController.delegate = self
        default:
            break
        }
    }
    
    func updateFavoritePins() {
        mapView.removeAnnotations(mapView.annotations)
        if isShowingFavorites{
            mapView.addAnnotations(model.favoriteBuildingsToPlot())
        }
        mapView.addAnnotations(model.userPlottedPinsToPlot())
    }
    
    func plotBuilding(building: Building){
        CATransaction.begin()
        CATransaction.setCompletionBlock { () -> Void in
            self.mapView.addAnnotation(building)
            let location = CLLocation(latitude: building.coordinate.latitude, longitude: building.coordinate.longitude)
            UIView.animateWithDuration(self.animationDuration) { () -> Void in
                self.centerMapOnLocation(location, spanX: self.zoomedSpanX, spanY: self.zoomedSpanY)
            }
            self.model.addUserAddedPin(building)
        }
//        let completionBlock = {() in
//            self.mapView.addAnnotation(building)
//            let location = CLLocation(latitude: building.coordinate.latitude, longitude: building.coordinate.longitude)
//            UIView.animateWithDuration(self.animationDuration) { () -> Void in
//                self.centerMapOnLocation(location, spanX: self.zoomedSpanX, spanY: self.zoomedSpanY)
//            }
//            self.model.addUserAddedPin(building)
//        }
      //  let count = self.navigationController?.viewControllers.count
       // self.navigationController?.viewControllers[count! - 2]
        //dismissViewControllerAnimated(true, completion: nil)
        //self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
        
        CATransaction.commit()
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            let view = MKAnnotationView()
            view.image = UIImage(named: "BluePin.png")
            return view
        }
        
        if let annotation = annotation as? Building {
            let identifier = "pin"
            var view: MKAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
            }
            
            if annotation.isFavorite {
                view.image = UIImage(named: "StarPin.png")
            } else {
                view.image = UIImage(named: "BluePin.png")
            }
            return view
        }
        
        return nil
    }

    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        } else {
            mapView.showsUserLocation = false
            locationManager.stopUpdatingLocation()
        }
    }
    
    func centerMapOnLocation(location: CLLocation, spanX: CLLocationDegrees, spanY: CLLocationDegrees) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.regionThatFits(coordinateRegion)
    }


}

