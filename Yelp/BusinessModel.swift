//
//  ReviewModel.swift
//  Yelp
//
//  Created by vli on 9/19/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import Foundation

class BusinessModel {
    var name, address, phone: String!
    var numReviews: Int
    var neighborhoods: NSArray!
    var longitude, latitude: Float?
    
    var profileURL, ratingURL: String!
    
    init(dictionary: NSDictionary){
        name = dictionary["name"] as String
        
        let locDict = dictionary["location"] as NSDictionary
        
        let fullAddress = locDict["display_address"] as NSArray
        address = fullAddress[0] as String
        neighborhoods = locDict["neighborhoods"] as NSArray
        
        if let coordinate = locDict["coordinate"] as? NSDictionary {
            longitude = coordinate["longitude"] as? Float
            latitude = coordinate["latitude"] as? Float
        }
        
        phone = dictionary["display_phone"] as String
        numReviews = dictionary["review_count"] as Int
        
        profileURL = dictionary["image_url"] as String
        ratingURL = dictionary["rating_img_url"] as String
    }
    
    class func resultsFromArray(results: NSArray) -> [BusinessModel] {
        var businesses = [BusinessModel]()
        for business in results {
            businesses.append(BusinessModel(dictionary: business as NSDictionary))
        }
        return businesses
    }

}