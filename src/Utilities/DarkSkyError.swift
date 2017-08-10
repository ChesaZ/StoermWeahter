//
//  DarkSkyError.swift
//  StoermWeather
//
//  Created by Jonas Gamburg on 23/07/2017.
//  Copyright © 2017 Jonas Gamburg. All rights reserved.
//

import Foundation

enum DarkSkyError : Error {
    case requestFailed
    case responseUnsuccessful
    case invalidData
    case jsonConversionFailure
    case invalidUrl
    case jsonParsingFailure
}
