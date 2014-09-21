//
//  ViewController.swift
//  Yelp
//
//  Created by vli on 9/19/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    let consumerKey = "x5eW27jw5Szc6mfmx8TEAw"
    let consumerSecret = "AyDNSyfnsWwlwHkN-JTV4KDVC8A"
    let token = "2DGMrky_6y7Uzr1ZSWOMnV8znszhRycK"
    let tokenSecret = "dt09uzOAtXO4cxpJ6YU4mjbTwdE"
    
    var client: YelpClient!
    var results: [BusinessModel] = []
//    var results: [NSDictionary]!
    
    @IBOutlet weak var tableView: UITableView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let searchBar = UISearchBar(frame: CGRectMake(-5.0, 0.0, 210, 44))
        searchBar.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        searchBar.searchBarStyle = UISearchBarStyle.Minimal
        let searchBarView = UIView(frame: CGRectMake(0.0, 0.0, 200.0, 44.0))
        
        let filterButton = UIBarButtonItem(title: "Filter", style: UIBarButtonItemStyle.Bordered, target: self, action: "filterButtonTouched:")
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        filterButton.setTitleTextAttributes(titleDict, forState: UIControlState.Normal)
        
        searchBarView.addSubview(searchBar)
        
        self.navigationItem.titleView = searchBarView
        self.navigationItem.leftBarButtonItem = filterButton
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        client = YelpClient(consumerKey: consumerKey, consumerSecret: consumerSecret, accessToken: token, accessSecret: tokenSecret)
        
        client.searchWithTerm("steak", success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
            let resultsDict = response as NSDictionary
            
            let businessResults = response["businesses"] as NSArray

            print(businessResults)
            
            self.results = BusinessModel.resultsFromArray(businessResults)
            
            self.tableView.reloadData()
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reviewCell") as BusinessTableViewCell
        
        let business = results[indexPath.row] as BusinessModel
        cell.businessLabel.text = business.name
        cell.addressLabel.text = business.address
        cell.reviewCountLabel.text = "\(business.numReviews) Reviews"
        
        cell.ratingImageView.setImageWithURL(NSURL(string: business.ratingURL))
        
        cell.businessImageView.alpha = 0.0
        cell.businessImageView.setImageWithURL(NSURL(string: business.profileURL))
        UIView.animateWithDuration(0.5, animations: {
            cell.businessImageView.alpha = 1.0
        })
        
        return cell
    }

}

