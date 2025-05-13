import Foundation
import SwiftData
import Foundation
import SwiftData

@Model
class WardrobeItem {
    var id: UUID
    var name: String
    var category: String
    var color: String
    var style: String
    var describe: String
    var dateAdded: Date
    var type: String
    var imagePath: String
    var isAvailable: Bool = true
    
    init(name: String, category: String, color: String, describe: String, style: String, type: String, imagePath: String, isAvailable: Bool = true) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.color = color
        self.dateAdded = Date()
        self.type = type
        self.describe = describe
        self.style = style
        self.imagePath = imagePath
        self.isAvailable = isAvailable
    }
}
