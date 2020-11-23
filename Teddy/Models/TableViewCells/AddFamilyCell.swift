//
//  AddFamilyCell.swift
//  Triage
//
//  Created by Tamer Bader on 5/31/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import UIKit

class AddFamilyCell: UITableViewCell {

    @IBOutlet weak var addMemberCellBorder: RectangularDashedView!
    @IBOutlet weak var addMemberButton: UIButton!
    weak var delegate: AddMemberCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func didTapAddMember(_ sender: UIButton) {
        self.delegate?.didTapAdd()
    }
    
}

protocol AddMemberCellDelegate: AnyObject {
    func didTapAdd()
}
