//
//  DailyWeatherViewModel.swift
//  StoermWeather
//
//  Created by Jonas Gamburg on 04/08/2017.
//  Copyright © 2017 Jonas Gamburg. All rights reserved.
//

import Foundation
import UIKit

struct DailyWeatherViewModel {
    
    var days : [Day]
    
    
    init(model: DailyWeather) {
        
        days = [Day]()
        
        var count = 0
        while count < 6 {
            
            self.days.append(
                Day(
                    day: model.days[count].day,
                    maxTemp: "\(Int((model.days[count].temperatureMax - 32.0) * (5/9)))",
                    maxFeels: "\(Int((model.days[count].feelsLikeMax - 32.0) *  (5/9)))",
                    windSpeed: "\(model.days[count].windSpeed)km/h",
                    sunrise: "\(model.days[count].sunrise)",
                    sunset: "\(model.days[count].sunrise)",
                    humidity: "\(model.days[count].humidity)",
                    precipProbability: "\(model.days[count].precipProbability)",
                    summary: "\(model.days[count].summary)"
                )
            )
            count += 1
        }
    }
}

