//
//  ViewController.swift
//  Yelp
//
//  Created by vli on 9/19/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate, SearchParameterDelegate {

    let consumerKey = "x5eW27jw5Szc6mfmx8TEAw"
    let consumerSecret = "AyDNSyfnsWwlwHkN-JTV4KDVC8A"
    let token = "2DGMrky_6y7Uzr1ZSWOMnV8znszhRycK"
    let tokenSecret = "dt09uzOAtXO4cxpJ6YU4mjbTwdE"
    
    var client: YelpClient!
    var results: [BusinessModel] = []
    var searchBar: UISearchBar!
    var noMoreResults = false
    
    var searchParams = [String: String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    var userCoordinate: CLLocationCoordinate2D?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        searchBar = UISearchBar(frame: CGRectMake(-5.0, 0.0, 210, 44))
        searchBar.searchBarStyle = UISearchBarStyle.Minimal
        let searchBarView = UIView(frame: CGRectMake(0.0, 0.0, 200.0, 44.0))
        
        let filterButton = UIBarButtonItem(title: "Filter", style: UIBarButtonItemStyle.Bordered, target: self, action: "filterButtonTouched")
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        filterButton.setTitleTextAttributes(titleDict, forState: UIControlState.Normal)
        
        searchBarView.addSubview(searchBar)
        
        navigationItem.titleView = searchBarView
        navigationItem.leftBarButtonItem = filterButton
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120.0
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        client = YelpClient(consumerKey: consumerKey, consumerSecret: consumerSecret, accessToken: token, accessSecret: tokenSecret)
        doSearchWithParams(searchParams)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if noMoreResults {
            return results.count
        } else {
            return results.count + 1
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == self.results.count {
            let cell = tableView.dequeueReusableCellWithIdentifier("spinnerCell") as UITableViewCell
            if !noMoreResults {
                doSearchWithParams(searchParams)
            } else {
                tableView.reloadData()
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("reviewCell") as BusinessTableViewCell
            // let del
            let business = results[indexPath.row] as BusinessModel
            cell.businessLabel.text = business.name
            cell.addressLabel.text = "\(business.address), \(business.neighborhood)"
            cell.reviewCountLabel.text = "\(business.numReviews) Reviews"

            cell.ratingImageView.setImageWithURL(NSURL(string: business.ratingURL))
            
            cell.businessImageView.alpha = 0.0

            if business.distance != nil {
                cell.distanceLabel.text = String(format: "%.2f mi", business.distance!)
            } else {
                cell.distanceLabel.text = ""
            }
            if business.profileURL != nil {
                cell.businessImageView.setImageWithURL(NSURL(string: business.profileURL!))
                UIView.animateWithDuration(0.2, animations: {
                    cell.businessImageView.alpha = 1.0
                })
            } else {
                cell.businessImageView.image = UIImage(named: "blackyelp.png")
            }
            cell.categoriesLabel.text = business.categories
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        searchBar.resignFirstResponder()
        view.endEditing(true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func doSearchWithParams(params: [String: String]) {
        var term = "restaurants"
        if searchBar.text != "" {
            term = searchBar.text
        }
        let offset = self.results.count
        client.doSearch(term, offset: offset, coordinates: userCoordinate, parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let resultsDict = response as NSDictionary
            
            let businessResults = response["businesses"] as NSArray
//            
//            print(businessResults)
            if businessResults.count > 0 {
                self.results += BusinessModel.resultsFromArray(businessResults)
            } else {
                self.noMoreResults = true
            }
            self.tableView.reloadData()
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        })

    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let latitude = manager.location.coordinate.latitude
        let longitude = manager.location.coordinate.longitude
        userCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location " + error.localizedDescription)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        view.endEditing(true)
        clearSearchResults()
        // perform search
        doSearchWithParams(searchParams)
    }
    
    func filterButtonTouched() {
        println("Filter button pressed")
        self.performSegueWithIdentifier("filterSegue", sender: tableView)
    }
    
    func didSelectSearchWithParameters(params: [String: String]) {
        clearSearchResults()
        searchParams = params
        doSearchWithParams(params)
    }
    
    func clearSearchResults() {
        self.results = []
        self.noMoreResults = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "filterSegue") {
            var filterViewController = segue.destinationViewController as FilterViewController
            filterViewController.delegate = self
        }
    }
}

