//
//  BarberCell.swift
//  Kurly
//
//  Created by Ahmad Medhat on 01/09/2021.
//

import UIKit

class BarberCell: UITableViewCell {

    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var serviceSwich: UISwitch!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    @IBAction func switchPressed(_ sender: UISwitch) {
        
    }
    
    
    
    
    
}
