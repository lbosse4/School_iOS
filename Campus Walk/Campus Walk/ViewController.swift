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

class ViewController: UIViewController, BuildingInfoProtocol, buildingTableDelegateProtocol, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var showFavoritesButton: UIButton!
    @IBOutlet weak var trashCanButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backButtonView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nextButtonView: UIView!
    @IBOutlet weak var directionsView: UIView!
    @IBOutlet weak var directionsLabel: UILabel!
    @IBOutlet weak var ETALabel: UILabel!
    
    let model = Model.sharedInstance
    let locationManager = CLLocationManager()
    let initialLatitude = 40.7961
    let initialLongitude = -77.8628
    let initialSpanX : CLLocationDegrees = 0.01
    let initialSpanY : CLLocationDegrees = 0.01
    let zoomedSpanX : CLLocationDegrees = 0.0055
    let zoomedSpanY : CLLocationDegrees = 0.0055
    let animationDuration : NSTimeInterval = 1.5
    let latitudinalLocationDistance : CLLocationDistance = 2000
    let longitudinalLocationDistance : CLLocationDistance = 2000
    let overlayLineWidth : CGFloat = 4.0
    let calloutOffsetX = -5
    let calloutOffsetY = 5
    var isShowingFavorites = false
    var currentSelectedPin : Building?
    var stepByStepDirections :[MKRouteStep]? = nil
    var directionCount : Int = 0
    var directionResponse : MKDirectionsResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let initialLocation = CLLocation(latitude: initialLatitude, longitude: initialLongitude)
        centerMapOnLocation(initialLocation, spanX: initialSpanX, spanY: initialSpanY)
        
        mapView.delegate = self
        
        trashCanButton.hidden = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        directionsView.hidden = true
        
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
        let prefs = NSUserDefaults.standardUserDefaults()
        let mapType = prefs.stringForKey(UserDefaults.MapType)
        
        switch mapType! {
        case "Standard":
            mapView.mapType = MKMapType.Standard
        case "Satellite":
            mapView.mapType = MKMapType.Satellite
        case "Hybrid":
            mapView.mapType = MKMapType.Hybrid
        default:
            break
        }
        
        let showingFavorites = prefs.boolForKey(UserDefaults.ShowFavorites)
        isShowingFavorites = showingFavorites
        updateFavoriteButton(isShowingFavorites)
        
        view.bringSubviewToFront(directionsView)
        updatePins()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func directionCancelButtonPressed(sender: UIButton) {
        directionsView.hidden = true
        mapView.removeOverlays(mapView.overlays)
        updatePins()
    }
    
    @IBAction func directionNavButtonPressed(sender: UIButton) {
        switch sender.tag {
        case 0:
            directionCount++
            backButtonView.hidden = false
            backButton.hidden = false
            directionsLabel.text = stepByStepDirections![directionCount].instructions
            if directionCount + 1 == stepByStepDirections?.count {
                nextButton.hidden = true
                nextButtonView.hidden = true
            }

        case 1:
            directionCount--
            nextButton.hidden = false
            nextButtonView.hidden = false
            directionsLabel.text = stepByStepDirections![directionCount].instructions
            if directionCount - 1 < 0 {
                backButtonView.hidden = true
                backButton.hidden = true
            }
        default:
            break
        }
    }
    
    @IBAction func trashCanButtonPressed(sender: UIButton) {
        mapView.removeAnnotation(currentSelectedPin!)
        model.removeUserPlottedPin(currentSelectedPin!)
        currentSelectedPin = nil
        trashCanButton.hidden = true
    }
    
    @IBAction func currentLocationButtonPressed(sender: UIBarButtonItem) {
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func showFavoritesButtonPressed(sender: UIButton) {
        let prefs = NSUserDefaults.standardUserDefaults()
        
        isShowingFavorites = !isShowingFavorites
        prefs.setBool(isShowingFavorites, forKey: UserDefaults.ShowFavorites)
        prefs.synchronize()
        
        updateFavoriteButton(isShowingFavorites)
        
        updatePins()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "TableViewSegue":
            let destinationViewController = segue.destinationViewController as! BuildingTableViewController
            destinationViewController.delegate = self
        case "listDirectionsSegue":
            let listDirectionViewController = segue.destinationViewController as! ListedDirectionsViewController
            listDirectionViewController.directionResponse = directionResponse
        case "PreferencesSegue":
            break
        default:
            break
        }
    }
    
    func updatePins() {
        mapView.removeAnnotations(mapView.annotations)
        if isShowingFavorites{
            mapView.addAnnotations(model.favoriteBuildingsToPlot())
        }
        mapView.addAnnotations(model.userPlottedPinsToPlot())
    }
    
    func updateFavoriteButton(isShowing : Bool){
        if isShowing {
            let image = UIImage(named: "filledStar.png")
            showFavoritesButton.setImage(image, forState: .Normal)
        } else {
            let image = UIImage(named: "StarBarBackground.png")
            showFavoritesButton.setImage(image, forState: .Normal)
        }
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

        
        self.navigationController?.popViewControllerAnimated(true)
        CATransaction.commit()
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
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
                view.calloutOffset = CGPoint(x: calloutOffsetX, y: calloutOffsetY)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
            }
            
            if isShowingFavorites {
                if annotation.isFavorite {
                    view.image = UIImage(named: "StarPin.png")
                } else {
                    view.image = UIImage(named: "BluePin.png")
                }
            } else {
                view.image = UIImage(named: "BluePin.png")
            }
            
            return view
        }
        
        return nil
    }

    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if let currentSelectedPin = view.annotation as? Building {
            if !(currentSelectedPin.isFavorite) {
                trashCanButton.hidden = false
            }
        }
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        trashCanButton.hidden = true
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.greenColor()
            polylineRenderer.lineWidth = overlayLineWidth
            
            return polylineRenderer
        }
        
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let buildingInfoViewController = self.storyboard?.instantiateViewControllerWithIdentifier("buildingInformation") as! BuildingInformationViewController
        
        buildingInfoViewController.delegate = self
        buildingInfoViewController.building = view.annotation as? Building
        
        self.presentViewController(buildingInfoViewController, animated: true, completion: nil)
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

    func buildingInfoViewControllerDismissed(response: MKDirectionsResponse?, sourceBuilding: Building, destinationBuilding: Building, endTime: NSTimeInterval) {
        directionResponse = response

        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        let now = NSDate()
        let arrivalDate = now.dateByAddingTimeInterval(endTime)
        ETALabel.text = "ETA: \(String(dateFormatter.stringFromDate(arrivalDate)))"
        
        directionsView.hidden = false
        mapView.addAnnotation(sourceBuilding)
        mapView.addAnnotation(destinationBuilding)

        for route in (response?.routes)! {
            mapView.addOverlay(route.polyline)
            
            stepByStepDirections = route.steps
            directionCount = 0
            directionsLabel.text = stepByStepDirections![directionCount].instructions
            
            backButton.hidden = true
            backButtonView.hidden = true
            if directionCount+1 == stepByStepDirections?.count {
                nextButton.hidden = true
                nextButtonView.hidden = true
            }
        }

        let region = MKCoordinateRegionMakeWithDistance((response?.source.placemark.location?.coordinate)!, latitudinalLocationDistance, longitudinalLocationDistance)
        mapView.setRegion(region, animated: true)
        mapView.selectAnnotation(sourceBuilding, animated: true)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cancelChildViewController() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    
}

