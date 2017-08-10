//
//  WeatherCard.swift
//  StoermWeather
//
//  Created by Jonas Gamburg on 05/08/2017.
//  Copyright © 2017 Jonas Gamburg. All rights reserved.
//

import Foundation

struct WeatherCard {
    let temp: String
    let day: String
    
    init(_ temp: String, _ day: String) {
        self.temp = temp
        self.day = day
    }
}
