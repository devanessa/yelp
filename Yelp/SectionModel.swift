//
//  FilterModel.swift
//  Yelp
//
//  Created by vli on 9/20/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import Foundation

enum SectionType {
    case Collapsable, Toggle, MultiSelect
}

let MaxCollapsedElements = 5

class SectionModel {
    // Category, Sort by, Distance, Most Popular (offering a deal, open now)
    var headerName, apiKey: String!
    var filters: [FilterModel]! = [FilterModel]()
    var shouldExpand: Bool!
    var sectionType: SectionType!
    
    var selectedElement: FilterModel? // For types with radio buttons
    
    var isExpanded = false
    
    init(sectionType: SectionType, title: String, apiKey: String, filterValues: [String:String]!) {
        self.sectionType = sectionType
        self.headerName = title
        self.apiKey = apiKey
        
        for (name, searchParam) in filterValues {
            var newFilter = FilterModel(name: name, param: searchParam)
            filters.append(newFilter)
        }
        
        // Sort and order alphabetically for category list
        if sectionType == SectionType.MultiSelect {
            filters.sort({$0.labelName < $1.labelName})
        }
        
        shouldExpand = sectionType == SectionType.Collapsable
    }
    
    func getCollapsedNumberOfElements() -> Int {
        // Returns the number of elements for a collapsed section.
        // For Collapsable types, return 1, 
        // For other types, return the smaller of max collapsed number or
        // the number of total filters.
        if sectionType == SectionType.Collapsable {
            return 1
        } else {
            return min(MaxCollapsedElements, filters.count)
        }
    }
    
    func didSelectElement(element: Int) {
        println("Toggled \(filters[element].labelName)")
        if sectionType == SectionType.MultiSelect {
            filters[element].toggleSelected()
        } else if sectionType == SectionType.Collapsable {
            let previousSelected = selectedElement
            selectedElement = filters[element]
            selectedElement!.toggleSelected()
            if previousSelected != nil {
                previousSelected!.toggleSelected()
            }
        }
    }
    
    func getSelectedElements() -> [FilterModel] {
        var selectedElements = [FilterModel]()
        for filter in filters {
            if filter.selected! {
                selectedElements.append(filter)
            }
        }
        return selectedElements
    }
    
    func getSelectedParameters() -> NSArray? {
        // Return a list of parameter names
        return []
    }
}

class FilterModel {
    var selected: Bool!
    var labelName, searchParam: String!
    
    init(name: String, param: String) {
        labelName = name
        searchParam = param
        selected = false
    }
    
    func toggleSelected() {
        selected = !selected
    }
}

class FiltersViewModel {
    var sections: [SectionModel]!
    
    init() {
        buildFilterTable()
    }
    
    func buildFilterTable() {
        var categorySection = SectionModel(sectionType: SectionType.MultiSelect, title: "Category", apiKey: "category_filter", filterValues: ["American (New)": "newamerican", "American (Traditional)": "tradamerican", "Asian Fusian": "asianfusion", "Barbeque": "bbq", "Brazilian": "brazilian", "Breakfast & Brunch": "breakfast_brunch", "Burmese": "burmese", "Cafes": "cafes", "Caribbean": "caribbean", "Chinese": "chinese", "Cuban": "cuban", "Delis": "delis", "Ethipian": "ethiopian", "Fast Food": "hotdogs", "French": "french", "Gastropubs": "gastropubs", "German": "german", "Indian": "indian", "Japanese": "japanese", "Korean": "korean", "Mexican": "mexican", "Middle Eastern": "mideastern", "Pizza": "pizza", "Russian": "russian", "Sandwiches": "sandwiches", "Seafood": "seafood", "Spanish": "spanish", "Steakhouses": "steak", "Sushi": "sushi", "Taiwanese": "taiwanese", "Thai": "thai", "Vegetarian": "vegetarian", "Vietnamese": "vietnamese"])
        
        var sortBySection = SectionModel(sectionType: SectionType.Collapsable, title: "Sort By", apiKey: "sort", filterValues: ["Best Match": "0", "Distance": "1", "Highest Rated": "2"])
        
        var distanceSection = SectionModel(sectionType: SectionType.Collapsable, title: "Distance", apiKey: "radius_filter", filterValues: ["Auto": "auto", "1 mile": "\(milesToMeters(1))", "5 miles": "\(milesToMeters(5))", "10 miles": "\(milesToMeters(10))", "25 miles": "\(milesToMeters(25))"])
        
        var popularSection = SectionModel(sectionType: SectionType.Toggle, title: "Most Popular", apiKey: "", filterValues: ["Offering a Deal": "deals_filter"])
        
        sections = [popularSection, sortBySection, distanceSection, categorySection]
    }
    
    func getHeaderForSectionIdx(idx: Int) -> String {
        return sections[idx].headerName
    }
    
    func getNumRowsInSection(idx: Int) -> Int {
        let section = sections[idx]
        if section.isExpanded {
            return section.filters.count
        } else {
            return section.getCollapsedNumberOfElements()
        }
    }
    
    func getVisibleFilterLabelsForSection(idx: Int) -> [String] {
        var labels = [String]()
        
        let section = sections[idx]
        let numFilters = getNumRowsInSection(idx)
        
        if !section.isExpanded && section.sectionType == SectionType.Collapsable {
            if !section.getSelectedElements().isEmpty {
                return [section.getSelectedElements()[0].labelName]
            }
        }
        
        for i in 0..<numFilters {
            labels.append(section.filters[i].labelName)
        }
        
        if !section.isExpanded && (section.filters.count > MaxCollapsedElements) {
            // Hack to replace the last element with "See All"
            labels[numFilters-1] = "See All"
        }
        
        return labels
    }
    
    func didSelectRowAtIndexPath(indexPath: NSIndexPath) {
        let section = sections[indexPath.section]
        let isExpanded = section.isExpanded
        switch section.sectionType! {
        case SectionType.MultiSelect:
            // Only toggle for multi-select sections if the number of 
            // elements in the section exceeds MaxCollapsedElements
            if !isExpanded && indexPath.row == (MaxCollapsedElements-1) {
                sections[indexPath.section].isExpanded = !isExpanded
            } else {
                section.didSelectElement(indexPath.row)
            }
        case SectionType.Collapsable:
            // Maybe use radio buttons instead??
            sections[indexPath.section].isExpanded = !isExpanded
            if isExpanded {
                section.didSelectElement(indexPath.row)
            }
        case SectionType.Toggle:
            // Maybe this should only toggle when the toggle is actually touched
//            section.toggleSelectedForElement(indexPath.row)
            break
        }
        
    }
    
    func getRowAccessoryType(indexPath: NSIndexPath) -> UITableViewCellAccessoryType {
        let section = sections[indexPath.section]
        if section.sectionType == SectionType.MultiSelect && section.filters[indexPath.row].selected! {
            return UITableViewCellAccessoryType.Checkmark
        }
        return UITableViewCellAccessoryType.None
    }
}