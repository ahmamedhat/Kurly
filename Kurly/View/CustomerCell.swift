//
//  CustomerCell.swift
//  Kurly
//
//  Created by Ahmad Medhat on 30/08/2021.
//

import UIKit

class CustomerCell: UITableViewCell {

    @IBOutlet weak var customerBubble: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customerBubble.layer.cornerRadius = customerBubble.frame.size.height / 5
        serviceLabel.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
