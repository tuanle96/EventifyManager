//
//  TicketsCell.swift
//  EventifyManager
//
//  Created by Lê Anh Tuấn on 1/5/18.
//  Copyright © 2018 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class TicketsCell: UITableViewCell {

    @IBOutlet weak var lblIdTicket: UILabel!
    @IBOutlet weak var lblTicketType: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblTimeCheckIn: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
