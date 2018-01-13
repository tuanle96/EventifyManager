//
//  MyEventCell.swift
//  EventifyManager
//
//  Created by Lê Anh Tuấn on 12/29/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class MyEventCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var checkInView: UIView!
    
    var event: EventObject?
    var delegate: MyEventDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        summaryView.isHidden = true
        setUpUi()        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setUpUi() {
        self.cellView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.cellView.layer.shadowColor = UIColor.black.cgColor
        self.cellView.layer.shadowRadius = 4
        self.cellView.layer.shadowOpacity = 0.25
        self.cellView.layer.masksToBounds = false;
        self.cellView.clipsToBounds = false;
        
        self.summaryView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.summaryView.layer.shadowColor = UIColor.black.cgColor
        self.summaryView.layer.shadowRadius = 4
        self.summaryView.layer.shadowOpacity = 0.25
        self.summaryView.layer.masksToBounds = true;
        self.summaryView.clipsToBounds = true;
        self.summaryView.layer.borderWidth = 1
        self.summaryView.layer.borderColor = #colorLiteral(red: 0.3704946637, green: 0.7438001037, blue: 0.6115635633, alpha: 1).cgColor
        
        self.checkInView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.checkInView.layer.shadowColor = UIColor.black.cgColor
        self.checkInView.layer.shadowRadius = 4
        self.checkInView.layer.shadowOpacity = 0.25
        self.checkInView.layer.masksToBounds = true;
        self.checkInView.clipsToBounds = true;
        
        
    }
    @IBAction func btnViewSummaryClicked(_ sender: Any) {
        
        guard let event = self.event else {
            return
        }
        
        delegate?.viewSummary(with: event)
    }
    
    @IBAction func btnViewCheckInClicked(_ sender: Any) {
        
        guard let event = self.event else {
            return
        }
        
        delegate?.checkIn(with: event)
    }
}
