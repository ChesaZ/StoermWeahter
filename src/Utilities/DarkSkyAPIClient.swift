//
//  DarkSkyAPIClient.swift
//  StoermWeather
//
//  Created by Jonas Gamburg on 23/07/2017.
//  Copyright © 2017 Jonas Gamburg. All rights reserved.
//

import Foundation

class DarkSkyAPIClient {
    
    let apiKey = "XXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    
    lazy var baseUrl: URL = {
        return URL(string: "https://api.darksky.net/forecast/\(self.apiKey)/")!
    }()
    
    let downloader = JSONDownloader()
    
    typealias CurrentWeatherCompletionHandler = (CurrentWeather?, DarkSkyError?) -> Void
    typealias DailyWeatherCompletionHandler = (DailyWeather?, DarkSkyError?) -> Void

    
    func getDailyWeather(at coordinate: Coordinate, completionHandler completion: @escaping DailyWeatherCompletionHandler) {
        print("Daily: \(coordinate.description)")
        
        guard let url = URL(string: "\(coordinate.latitude),\(coordinate.longtitude)", relativeTo: baseUrl) else {
            completion(nil, .invalidUrl)
            return
        }
        
        
        let request = URLRequest(url: url)
        
        let task = downloader.jsonTask(with: request) { json, error in
            
            //running asynchronous stuff on the main thread, use this method!
            //if you're on a background queue and you want to make changes to the UI call this method.
            DispatchQueue.main.async {
                guard let json = json else {
                    completion(nil, error)
                    return
                }
                
                //print(json["daily"] as? [String: AnyObject]!)
                
                guard let dailyWeatherJson = json["daily"] as? [String: AnyObject],
                        let dailyWeather = DailyWeather(json: dailyWeatherJson) else {
                    completion(nil, .jsonParsingFailure)
                    return
                }
                
                completion(dailyWeather, nil)
            }
        }
        
        task.resume()
        
    }

    func getCurrentWeather(at coordinate: Coordinate, completionHandler completion: @escaping CurrentWeatherCompletionHandler) {
        print("Current: \(coordinate.description)")
        
        guard let url = URL(string: "\(coordinate.latitude),\(coordinate.longtitude)", relativeTo: baseUrl) else {
            completion(nil, .invalidUrl)
            return
        }
        
        
        let request = URLRequest(url: url)
        
        let task = downloader.jsonTask(with: request) { json, error in
            
            //running asynchronous stuff on the main thread, use this method!
            //if you're on a background queue and you want to make changes to the UI call this method.
            DispatchQueue.main.async {
                guard let json = json else {
                    completion(nil, error)
                    return
                }
          
                guard let currentWeatherJson = json["currently"] as? [String: AnyObject], let currentWeather = CurrentWeather(json: currentWeatherJson) else {
                    completion(nil, .jsonParsingFailure)
                    return
                }
                
                completion(currentWeather, nil)
            }
        }
        
        task.resume()
        
    }
}
