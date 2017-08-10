//
//  WeatherCardVC.swift
//  StoermWeather
//
//  Created by Jonas Gamburg on 29/07/2017.
//  Copyright © 2017 Jonas Gamburg. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherCardVC: UIViewController, CLLocationManagerDelegate {
    
    //@IBOutlet weak var wallpaper: UIImageView!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentHumidityLabel: UILabel!
    @IBOutlet weak var currentPrecipitationLabel: UILabel!
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    @IBOutlet weak var currentSummaryLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var userAuth: Bool = false
    let client = DarkSkyAPIClient()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        getCurrentWeather()
        //print("\(currentTemperatureLabel.text!), \(currentSummaryLabel.text!)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func displayWeather(using viewModel: CurrentWeatherViewModel) {
        currentTemperatureLabel.text = "\(viewModel.temperature)º"
        currentHumidityLabel.text = viewModel.humidity
        currentPrecipitationLabel.text = viewModel.precepitationProbability
        currentSummaryLabel.text = viewModel.summary
        //currentWeatherIcon.image = viewModel.icon
    }
    
    @IBAction func getCurrentWeather() {
        toggleRefreshAnimation(on: true)
        let coordinate: Coordinate
        
        if userAuth {
            let currentLocation = locationManager.location
            let latitude = currentLocation?.coordinate.latitude
            let longtitude = currentLocation?.coordinate.longitude
            coordinate = Coordinate(latitude: latitude!, longtitude: longtitude!, locationName: "Current Location")
        } else {
            coordinate = Coordinate(latitude: 41.9028, longtitude: 12.4964, locationName: "Rome, Italy") //Rome, Italy as centre of the world
        }
        
        client.getCurrentWeather(at: coordinate) { [unowned self] currentWeather, error in
            if let currentWeather = currentWeather {
                let viewModel = CurrentWeatherViewModel(model: currentWeather)
                self.displayWeather(using: viewModel)
                self.toggleRefreshAnimation(on: false)
            }
        }
    }
    
    func toggleRefreshAnimation(on: Bool) {
        refreshButton.isHidden = on
        
        if on {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}
