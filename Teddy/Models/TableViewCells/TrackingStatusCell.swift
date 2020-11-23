//
//  TrackingStatusCell.swift
//  Triage
//
//  Created by Tamer Bader on 9/14/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import UIKit

class TrackingStatusCell: UITableViewCell {
    @IBOutlet weak var circleView: CircleView!
    @IBOutlet weak var childInitialLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dropoffReminderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
