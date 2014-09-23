//
//  YelpClient.swift
//  Yelp
//
//  Created by vli on 9/19/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import UIKit
import CoreLocation

func += <KeyType, ValueType> (inout left: Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}

class YelpClient: BDBOAuth1RequestOperationManager {
    var accessToken: String!
    var accessSecret: String!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        var baseUrl = NSURL(string: "http://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        
        var token = BDBOAuthToken(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    func searchWithParamDictionary(params: [String: String], success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {
        var parameters = params
        parameters["location"] = "San Francisco"
        return self.GET("search", parameters: parameters, success: success, failure: failure)
    }
    
    func doSearch(term: String, location: String = "San Francisco", coordinates: CLLocationCoordinate2D?, parameters: [String: String]?, success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {
        var params = ["term": term]
        if coordinates != nil {
            params["ll"] = "\(coordinates!.latitude),\(coordinates!.longitude)"
        } else {
            params["location"] = location
        }
        if parameters != nil {
            params += parameters!
        }
        
        println("search params: \(params)")
        return self.GET("search", parameters: params, success: success, failure: failure)
    }
}