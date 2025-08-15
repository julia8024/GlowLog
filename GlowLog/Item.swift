//
//  Item.swift
//  GlowLog
//
//  Created by 장세희 on 8/16/25.
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
