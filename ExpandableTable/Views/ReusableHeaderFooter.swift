//
//  ReusableHeaderFooter.swift
//  ExpandableTable
//
//  Created by Mohammad Arafat Hossain on 5/28/19.
//  Copyright © 2019 Mohammad Arafat Hossain. All rights reserved.
//

import UIKit

public class ReusableHeaderFooter: UIView, TableViewHeaderFooterViewResizing {
    
    private weak var textLabel: UILabel!
    
    public init(text: String) {
        super.init(frame: .zero)
        prepareAutoresizingMask()
        setUp(with: text)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private struct Layout {
        static let verticalInset: CGFloat = 13
        static let horizontalInset: CGFloat = 16
    }
    
    private func setUp(with text: String) {
        let textLabel = UILabel(frame: .zero)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.numberOfLines = 0
        textLabel.text = text
        textLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .heavy)
        textLabel.textAlignment = .center
        addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: Layout.verticalInset),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Layout.verticalInset),
            textLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: Layout.horizontalInset),
            textLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -Layout.horizontalInset)
            ])
        
        self.textLabel = textLabel
    }
}
