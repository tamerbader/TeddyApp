//
//  AutoCompleteAddressCell.swift
//  Triage
//
//  Created by Tamer Bader on 6/7/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import UIKit

class AutoCompleteAddressCell: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressSubtitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
