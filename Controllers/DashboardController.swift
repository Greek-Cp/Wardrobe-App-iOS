import Foundation
import SwiftData
import SwiftUI
import Combine

class DashboardController: ObservableObject {
    private var modelContext: ModelContext
    private var cancellables = Set<AnyCancellable>()
    
    // State properties
    @Published var searchText: String = ""
    @Published var selectedFilter: Int = 0
    @Published var items: [WardrobeItem] = []
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        
        // Setup publishers for state changes
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        $selectedFilter
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        self.updateStatusBasedOnLastUsed()
    }
    
    // Get all items
    func fetchItems() -> [WardrobeItem] {
        let descriptor = FetchDescriptor<WardrobeItem>()
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch items: \(error)")
            return []
        }
    }
    
    // Get filtered items based on search text and filter
    func getFilteredItems(items: [WardrobeItem]) -> [WardrobeItem] {
        let filtered = items.filter { item in
            if searchText.isEmpty {
                return true
            } else {
                return item.name.lowercased().contains(searchText.lowercased()) ||
                       item.category.lowercased().contains(searchText.lowercased())
            }
        }
        
        switch selectedFilter {
        case 1: // Available
            return filtered.filter { $0.status == ItemStatus.available.rawValue }
        case 2: // Unavailable
            return filtered.filter { $0.status == ItemStatus.unavailable.rawValue }
        case 3: // Rarely Used
            return filtered.filter { $0.status == ItemStatus.rarelyUsed.rawValue }
        default: // All
            return filtered
        }
    }
    
    // Helper function to get color from name
    func getColor(for name: String) -> Color {
        switch name.lowercased() {
        case "black": return .black
        case "white": return .white
        case "red": return .red
        case "blue": return .blue
        case "green": return .green
        case "yellow": return .yellow
        case "purple": return .purple
        case "gray": return .gray
        case "brown": return Color(red: 0.6, green: 0.4, blue: 0.2)
        default: return .gray
        }
    }
    
    // Delete item
    func deleteItem(_ item: WardrobeItem) {
        modelContext.delete(item)
        do {
            try modelContext.save()
            objectWillChange.send()
        } catch {
            print("Failed to delete item: \(error)")
        }
    }
    
    // Update item status
    func updateItemStatus(_ item: WardrobeItem, status: ItemStatus) {
        item.status = status.rawValue
        do {
            try modelContext.save()
            objectWillChange.send()
        } catch {
            print("Failed to update item status: \(error)")
        }
    }
    
    // Fungsi baru untuk memeriksa dan mengubah status berdasarkan lastUsed
       func updateStatusBasedOnLastUsed() {
           let today = Date()
           let calendar = Calendar.current
           
           // Ambil semua item
           let allItems = fetchItems()
           
           let format = DateFormatter()
           format.dateFormat = "yyyy-MM-dd HH:mm:ss"
           
           // Iterasi untuk memeriksa setiap item
           for item in allItems {
               // Pastikan lastUsed tidak nil
               if let lastUsed = item.lastUsed {
                   // Hitung selisih bulan antara lastUsed dan hari ini
                   let components = calendar.dateComponents([.month], from: lastUsed, to: today)
                   
//                  buat nyoba
//                   let dateString = "2023-11-13 09:12:22"
//                   item.lastUsed = format.date(from: dateString)
                   
                   
                   print("Last Used: \(item.lastUsed)")
                   if let monthsDifference = components.month, monthsDifference >= 2 {
                       // Ubah status menjadi rarelyUsed jika lebih dari 2 bulan
                       updateItemStatus(item, status: .rarelyUsed)
                   }
                   print("Status : \(item.status)")
               }
           }
       }
}
