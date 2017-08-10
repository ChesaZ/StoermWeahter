//
//  HomeScreenVC.swift
//  StoermWeather
//
//  Created by Jonas Gamburg on 04/08/2017.
//  Copyright © 2017 Jonas Gamburg. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftGifOrigin

class HomeScreenVC: UIViewController, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var addLocationButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuView: UIViewX!
    
    
    typealias sunriseset = (sunrise: String, sunset: String)
    
    
    let locationManager = CLLocationManager()
    let transition = CircularTransition()
    let client = DarkSkyAPIClient()
    
    var currentLocationCoordinate: Coordinate? = nil
    var sunriseset: sunriseset = (sunrise: "", sunset: "")
    var cellReferences = [WeatherCellCVC]()
    var keepr: CGRect = CGRect()
    var days = [Day]()
    
    //var gifOn = true
    //var celcius = true
    
    var daysWeatherCards = [
        WeatherCard("17º", "Monday"),
        WeatherCard("13º", "Tuesday"),
        WeatherCard("12º", "Wedensday"),
        WeatherCard("14º", "Thursday"),
        WeatherCard("15º", "Friday"),
        WeatherCard("18º", "Saturday")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        applyMotionEffect(to: collectionView, with: 3)
        
        gifImageView.image = gifOn ? UIImage.gif(name: "g6") : UIImage(named: "g6")
        
        closeMenuWith(sclaeX: 0.1, y: 0.1)
        setCurrentWeather(at: currentLocationCoordinate!)
    }
    
    @IBAction func menuPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            if self.menuView.transform == .identity {
                // menu is open
                self.closeMenuWith(sclaeX: 0.1, y: 0.1)
            } else {
                // menu is closed
                self.menuView.transform = .identity
            }
        })
    }
    
    func closeMenuWith(sclaeX valueX: CGFloat, y valueY: CGFloat) {
        menuView.transform = CGAffineTransform(scaleX: valueX, y: valueY)
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        closeMenuWith(sclaeX: 0.1, y: 0.1)
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addLoc" {
            print("Going to -> AddLocVC")
            UIView.animate(withDuration: 0.3, animations: {
                // Close menu
                self.closeMenuWith(sclaeX: 0.1, y: 0.1)
                
            })
            
            let addLocVC = segue.destination as! AddLocVC
            addLocVC.transitioningDelegate = self
            addLocVC.modalPresentationStyle = .custom
        }
    }
    
    func setCurrentWeather(at coordinate: Coordinate) {
        client.getCurrentWeather(at: coordinate) { (currentWeather, error) in
            if let currentWeather = currentWeather {
                let viewModel = CurrentWeatherViewModel(model: currentWeather)
                self.currentLocationLabel.text = coordinate.locationName
                
                if celcius {
                    self.feelsLikeLabel.text = "Feels Like: \(Int(viewModel.feelsLikeTemp))º"
                    self.tempLabel.text = "\(Int(viewModel.temperature))º"
                } else {
                    self.feelsLikeLabel.text = "Feels Like: \(self.celciusToFarenheit(temp: viewModel.feelsLikeTemp))"
                    self.tempLabel.text = "\(self.celciusToFarenheit(temp: viewModel.temperature))"
                }
                
                self.humidityLabel.text = viewModel.humidity
                self.rainLabel.text = viewModel.precepitationProbability
                self.windSpeedLabel.text = viewModel.wind
            }
        }
    }
    
    func setWeatherDaily(at  coordinate: Coordinate, to cell: WeatherCellCVC, at day: IndexPath) {
        client.getDailyWeather(at: coordinate) { (dailyWeather, error) in
            if let dailyWeather = dailyWeather {
                let viewModel = DailyWeatherViewModel(model: dailyWeather)
                
                self.sunriseset = (sunrise: ("Sunrise: \(dailyWeather.days[0].sunrise)"), sunset: ("Sunset: \(dailyWeather.days[0].sunset)"))
                
                cell.dayOfWeekLabel.text = viewModel.days[day.row].day
                cell.tempLabel.text = celcius ? "\(viewModel.days[day.row].maxTemp)º" : self.celciusToFarenheit(temp: Double(viewModel.days[day.row].maxTemp)!)
                
            }
        }
    }
    
    func celciusToFarenheit(temp: Double) -> String {
        let temp = Int(temp)
        
        return "\(temp * (9/5) + 32)º"
    }
    
    //  Collection View Delegatorismus  //
    //----------------------------------//
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(daysWeatherCards.count)
        return daysWeatherCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WeatherCellCVC
        
        configureCell(with: cell)
        
        //UNCOMMENT
        setWeatherDaily(
            at: currentLocationCoordinate != nil ? currentLocationCoordinate! : Coordinate(latitude: 0.0, longtitude: 0.0, locationName: "Default location"),
            to: cell,
            at: indexPath)
        
        cellReferences.append(cell)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell [\(indexPath.row)] selected.")
    }
    
    
    func configureCell(with cell: WeatherCellCVC) {
        cell.contentView.layer.cornerRadius = 7.0
        cell.contentView.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        cell.layer.shadowRadius = 1.0
        cell.layer.shadowOpacity = 0.1
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
    }
    
    func addShadowWithOffset(to button: UIButton, _ width: Double, _ height: Double, _ radius: CGFloat, _ opacity: Float) {
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: width, height: height)
        button.layer.shadowRadius = radius
        button.layer.shadowOpacity = opacity
        
    }
    
    //  Motion Effect for Collection View  //
    //-------------------------------------//
    
    func applyMotionEffect(to view: UIView, with magnitude: Float) {
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -magnitude
        xMotion.maximumRelativeValue = magnitude
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -magnitude
        yMotion.maximumRelativeValue = magnitude
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion, yMotion]
        
        view.addMotionEffect(group)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = editButton.center
        transition.circleColor = UIColor(colorLiteralRed: 79.0/255, green: 121/255, blue: 126/255, alpha: 1.0)
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = editButton.center
        transition.circleColor = UIColor(colorLiteralRed: 79.0/255, green: 121/255, blue: 126/255, alpha: 1.0)
        
        return transition
    }
}

extension HomeScreenVC: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedindex = round(index)
        
        offset = CGPoint(x: roundedindex * cellWidthIncludingSpacing - scrollView.contentInset.left , y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}
