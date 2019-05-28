//
//  ViewController.swift
//  ExpandableTable
//
//  Created by Mohammad Arafat Hossain on 5/28/19.
//  Copyright © 2019 Mohammad Arafat Hossain. All rights reserved.
//

import UIKit

class FeedTableController: ExpandableTableController {
    @IBOutlet weak var table: UITableView! { didSet { self.tableView = table } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Expandable TableView"
        tableView?.register(GroupTabelCell.nib,
                            forCellReuseIdentifier: GroupTabelCell.reuseIdentifier)
        tableView?.register(NonGroupTabelCell.nib,
                            forCellReuseIdentifier: NonGroupTabelCell.reuseIdentifier)
        tableView?.register(PickerTableCell.nib,
                            forCellReuseIdentifier: PickerTableCell.reuseIdentifier)
        
        let firstModel = ExpandableModel(state: .collapsed,
                                         childrens: [ReusableCellType.mediumtext,
                                                     ReusableCellType.longtext,
                                                     ReusableCellType.shorttext,
                                                     NonExpandableModel(tittle: "Expendable cell, but here it's non-expandable cell",
                                                                        subtitle: "It is non expandable cell.",
                                                                        state: .collapsed)])
        let secondModel = ExpandableModel(state: .expanded,
                                          childrens: [ReusableCellType.picker])
        
        dataSource = [firstModel, secondModel]
        total = firstModel.rowCounts + secondModel.rowCounts
        
        addTableFooter(text: "This is Table Footer")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableFooterView?.updateLayout(with: tableView?.bounds.width ?? 0)
    }
    
    private var tableFooterView: ReusableHeaderFooter? {
        return tableView?.tableFooterView as? ReusableHeaderFooter
    }
    
    private func addTableFooter(text: String) {
        let footerView = ReusableHeaderFooter(text: text)
        tableView?.tableFooterView = footerView
    }
}

extension FeedTableController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return total }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var resourceCell = UITableViewCell()
        
        let (groupId, isGroupCell, actualPosition) = findGroup(indexPath.row)
        guard !isGroupCell else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: GroupTabelCell.reuseIdentifier, for: indexPath) as? GroupTabelCell {
                cell.configure(with: dataSource[groupId], andDelegate: self)
                resourceCell = cell
            }
            return resourceCell
        }
        
        let child = dataSource[groupId].childContainer[indexPath.row - actualPosition - 1]
        
        if let expandableItem = child as? ExpandableItem,
            let cell = tableView.dequeueReusableCell(withIdentifier: GroupTabelCell.reuseIdentifier, for: indexPath) as? GroupTabelCell {
            cell.configure(with: expandableItem, andDelegate: self)
            resourceCell = cell
        } else if let type = child as? ReusableCellType, type == .picker,
            let cell = tableView.dequeueReusableCell(withIdentifier: PickerTableCell.reuseIdentifier, for: indexPath) as? PickerTableCell {
            resourceCell = cell
        } else if let type = child as? ReusableCellType, type != .picker,
            let cell = tableView.dequeueReusableCell(withIdentifier: NonGroupTabelCell.reuseIdentifier, for: indexPath) as? NonGroupTabelCell {
            cell.configure(type.title ?? "", type.subtitle)
            resourceCell = cell
        }
        return resourceCell
    }
}

extension FeedTableController: GroupTableCellDelegate {
    func didEnableSetup(forSelected groupCell: UITableViewCell, with selectionState: Bool) {
        guard let indexPath = tableView?.indexPath(for: groupCell) else { return }
        let (groupId, isGroupCell, _) = findGroup(indexPath.row)
        guard isGroupCell else { return }
        
        tableView?.beginUpdates()
        updateCells(groupId, index: indexPath.row)
        tableView?.endUpdates()
    }
}
