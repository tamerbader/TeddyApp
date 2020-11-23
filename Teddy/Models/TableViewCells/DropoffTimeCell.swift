//
//  DropoffTimeCell.swift
//  Triage
//
//  Created by Tamer Bader on 8/6/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import UIKit

class DropoffTimeCell: UITableViewCell {
    @IBOutlet weak var marker: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
    }

}
