//
//  HomePanelVC.swift
//  StoermWeather
//
//  Created by Jonas Gamburg on 08/08/2017.
//  Copyright © 2017 Jonas Gamburg. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftGifOrigin

var coordinatesArray = [Coordinate]()
var selfLocSet = false
public var gifOn = true
public var celcius = true

class HomePanelVC: UIViewController, UIViewControllerTransitioningDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var locationsTableView: UITableView!
    @IBOutlet weak var settingsButton: UIButtonX!
    @IBOutlet weak var addLocationButton: UIButtonX!
    @IBOutlet weak var menuView: UIViewX!
    @IBOutlet weak var gifButton: UIButton!
    @IBOutlet weak var changeDegButton: UIButton!
    @IBOutlet weak var celciusButton: UIButton!
    @IBOutlet weak var weatherTV: UITableView!
    
    let transition = CircularTransition()
    let locationManager = CLLocationManager()
    let client = DarkSkyAPIClient()
    
    var currentLocationCoordinate: Coordinate? = nil
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        retrieveCurrentWeather()
        closeMenu()
        addShadowWithOffset(to: gifButton, 0.0, 2.5, 1, 0.7)
        addShadowWithOffset(to: changeDegButton, 0.0, 2.5, 1, 0.7)
        
        if gifOn {
            imageView.image = UIImage.gif(name: "g6")
        } else {
            imageView.image = UIImage(named: "1")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getUserLocationAuthorization()
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            if self.menuView.transform == .identity {
                // menu is opene
                self.closeMenu()
            } else {
                // menu is closed
                self.menuView.transform = .identity
                
            }
        })
    }
    
    @IBAction func celciusButtonPressed(_ sender: Any) {
    }
    
    @IBAction func gifButtonPressed(_ sender: Any) {
        if gifOn {
            
            self.gifButton.layer.shadowColor = UIColor.black.cgColor
            self.gifButton.layer.shadowOpacity = 0.3
            self.imageView.image = UIImage(named: "g6.gif")
            gifOn = false
        } else {

            self.gifButton.layer.shadowColor = UIColor(colorLiteralRed: 9 / 255, green: 213 / 255, blue: 217 / 255, alpha: 1).cgColor
            self.gifButton.layer.shadowOpacity = 0.7
            self.imageView.image = UIImage.gif(name: "g6")
            gifOn = true
        }
    }
    
    @IBAction func changeDegButtonPressed(_ sender: Any) {
        if celcius {
            
            self.changeDegButton.layer.shadowColor = UIColor.black.cgColor
            self.changeDegButton.layer.shadowOpacity = 0.3
            weatherTV.reloadData()
            celcius = false
        } else {
            
            self.changeDegButton.layer.shadowColor = UIColor(colorLiteralRed: 9 / 255, green: 213 / 255, blue: 217 / 255, alpha: 1).cgColor
            self.changeDegButton.layer.shadowOpacity = 0.7
            weatherTV.reloadData()
            celcius = true
        }
    }
    
    func addShadowWithOffset(to button: UIButton, _ width: Double, _ height: Double, _ radius: CGFloat, _ opacity: Float) {
        button.layer.shadowColor = UIColor(colorLiteralRed: 9 / 255, green: 213 / 255, blue: 217 / 255, alpha: 1).cgColor
        button.layer.shadowOffset = CGSize(width: width, height: height)
        button.layer.shadowRadius = radius
        button.layer.shadowOpacity = opacity
        
    }
    
    func celciusToFarenheit(temp: String) -> String {
        let temp = Int(temp)
        return "\(temp! * (9/5) + 32)º"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(coordinatesArray.count)
        return coordinatesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! weatherTBV
        
        setWeather(to: cell, with: indexPath)
        
        return cell
    }
    
    func setWeather(to cell: weatherTBV, with indexPath: IndexPath) {
        client.getCurrentWeather(at: coordinatesArray[indexPath.row]) { (currentWeather, error) in
            if let currentWeather = currentWeather {
                let viewModel = CurrentWeatherViewModel(model: currentWeather)
                
                cell.locationLabel.text = coordinatesArray[indexPath.row].locationName
                cell.coordinateLabel.text = "\(Double(round(coordinatesArray[indexPath.row].latitude * 1000) / 1000))ºN, \(Double(round(coordinatesArray[indexPath.row].longtitude * 1000) / 1000))ºE"
                
                cell.tempLabel.text = celcius ? "\(Int(viewModel.temperature))º" : "\(self.celciusToFarenheit(temp: "\(Int(viewModel.temperature))"))"
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // do magic
        index = indexPath.row
        performSegue(withIdentifier: "homeScreenVC", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // pressing on cell in the tableView
        // pass boolean value of swtich gif
        
        if segue.identifier == "homeScreenVC" {
            print("Going to -> HomeScreenVC")
            let homeScreenVC = segue.destination as! HomeScreenVC
            homeScreenVC.currentLocationCoordinate = coordinatesArray[index]
            homeScreenVC.transitioningDelegate = self
            homeScreenVC.modalPresentationStyle = .custom
        }
        
        if segue.identifier == "addLoc" {
            print("Going to -> AddLocVC")
            UIView.animate(withDuration: 0.3, animations: {
                self.closeMenu()
            })
            let addLocVC = segue.destination as! AddLocVC
            addLocVC.transitioningDelegate = self
            addLocVC.modalPresentationStyle = .custom
        }
    }
    
    func closeMenu() {
        menuView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    }
    
    
    func retrieveCurrentWeather() {
        if !selfLocSet {
            let currentLocation = locationManager.location
            let currentLocationCoordinate: Coordinate
            
            if currentLocation != nil {
                currentLocationCoordinate = Coordinate(
                    latitude: (currentLocation?.coordinate.latitude)!,
                    longtitude: (currentLocation?.coordinate.longitude)!,
                    locationName: "Current Location")
            }
                
            else {
                currentLocationCoordinate = Coordinate(latitude: 0.0, longtitude: 0.0, locationName: "Default Location")
            }
            
            self.currentLocationCoordinate = currentLocationCoordinate
            coordinatesArray.append(currentLocationCoordinate)
            
            selfLocSet = true
        }
        
    }
    
    
    //  Location Authrozations  //
    //--------------------------//
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //getUserLocationAuthorization()
        
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            print("Location Authorized!")
            
            //UNCOMMENT
            //retrieveWeatherForecast(withKey: ".currentLocation")
            
        } else {
            print("Location NOT authroized!")
        }
    }
    
    func getUserLocationAuthorization() -> Void {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
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
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presented is AddLocVC {
            transition.transitionMode = .present
            transition.startingPoint = addLocationButton.center
            transition.circleColor = UIColor(colorLiteralRed: 79.0/255, green: 121/255, blue: 126/255, alpha: 1.0)
        }
        
        if presented is HomeScreenVC {
            transition.transitionMode = .present
            transition.startingPoint = self.view.center
            transition.circleColor = UIColor(colorLiteralRed: 79.0/255, green: 121/255, blue: 126/255, alpha: 1.0)
        }
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed is AddLocVC {
            transition.transitionMode = .dismiss
            transition.startingPoint = addLocationButton.center
            transition.circleColor = UIColor(colorLiteralRed: 79.0/255, green: 121/255, blue: 126/255, alpha: 1.0)
        }
        
        if dismissed is HomeScreenVC {
            transition.transitionMode = .dismiss
            transition.startingPoint = self.view.center
            transition.circleColor = UIColor(colorLiteralRed: 79.0/255, green: 121/255, blue: 126/255, alpha: 1.0)
        }
        
        
        return transition
    }
}
