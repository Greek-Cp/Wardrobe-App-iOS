import SwiftUI
import SwiftData

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
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationLink(destination: DetailItemView(item: item)) {
            VStack(alignment: .leading, spacing: 0) {
                // Image container with fixed aspect ratio
                ZStack {
                    if let firstImagePath = item.imagePaths.first,
                       let uiImage = UIImage(contentsOfFile: firstImagePath) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 120)
                            .clipped()
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .overlay(
                                VStack(spacing: 8) {
                                    Image(systemName: "photo")
                                        .font(.system(size: 20))
                                        .foregroundColor(.gray)
                                    Text("No Image")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            )
                    }
                }
                .frame(height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                
                // Content container
                VStack(alignment: .leading, spacing: 4) {
                    // Name and status
                    HStack(alignment: .top) {
                        Text(item.name)
                            .font(.headline)
                            .lineLimit(1)
                        Spacer()
                        if item.status == ItemStatus.unavailable.rawValue {
                            Text("N/A")
                                .font(.caption2)
                                .fontWeight(.medium)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.red.opacity(0.9))
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                        }
                    }
                    
                    // Colors
                    if !item.colors.isEmpty {
                        HStack(spacing: 4) {
                            ForEach(item.colors.prefix(3), id: \.self) { colorName in
                                Circle()
                                    .fill(getColor(for: colorName))
                                    .frame(width: 10, height: 10)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white, lineWidth: 1)
                                    )
                            }
                            if item.colors.count > 3 {
                                Text("+\(item.colors.count - 3)")
                                    .foregroundColor(.gray)
                                    .font(.caption2)
                                    .padding(.leading, 2)
                            }
                        }
                    }
                    
                    // Category and style
                    HStack {
                        Text(item.category)
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("•")
                            .foregroundColor(.gray.opacity(0.5))
                            .font(.caption)
                        Text(item.style)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .lineLimit(1)
                }
                .padding(8)
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .frame(height: 200)
        }
        .buttonStyle(PlainButtonStyle())
        .contextMenu {
            Button(role: .destructive) {
                deleteItem()
            } label: {
                Label("Delete", systemImage: "trash")
            }
            
            Button {
                updateItemStatus(.available)
            } label: {
                Label("Mark Available", systemImage: "checkmark.circle")
            }
            
            Button {
                updateItemStatus(.unavailable)
            } label: {
                Label("Mark Unavailable", systemImage: "xmark.circle")
            }
        }
    }
    
    private func deleteItem() {
        modelContext.delete(item)
        do {
            try modelContext.save()
        } catch {
            print("Failed to delete item: \(error)")
        }
    }
    
    private func updateItemStatus(_ status: ItemStatus) {
        item.status = status.rawValue
        do {
            try modelContext.save()
        } catch {
            print("Failed to update item status: \(error)")
        }
    }
    
    private func getColor(for name: String) -> Color {
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
}

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [WardrobeItem]
    @State private var searchText = ""
    @State private var selectedFilter = 0
    
    private let gridColumns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    private var filteredItems: [WardrobeItem] {
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
                
                if filteredItems.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "tshirt.fill")
                            .font(.system(size: 64))
                            .foregroundColor(.gray)
                        Text("No items found")
                            .font(.headline)
                        Text("Add some clothes to your wardrobe")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.05))
                } else {
                    ScrollView {
                        LazyVGrid(columns: gridColumns, spacing: 16) {
                            ForEach(filteredItems) { item in
                                ItemCardView(item: item)
                            }
                        }
                        .padding(16)
                    }
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
            WardrobeItem(name: "Dress Gimana Gitu", category: "Tops", colors: ["Black", "White"], describe: "Cargo style", style: "Formal", type: "Tops", imagePath: "sample1", status: ItemStatus.unavailable.rawValue),
            WardrobeItem(name: "Batik Dress Blue Baby", category: "Tops", colors: ["Blue", "White"], describe: "Slim fit", style: "Formal", type: "Tops", imagePath: "sample2", status: ItemStatus.unavailable.rawValue),
            WardrobeItem(name: "Batik Tops", category: "Tops", colors: ["White", "Brown"], describe: "Loose fit", style: "Formal", type: "Tops", imagePath: "sample3", status: ItemStatus.available.rawValue),
            WardrobeItem(name: "Batik Tops", category: "Tops", colors: ["Gray", "Black"], describe: "Cargo style", style: "Formal", type: "Tops", imagePath: "sample4", status: ItemStatus.available.rawValue),
            WardrobeItem(name: "Batik Tops", category: "Tops", colors: ["Brown", "White"], describe: "Wide leg", style: "Formal", type: "Tops", imagePath: "sample5", status: ItemStatus.available.rawValue),
            WardrobeItem(name: "Batik Tops", category: "Tops", colors: ["Black", "Gray"], describe: "Straight cut", style: "Formal", type: "Tops", imagePath: "sample6", status: ItemStatus.available.rawValue)
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
