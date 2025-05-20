import SwiftUI
import SwiftData

import SwiftUI

struct CustomSegmentedControl: View {
    let segments: [String]
    @Binding var selectedIndex: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(segments.indices, id: \.self) { index in
                Button(action: {
                    selectedIndex = index
                }) {
                    Text(segments[index])
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(selectedIndex == index ? .white : .gray)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(selectedIndex == index ?
                            Color(red: 146/255, green: 198/255, blue: 164/255) : Color.gray.opacity(0.1))                        .cornerRadius(20)
                }
            }
        }
    }
}

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
    private let controller = ItemController()
    @State private var showingDeleteAlert = false
    @State private var isEditViewPresented = false
    
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
                            .frame(width: 170,height: 130)
                            .clipped()
                    } else {
                        Rectangle()
                            .fill(Color(UIColor.secondarySystemBackground))
                            .frame(width: 170, height: 130)
                                    .overlay(
                                        VStack(spacing: 8) {
                                            Image(systemName: "photo")
                                                .font(.system(size: 24))
                                                .foregroundColor(Color(UIColor.tertiaryLabel))
                                            Text("No Image")
                                                .font(.caption)
                                                .foregroundColor(Color(UIColor.secondaryLabel))
                                        }
                                    )
                                    .cornerRadius(12)
                    }
                }
                .frame(height: 130)
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
            .background(Color(UIColor.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .frame(height: 200)
        }
        .buttonStyle(PlainButtonStyle())
        .contextMenu {
            Button {
                isEditViewPresented = true
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            
            Button(role: .destructive) {
                showingDeleteAlert = true
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .alert("Delete Item", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                withAnimation {
                    deleteItem()
                }
            }
        } message: {
            Text("Are you sure you want to delete this item? This action cannot be undone.")
        }
        .sheet(isPresented: $isEditViewPresented) {
            NavigationStack {
                DetailItemView(item: item)
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
        controller.updateItemStatus(item: item, action: status.rawValue)
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
    @StateObject private var dashboardController: DashboardController
    @Query private var items: [WardrobeItem]
    
    private let gridColumns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    init(modelContext: ModelContext) {
        _dashboardController = StateObject(wrappedValue: DashboardController(modelContext: modelContext))
        
    }
    
    private var filteredItems: [WardrobeItem] {
        dashboardController.getFilteredItems(items: items)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("My Wardrobe")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 146/255, green: 198/255, blue: 164/255))
                    
                    Spacer()
                    
                    NavigationLink(destination: AddItemView()) {
                        Text("Add")
                            .foregroundColor(Color(red: 146/255, green: 198/255, blue: 164/255))
                            .font(.headline)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Search bar
                SearchBarViewApp(text: $dashboardController.searchText)
                    .padding(.vertical, 8)
                
                // Filter tabs
                CustomSegmentedControl(
                    segments: ["All", "Available", "Unavailable", "Rarely"],
                    selectedIndex: $dashboardController.selectedFilter
                )
                .padding(.vertical, 8)
                
                if filteredItems.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "tshirt.fill")
                            .font(.system(size: 64))
                            .foregroundColor(Color(red: 146/255, green: 198/255, blue: 164/255))
                        Text("No items found")
                            .font(.headline)
                            .foregroundColor(Color(red: 146/255, green: 198/255, blue: 164/255))
                        
                        if(dashboardController.countItems() == 0){
                            Text("Add some clothes to your wardrobe")
                                .font(.subheadline)
                                .foregroundColor(Color(red: 146/255, green: 198/255, blue: 164/255))
                        }else{
                            if(dashboardController.selectedFilter == 3){
                                Text("Good Job!! All clothes have been worn rencently")
                                    .font(.subheadline)
                                    .foregroundColor(Color(red: 146/255, green: 198/255, blue: 164/255))
                            }else if(dashboardController.selectedFilter == 2){
                                Text("All clothes is available!")
                                    .font(.subheadline)
                                    .foregroundColor(Color(red: 146/255, green: 198/255, blue: 164/255))
                            }
                        }
                        
                        
                        
                        
                        
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
            .onAppear {
                dashboardController.items = items
                NotificationHelper.checkItemsAndNotify(items)
                NotificationHelper.rareUsedNotify(items)
            }
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
    
    return DashboardView(modelContext: container.mainContext)
        .modelContainer(container)
}
