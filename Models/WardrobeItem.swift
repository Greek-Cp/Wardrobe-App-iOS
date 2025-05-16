import Foundation
import SwiftData

enum ItemStatus: String, Codable {
    case available = "Available"
    case unavailable = "Unavailable"
    case rarelyUsed = "Rarely Used"
}

enum ItemAction: String, Codable {
    case use = "Use"
    case laundry = "Laundry"
    case repair = "Repair"
    case available = "Available"
}

@Model
class WardrobeItem {
    var id: UUID
    var name: String
    var category: String
    var colors: [String]
    var style: String
    var describe: String
    var dateAdded: Date
    var type: String
    var imagePath: String
    var status: String = ItemStatus.available.rawValue
    var lastUsed: Date?
    var lastAction: String?
    var lastActionDate: Date?
    
    var imagePaths: [String] {
        imagePath.split(separator: ",").map(String.init)
    }
    
    init(name: String, category: String, colors: [String], describe: String, style: String, type: String, imagePath: String, status: String = ItemStatus.available.rawValue) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.colors = colors
        self.dateAdded = Date()
        self.type = type
        self.describe = describe
        self.style = style
        self.imagePath = imagePath
        self.status = status
        self.lastUsed = nil
        self.lastAction = nil
        self.lastActionDate = nil
    }
}
