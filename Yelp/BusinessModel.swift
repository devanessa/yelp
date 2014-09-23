//
//  ReviewModel.swift
//  Yelp
//
//  Created by vli on 9/19/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import Foundation

class BusinessModel {
    var name, address, phone, categories: String!
    var numReviews: Int!
    var neighborhoods: NSArray!
    var distance: Float?
    var longitude, latitude: Float?
    
    var profileURL: String?
    var ratingURL: String!
    
    init(dictionary: NSDictionary){
        name = dictionary["name"] as String
        
        let locDict = dictionary["location"] as NSDictionary
        
        let fullAddress = locDict["display_address"] as NSArray
        address = fullAddress[0] as String
        
        if let hoods = locDict["neighborhoods"] as? NSArray {
            neighborhoods = hoods
        }
        
        if let coordinate = locDict["coordinate"] as? NSDictionary {
            longitude = coordinate["longitude"] as? Float
            latitude = coordinate["latitude"] as? Float
        }
        
        if let distanceInMeters = dictionary["distance"] as? Float {
            distance = metersToMiles(distanceInMeters)
        }
        
        if dictionary["display_phone"] != nil {
            phone = dictionary["display_phone"] as String
        }
        numReviews = dictionary["review_count"] as Int
        
        if dictionary["image_url"] != nil {
            profileURL = dictionary["image_url"] as? String
        }
        ratingURL = dictionary["rating_img_url"] as String
        
        let categoryArray = dictionary["categories"] as NSArray
        var displayNames = [String]()
        for category in categoryArray {
            let displayCategory = category[0] as String
            displayNames.append(displayCategory)
        }
        categories = ", ".join(displayNames)
    }
    
    class func resultsFromArray(results: NSArray) -> [BusinessModel] {
        var businesses = [BusinessModel]()
        for business in results {
            businesses.append(BusinessModel(dictionary: business as NSDictionary))
        }
        return businesses
    }

}