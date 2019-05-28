//
//  ExpandableTableView.swift
//  ExpandableTable
//
//  Created by Mohammad Arafat Hossain on 5/28/19.
//  Copyright © 2019 Mohammad Arafat Hossain. All rights reserved.
//

import UIKit

class ExpandableTableController: UIViewController {
    weak var tableView: UITableView?
    var total = 0 // The number of elements in the data source
    var dataSource: [ExpandableItem]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.estimatedRowHeight = 41
        tableView?.rowHeight = UITableView.automaticDimension
    }
    
    // Expand the cell at the index specified. - parameter index: The index of the cell to expand.
    func expandItemAtIndex(_ index: Int, group: Int) {
        // the data of the childs for the specific parent cell.
        let currentSubCategories = self.dataSource[group].childContainer
        // update the state of the cell.
        dataSource[group].state = .expanded
        
        // position to start to insert rows.
        var insertPos = index + 1
        let indexPaths = (0..<currentSubCategories.count).map { _ -> IndexPath in
            let indexPath = IndexPath(row: insertPos, section: 0)
            insertPos += 1
            return indexPath
        }
        tableView?.insertRows(at: indexPaths, with: .top)
        // update the total of rows
        total += currentSubCategories.count
    }
    
    // Collapse the cell at the index specified. - parameter index: The index of the cell to collapse
    func collapseSubItemsAtIndex(_ index: Int, group: Int) {
        
        var indexPaths = [IndexPath]()
        let currentSubCategories = self.dataSource[group].childContainer.count
        // update the state of the cell.
        dataSource[group].state = .collapsed
        
        // From selected cell+1 index to all children Index
        guard index + 1 <= index + currentSubCategories else { return }
        // create an array of NSIndexPath with the selected positions
        indexPaths = (index + 1...index + currentSubCategories).map { IndexPath(row: $0, section: 0) }
        
        // remove the expanded cells
        tableView?.deleteRows(at: indexPaths, with: .top)
        // update the total of rows
        total -= currentSubCategories
    }
    
    /**
     Update the cells to expanded to collapsed state in case of allow severals cells expanded.
     - parameter group: The group for the cell
     - parameter index:  The index of the cell.
     */
    func updateCells(_ group: Int, index: Int) {
        switch self.dataSource[group].state {
        case .expanded:
            collapseSubItemsAtIndex(index, group: group)
        case .collapsed:
            expandItemAtIndex(index, group: group)
        }
    }
    /**
     Find the parent position in the initial list, if the cell is parent and the actual position in the actual list.
     - parameter index: The index of the cell
     - returns: A tuple with the parent position, if it's a parent cell and the actual position righ now.
     */
    func findGroup(_ index: Int) -> (groupIndex: Int, isGroupCell: Bool, actualIndex: Int) {
        var position = 0, group = 0
        guard position < index else { return (group, true, group) }
        var item = dataSource[group]
        repeat {
            switch item.state {
            case .expanded:
                position += item.childContainer.count + 1
            case .collapsed:
                position += 1
            }
            group += 1
            if group < dataSource.count { // if is not outside of dataSource boundaries
                item = dataSource[group]
            }
        } while (position < index)
        if position == index { // if it's a parent cell the indexes are equal.
            return (group, position == index, position)
        }
        item = dataSource[group - 1]
        return (group - 1, position == index, position - item.childContainer.count - 1)
    }
}

