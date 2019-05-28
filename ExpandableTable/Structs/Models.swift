//
//  File.swift
//  ExpandableTable
//
//  Created by Mohammad Arafat Hossain on 5/28/19.
//  Copyright © 2019 Mohammad Arafat Hossain. All rights reserved.
//

import Foundation



struct ExpandableModel: ExpandableItem {
    var state: ExpandableState
    var childContainer: [Any]
    
    var title: String {
        return "Expandable Cell"
    }
    
    var subTitle: String? {
        return "Expandable Cell always represent with Switch element, not necessarily it allows expansion."
    }
    
    init(state: ExpandableState, childrens: [Any]) {
        self.state = state
        childContainer = childrens
    }
    
    var rowCounts: Int {
        return (self.state == .expanded) ? childContainer.count + 1 : 1
    }
}

struct NonExpandableModel: ExpandableItem {
    var title: String
    var subTitle: String?
    
    var state: ExpandableState
    var childContainer: [Any]
    
    var rowCounts: Int {
        return childContainer.count
    }
    
    init(tittle: String, subtitle: String?, state: ExpandableState) {
        self.title = tittle
        self.subTitle = subtitle
        self.state = state
        self.childContainer = []
    }
}

enum ReusableCellType: String {
    case longtext = "longtext"
    case shorttext = "shortext"
    case mediumtext = "mediumtext"
    case picker = "picker"
    
    var title: String? {
        switch self {
        case .shorttext:
            return "Group"
        case .mediumtext:
            return "Expandable cell 01"
        case .longtext:
            return "This is Another usual child with long title and long subtitle."
        default:
            return nil
        }
    }
    
    var subtitle: String? {
        switch self {
        case .longtext:
            return "Objects are instances of the class. You will now learn how to create objects of a class in Ruby. You can create objects in Ruby by using the method new of the class"
        case .shorttext:
            return "Expandable cell number 01"
        case .mediumtext:
            return "This is Another usual child, this is another child."
        default:
            return nil
        }
    }
}
