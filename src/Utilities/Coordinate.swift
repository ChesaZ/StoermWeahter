//
//  Coordinate.swift
//  StoermWeather
//
//  Created by Jonas Gamburg on 23/07/2017.
//  Copyright © 2017 Jonas Gamburg. All rights reserved.
//

import Foundation

struct Coordinate {
    let latitude: Double
    let longtitude: Double
    let locationName: String
    
    init(latitude: Double, longtitude: Double, locationName: String) {
        self.latitude = latitude
        self.longtitude = longtitude
        self.locationName = locationName
    }
}

extension Coordinate: CustomStringConvertible {
    var description: String {
        return "\(latitude),\(longtitude), \(locationName)"
    }
}
