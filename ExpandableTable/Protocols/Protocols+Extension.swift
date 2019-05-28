//
//  Protocols.swift
//  ExpandableTable
//
//  Created by Mohammad Arafat Hossain on 5/28/19.
//  Copyright © 2019 Mohammad Arafat Hossain. All rights reserved.
//

import UIKit

enum ExpandableState {
    case collapsed
    case expanded
}

protocol ExpandableItem {
    var state: ExpandableState { get set }
    var title: String { get }
    var subTitle: String? { get }
    var rowCounts: Int { get }
    var childContainer: [Any] { get }
}

protocol ReusableView: class {
    static var reuseIdentifier: String { get }
}

protocol ReusableViewNibLoading: ReusableView {
    static var nib: UINib { get }
}

// workaround: tableHeaderView doesn't support dynamic height
// we need to calculate it manually then set the tableHeaderView's height
protocol TableViewHeaderFooterViewResizing {
    func prepareAutoresizingMask()
    func updateLayout(with tableViewWidth: CGFloat)
}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension ReusableViewNibLoading {
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}

extension TableViewHeaderFooterViewResizing where Self: UIView {
    
    func prepareAutoresizingMask() {
        autoresizingMask = .flexibleWidth
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func updateLayout(with tableViewWidth: CGFloat) {
        // constraint layout with the width of table view
        // this will make sure the calculated size can fit into the table view
        let temporaryWidthConstraint = widthAnchor.constraint(equalToConstant: tableViewWidth)
        NSLayoutConstraint.activate([temporaryWidthConstraint])
        
        // calculate layout size
        let layoutSize = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        // remove width constraint (it's only needed for calculating the layout size)
        removeConstraint(temporaryWidthConstraint)
        
        // update header view size
        var updatedBounds = bounds
        updatedBounds.size.height = layoutSize.height
        bounds = updatedBounds
        // We need to activate here otherwise height will be broken.
        translatesAutoresizingMaskIntoConstraints = true
    }
}
