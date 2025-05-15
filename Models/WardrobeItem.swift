import Foundation
import SwiftData

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
    var isAvailable: Bool = true
    
    var imagePaths: [String] {
        imagePath.split(separator: ",").map(String.init)
    }
    
    init(name: String, category: String, colors: [String], describe: String, style: String, type: String, imagePath: String, isAvailable: Bool = true) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.colors = colors
        self.dateAdded = Date()
        self.type = type
        self.describe = describe
        self.style = style
        self.imagePath = imagePath
        self.isAvailable = isAvailable
    }
}
