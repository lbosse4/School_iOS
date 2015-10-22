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

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!

    let model = Model.sharedInstance
    let locationManager = CLLocationManager()
    let initialLatitude = 40.7961
    let initialLongitude = -77.8628
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let initialLocation = CLLocation(latitude: initialLatitude, longitude: initialLongitude)
        centerMapOnLocation(initialLocation)
        
        mapView.addAnnotations(model.placesToPlot())
        mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if CLLocationManager.locationServicesEnabled()  {
            if CLLocationManager.authorizationStatus() == .NotDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func mapTypeSegmentedControlTriggered(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            
            mapView.mapType = MKMapType.Standard
        }
        else if sender.selectedSegmentIndex == 1{
            
            mapView.mapType = MKMapType.Satellite
        }
        else if sender.selectedSegmentIndex == 3{
            
            mapView.mapType = MKMapType.Hybrid
        }
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
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpanMake(0.01, 0.01))
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.regionThatFits(coordinateRegion)
    }


}

