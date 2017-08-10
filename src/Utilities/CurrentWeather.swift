//
//  CurrentWeather.swift
//  StoermWeather
//
//  Created by Jonas Gamburg on 22/07/2017.
//  Copyright © 2017 Jonas Gamburg. All rights reserved.
//

import Foundation

struct CurrentWeather {
    let windSpeed: Double
    let temperature: Double
    let feelsLike: Double
    let humidity: Double
    let precipitationProbability: Double
    let summary: String
    let icon: String
}

extension CurrentWeather {
    
    struct Key {
        static let temperature = "temperature"
        static let humidity = "humidity"
        static let precipitationProbability = "precipProbability"
        static let summary = "summary"
        static let icon = "icon"
        static let windSpeed = "windSpeed"
        static let feelsLike = "apparentTemperature"
    }
    
    init?(json: [String: AnyObject]) {
        guard let tempValue = json[Key.temperature] as? Double,
            let humidityValue = json[Key.humidity] as? Double,
            let precipitationProbability = json[Key.precipitationProbability] as? Double,
            let summaryValue = json[Key.summary] as? String,
            let iconValue = json[Key.icon] as? String,
            let windSpeedValue = json[Key.windSpeed] as? Double,
            let feelsLikeValue = json[Key.feelsLike] as? Double
    
            else { return nil }
        
        self.windSpeed = windSpeedValue
        self.temperature = tempValue
        self.feelsLike = feelsLikeValue
        self.humidity = humidityValue
        self.precipitationProbability = precipitationProbability
        self.summary = summaryValue
        self.icon = iconValue
    }
}
