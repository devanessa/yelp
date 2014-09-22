//
//  FilterTableViewCell.swift
//  Yelp
//
//  Created by vli on 9/20/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var filterSwitch: UISwitch!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCellForState(sectionType: SectionType, isExpanded: Bool, accessoryType: UITableViewCellAccessoryType) {
        self.accessoryType = accessoryType
        
        if sectionType == SectionType.Toggle {
            // Add a toggle button here
            filterSwitch.hidden = false
            arrowImageView.hidden = true
        } else if sectionType == SectionType.MultiSelect {
            arrowImageView.hidden = true
            filterSwitch.hidden = true
            setSelected(true, animated: true)
        } else if sectionType == SectionType.Collapsable {
            if isExpanded {
                // Add radio buttons here
                arrowImageView.hidden = true
                filterSwitch.hidden = true
            } else {
                // Add a down arrow here
                arrowImageView.hidden = false
                filterSwitch.hidden = true
            }
        }
    }
    
    @IBAction func switchToggled(sender: AnyObject) {
        
    }
}
