//
//  FilterViewController.swift
//  Yelp
//
//  Created by vli on 9/20/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var filterTableView: UITableView!
    
    let filterViewModel = FiltersViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterTableView.delegate = self
        filterTableView.dataSource = self
        filterTableView.rowHeight = 50
        filterTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return filterViewModel.sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterViewModel.getNumRowsInSection(section)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = UIView(frame: CGRect(x:0, y:0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = UIColor(white: 0.8, alpha: 0.6)
        var headerLabel = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.frame.width, height: 50))
        headerLabel.text = filterViewModel.getHeaderForSectionIdx(section)
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("filterCell") as FilterTableViewCell
        let section = filterViewModel.sections[indexPath.section]
        let labels = filterViewModel.getVisibleFilterLabelsForSection(indexPath.section)
        
        cell.filterLabel.text = labels[indexPath.row]
        cell.setCellForState(section.sectionType, isExpanded: section.isExpanded, accessoryType: filterViewModel.getRowAccessoryType(indexPath))

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        filterViewModel.didSelectRowAtIndexPath(indexPath)
        tableView.flashScrollIndicators()
        
        tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
}
