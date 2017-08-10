//
//  AddLocVC.swift
//  StoermWeather
//
//  Created by Jonas Gamburg on 06/08/2017.
//  Copyright © 2017 Jonas Gamburg. All rights reserved.
//

import UIKit
import MapKit
import SwiftGifOrigin
import CoreLocation

class AddLocVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet var customAlertView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var currentLocationCoordinate: Coordinate? = nil
    var coordinate: Coordinate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.delegate = self
        getUserCurrentLocation()
        configureView()
        mapView.layer.cornerRadius = 15
        imageView.image = gifOn ? UIImage.gif(name: "g6") : UIImage(named: "g6")
        zoomToCurrentLocation(with: currentLocationCoordinate!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "homePanelVC" {
            //let homePanelVC = segue.destination as! HomePanelVC
            
            coordinatesArray.append(coordinate!)
            animateOut()
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        animateOut()
    }
    
    
    @IBAction func zoomToLocationnButtonPressed(_ sender: Any) {
        
        if addressTextField.text != "" {
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(addressTextField.text!) { (placemarks, error) in
                guard
                    let _ = placemarks,
                    let location = placemarks?.first?.location
                    else {
                        return
                }
                
                self.coordinate = Coordinate(
                    latitude: Double(location.coordinate.latitude),
                    longtitude: Double(location.coordinate.longitude),
                    locationName: self.addressTextField.text!)
                
                self.zoomToCurrentLocation(with: self.coordinate!)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    self.animateIn()
                })
            }
        } else {
            print("No address entered!")
        }
    }
    
    func animateIn() {
        //Animate In:
        self.view.addSubview(self.customAlertView)
        self.customAlertView.center = self.view.center
        self.customAlertView.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
        self.customAlertView.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            self.customAlertView.transform = .identity
            self.customAlertView.alpha = 1
        }
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.customAlertView.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
            self.customAlertView.alpha = 0
        }) { (success:Bool) in
            self.customAlertView.removeFromSuperview()
        }
    }
    
    func zoomToCurrentLocation(with coordinate: Coordinate) {
        let userLocation = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longtitude)
        let viewRegion = MKCoordinateRegionMakeWithDistance(userLocation, 500, 500)
        mapView.setRegion(viewRegion, animated: true)
        
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func configureView() {
        customAlertView.layer.cornerRadius = 7
        customAlertView.layer.shadowColor = UIColor.black.cgColor
        customAlertView.layer.shadowOpacity = 0.4
        customAlertView.layer.shadowOffset = CGSize(width: 0.0, height: 2.5)
    }
    
    
    // Location Stuff //
    //----------------//
    
    func getUserCurrentLocation() {
        getUserLocationAuthorization()
        let currentLocation = locationManager.location
        
        if currentLocation != nil {
            currentLocationCoordinate = Coordinate(
                latitude: (currentLocation?.coordinate.latitude)!,
                longtitude: (currentLocation?.coordinate.longitude)!,
                locationName: "Current Location")
        } else {
            print("Location was not authorized!")
            currentLocationCoordinate = Coordinate(
                latitude: 0.0,
                longtitude: 0.0,
                locationName: "Defaut Location")
        }
    }
    
    
    func addShadowWithOffset(to button: UIButton, _ width: Int, _ height: Int, _ radius: CGFloat, _ opacity: Float) {
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: width, height: height)
        button.layer.shadowRadius = radius
        button.layer.shadowOpacity = opacity
        
    }
    
    func getUserLocationAuthorization() -> Void {
        if CLLocationManager.authorizationStatus() == .notDetermined ||
            CLLocationManager.authorizationStatus() == .denied {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        getUserCurrentLocation()
    }
    
    func userHasAuthorized() -> Bool {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways: return true
        case .authorizedWhenInUse: return true
        case .denied: return false
        case .notDetermined: return false
        case .restricted: return false
            //default: return false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        addressTextField.resignFirstResponder()
    }
}
