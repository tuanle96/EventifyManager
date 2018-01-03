//
//  ListUserOrderCell.swift
//  EventifyManager
//
//  Created by Lê Anh Tuấn on 1/3/18.
//  Copyright © 2018 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class ListUserOrderCell: UITableViewCell {
    @IBOutlet weak var imgAva: UIImageView!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    var user: UserObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.imgAva.layer.cornerRadius = (self.imgAva.frame.width / 2)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
