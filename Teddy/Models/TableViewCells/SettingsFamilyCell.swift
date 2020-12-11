//
//  SettingsFamilyCell.swift
//  Teddy
//
//  Created by Tamer Bader on 12/6/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import UIKit

class SettingsFamilyCell: UITableViewCell {
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var circleProfileView: CircleView!
    @IBOutlet weak var familyMemberInitialLabel: UILabel!
    @IBOutlet weak var familyMemberNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
