import Foundation
import SwiftData

class ModelContainerManager {
    static let shared = ModelContainerManager()
    
    lazy var container: ModelContainer? = {
        let schema = Schema([WardrobeItem.self])
        let config = ModelConfiguration("WardrobeApp", schema: schema)
        
        do {
            return try ModelContainer(for: schema, configurations: config)
        } catch {
            print("Failed to create container: \(error.localizedDescription)")
            return nil
        }
    }()
    
    private init() {}
}
