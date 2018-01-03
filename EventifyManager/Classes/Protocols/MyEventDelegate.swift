//
//  MyEventDelegate.swift
//  EventifyManager
//
//  Created by Lê Anh Tuấn on 12/30/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import Foundation

protocol MyEventDelegate {
    func viewSummary(with event: EventObject) -> Void
    func checkIn(with event: EventObject) -> Void
}
