//
//  utils.swift
//  Yelp
//
//  Created by vli on 9/21/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import Foundation

func milesToMeters(mile: Int) -> Int {
    let val = mile * 1609.34
    return val
}

func metersToMiles(meters: Float) -> Float {
    let val = Float(meters) * 0.000621371
    return val
}