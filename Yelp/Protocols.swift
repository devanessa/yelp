//
//  ToggleDelegate.swift
//  Yelp
//
//  Created by vli on 9/21/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import Foundation

protocol ToggleDelegate {
    func didSwitchToggle(cell: UITableViewCell)
}

protocol SearchParameterDelegate {
    func didSelectSearchWithParameters(params: [String: String])
}