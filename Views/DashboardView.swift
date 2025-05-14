import SwiftUI

import Foundation
import SwiftData
import SwiftUI

struct SearchBarViewApp: View {
    @Binding var text: String
    
    var body: some View {
        TextField("Search", text: $text)
            .padding(10)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .overlay(
                HStack {
                    Spacer()
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.trailing, 10)
                }
            )
            .padding(.horizontal)
    }
}


struct ItemCardView: View {
    let item: WardrobeItem
    
    var body: some View {
        NavigationLink(destination: DetailItemView(item: item)) {
            VStack(alignment: .leading) {
                // Gambar
                if let uiImage = UIImage(named: item.imagePath) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 150)
                        .clipped()
                        .cornerRadius(8)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 150)
                        .cornerRadius(8)
                }
                
                // Nama item + badge dalam satu baris
                HStack (alignment: .top){
                    Text(item.name.count > (item.isAvailable ? 17 : 10)
                         ? String(item.name.prefix(item.isAvailable ? 17 : 10)) + "…"
                         : item.name)
                    .font(.headline)
                    Spacer()
                    if !item.isAvailable {
                        Text("N/A")
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.top, 4)
                // Kategori item & gaya
                HStack {
                    Text(item.category)
                    Text(", \(item.style)")
                }
                .font(.subheadline)
                .foregroundColor(.gray)
                
                .padding(8)
                .background(Color.white)
                .cornerRadius(12)
            }
        }
        .buttonStyle(PlainButtonStyle()) // Opsional untuk menghilangkan style tombol default
    }
}

struct DashboardView: View {
    @State private var searchText = ""
    @State private var selectedFilter = 0
    
    private var allItems: [WardrobeItem] = PreviewSampleData.createSampleItems()
    
    // Filtered items based on search text and selected filter
    var filteredItems: [WardrobeItem] {
        let filtered = allItems.filter { item in
            if searchText.isEmpty {
                return true
            } else {
                return item.name.lowercased().contains(searchText.lowercased()) ||
                       item.category.lowercased().contains(searchText.lowercased())
            }
        }
        
        // Apply filter based on availability
        switch selectedFilter {
        case 1: // Available
            return filtered.filter { $0.isAvailable }
        case 2: // Unavailable
            return filtered.filter { !$0.isAvailable }
        case 3: // Rarely Used
            // Implement logic for rarely used if needed
            return filtered
        default: // All
            return filtered
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("My Wardrobe")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    NavigationLink(destination: AddItemView()) {
                        Text("Add")
                            .foregroundColor(.blue)
                            .font(.headline)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Search bar
                SearchBarViewApp(text: $searchText)
                    .padding(.vertical, 8)
                
                // Filter tabs
                Picker("Filter", selection: $selectedFilter) {
                    Text("All").tag(0)
                    Text("Available").tag(1)
                    Text("Unavailable").tag(2)
                    Text("Rarely Used").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Grid layout
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        ForEach(filteredItems) { item in
                            ItemCardView(item: item)
                        }
                    }
                    .padding()
                }
            }
            .background(Color.gray.opacity(0.05))
        }
    }
}

// Add Item View

// Sample data provider for preview
class PreviewSampleData {
    static func createSampleItems() -> [WardrobeItem] {
        [
            WardrobeItem(name: "Dress Gimana Gitu", category: "Tops", color: "Black", describe: "Cargo style", style: "Formal", type: "Tops", imagePath: "sample1", isAvailable: false),
            WardrobeItem(name: "Batik Dress Blue Baby", category: "Tops", color: "Beige", describe: "Slim fit", style: "Formal", type: "Tops", imagePath: "sample2", isAvailable: false),
            WardrobeItem(name: "Batik Tops", category: "Tops", color: "White", describe: "Loose fit", style: "Formal", type: "Tops", imagePath: "sample3"),
            WardrobeItem(name: "Batik Tops", category: "Tops", color: "Gray", describe: "Cargo style", style: "Formal", type: "Tops", imagePath: "sample4"),
            WardrobeItem(name: "Batik Tops", category: "Tops", color: "Brown", describe: "Wide leg", style: "Formal", type: "Tops", imagePath: "sample5"),
            WardrobeItem(name: "Batik Tops", category: "Tops", color: "Black", describe: "Straight cut", style: "Formal", type: "Tops", imagePath: "sample6")
        ]
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: WardrobeItem.self, configurations: config)
    
    // Add sample data
    for item in PreviewSampleData.createSampleItems() {
        container.mainContext.insert(item)
    }
    
    return DashboardView()
        .modelContainer(container)
}
