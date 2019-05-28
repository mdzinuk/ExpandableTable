//
/*
 Copyright (C) 2011-2017 Fiserv, Inc. or its affiliates. All rights reserved. This work,
 including its contents and programming, is confidential and its use is
 strictly limited. This work is furnished only for use by duly authorized
 licensees of Fiserv, Inc. or its affiliates, and their designated agents or
 employees responsible for installation or operation of the products. Any other
 use, duplication, or dissemination without the prior written consent of
 Fiserv, Inc. or its affiliates is strictly prohibited. Except as specified by
 the agreement under which the materials are furnished, Fiserv, Inc. and its
 affiliates do not accept any liabilities with respect to the information
 contained herein and are not responsible for any direct, indirect, special,
 consequential or exemplary damages resulting from the use of this information.
 No warranties, either express or implied, are granted or extended by this work
 or the delivery of this work.
 */

import UIKit

public protocol GroupTableCellDelegate: class {
    func didEnableSetup(forSelected groupCell: UITableViewCell, with selectionState: Bool)
}

class GroupTabelCell: UITableViewCell, ReusableViewNibLoading {
    @IBOutlet weak public var titleLabel: UILabel!
    @IBOutlet weak public var subTitleLabel: UILabel!
    @IBOutlet weak public var settingSwitch: UISwitch!

    weak public var delegate: GroupTableCellDelegate?

    override public func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = nil
        subTitleLabel.text = nil
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(with item: ExpandableItem, andDelegate: GroupTableCellDelegate?) {
        settingSwitch.isOn = item.state == .expanded
        titleLabel.text = item.title
        subTitleLabel.text = item.subTitle
        delegate = andDelegate
    }

    @IBAction func didChangeSwitchValue(_ sender: UISwitch) {
        delegate?.didEnableSetup(forSelected: self, with: sender.isOn)
    }
}
