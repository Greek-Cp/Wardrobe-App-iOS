//
//  Item.swift
//  WardrobeApp1
//
//  Created by Mac on 08/05/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
