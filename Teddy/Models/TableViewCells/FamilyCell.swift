//
//  FamilyCell.swift
//  Triage
//
//  Created by Tamer Bader on 5/31/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import UIKit

class FamilyCell: UITableViewCell {

    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
