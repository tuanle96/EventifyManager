//
//  TicketOrderObject.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 11/10/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss

class TicketOrderObject: NSObject, Glossy {
    var id: String
    var informations: TicketObject?
    var QRCode: String?
    var QRCodeImgPath: String?
    var isCheckedIn: Bool?
    var timeCheckIn: String?
    
    override init() {
        self.id = ""
        super.init()
    }
    
    required init?(json: JSON) {
        
        guard let id: String = "_id" <~~ json else {
            return nil
        }
        
        self.id = id
        
        self.QRCodeImgPath = "QRCodePath" <~~ json
        self.QRCode = "QRCode" <~~ json
        
        if let informations: TicketObject = "informations" <~~ json {
            self.informations = informations
        }
        
        if let isCheckedIn: Bool = "isCheckedIn" <~~ json {
            self.isCheckedIn = isCheckedIn
        }
        
        if let timeCheckIn: String = "timeCheckIn" <~~ json {
            self.timeCheckIn = timeCheckIn
        }
    }
    
    //to json
    func toJSON() -> JSON? {
        
        return jsonify([
            "id" ~~> self.id,
            "QRCode" ~~> self.QRCode,
            "QRCodePath" ~~> self.QRCodeImgPath
            ])
    }
    
}
