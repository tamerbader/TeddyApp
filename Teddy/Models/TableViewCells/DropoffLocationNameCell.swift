//
//  DropoffLocationNameCell.swift
//  Teddy
//
//  Created by Tamer Bader on 11/8/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import UIKit

class DropoffLocationNameCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var dropoffNumberView: UIView!
    @IBOutlet weak var dropoffNumberLabel: UILabel!
    @IBOutlet weak var dropoffSelectView: UIView!
    @IBOutlet weak var dropoffNameLabel: UILabel!
    @IBOutlet weak var dropoffCounterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Setup Cell UI
        dropoffNumberView.backgroundColor = UIColor.teddy_blue
        //dropoffNumberView.layer.masksToBounds = true
        print(dropoffNumberView.frame.height)
        print(dropoffNumberView.frame.width)
        print(dropoffNumberView.bounds.height)
        print(dropoffNumberView.bounds.width)
       // dropoffNumberView.layer.cornerRadius = (dropoffNumberView.frame.height / 2)
        print(dropoffNumberView.layer.cornerRadius)
       // dropoffNumberLabel.clipsToBounds = true
        
       // dropoffNumberView.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(withDropoff dropoff: Dropoff, atPosition position: Int) {
        self.dropoffNumberLabel.text = "\(position)"
        self.dropoffNameLabel.text = "\(dropoff.nickname)"
        
        self.dropoffCounterLabel.text = "⏱ \(dropoff.times.count) drop-off times"
        
    }

}
