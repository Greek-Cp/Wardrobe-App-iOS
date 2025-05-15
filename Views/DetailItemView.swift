import SwiftUI
import SwiftData

struct DetailItemView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State var item: WardrobeItem
    @State private var selectedStatus: String = ""
    @State private var showConfirmation = false
    @State private var currentImageIndex = 0
    
    private let controller = ItemController()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ZStack(alignment: .topTrailing) {
                    TabView(selection: $currentImageIndex) {
                        ForEach(Array(item.imagePaths.enumerated()), id: \.offset) { index, path in
                            ZStack {
                                if let uiImage = UIImage(contentsOfFile: path) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: .infinity)
                                } else {
                                    ZStack {
                                        Color.gray.frame(height: 250)
                                        ProgressView("Loading...")
                                            .progressViewStyle(CircularProgressViewStyle())
                                    }
                                }
                            }
                            .tag(index)
                        }
                    }
                    .frame(height: 300)
                    .tabViewStyle(PageTabViewStyle())
                    
                    Button(action: {
                        // edit action
                    }) {
                        Text("Edit")
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.ultraThickMaterial)
                            .clipShape(Capsule())
                    }
                    .padding(12)
                    .foregroundColor(.primary)
                }
                
                // Image indicators
                if item.imagePaths.count > 1 {
                    HStack(spacing: 8) {
                        ForEach(0..<item.imagePaths.count, id: \.self) { index in
                            Circle()
                                .fill(currentImageIndex == index ? Color.blue : Color.gray)
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.top, -8)
                }

                VStack(spacing: 4) {
                    Text(item.name)
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Laundry : 17 May 2025")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading){
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            tagView(item.category)
                            ForEach(item.colors, id: \.self) { color in
                                tagView(color)
                            }
                            tagView(item.style)
                        }
                    }
                    .padding(.horizontal)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Description")
                        .font(.headline)
                    ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)){
                        RoundedRectangle(cornerRadius: 25.0)
                            .foregroundStyle(.gray)
                        Text(item.describe)
                            .foregroundStyle(Color.white)
                            .padding(.top)
                            .padding(.leading)
                    }.frame(height: 120)
                }
                .padding(.horizontal)
                
                HStack(spacing: 12) {
                    statusButton(icon: "checkmark", label: "Available")
                    statusButton(icon: "hanger", label: "Laundry")
                    statusButton(icon: "tshirt.fill", label: "Use")
                    statusButton(icon: "scissors", label: "Repair")
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert("Confirm Action", isPresented: $showConfirmation) {
            Button("Confirm") {
                applyStatusChange()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to mark this item as '\(selectedStatus)'?")
        }
    }
    
    @ViewBuilder
    private func tagView(_ text: String) -> some View {
        Text(text)
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(Color.blue.opacity(0.1))
            .foregroundColor(.blue)
            .cornerRadius(12)
    }
    
    private func statusButton(icon: String, label: String) -> some View {
        let isSelected = selectedStatus == label
        let buttonColor = isSelected ? Color.blue : Color.gray.opacity(0.3)
        
        return Button(action: {
            selectedStatus = label
            showConfirmation = true
        }) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.white)
                
                if isSelected {
                    Text(label)
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .padding(.trailing, 4)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, isSelected ? 20 : 16)
            .background(buttonColor)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    private func applyStatusChange() {
        switch selectedStatus {
        case "Available":
            item.isAvailable = true
            controller.markItemAsAvailable(item: item)
        case "Laundry":
            item.isAvailable = false
            controller.handleLaundry(item: item)
        case "Use":
            item.isAvailable = false
            controller.handleWear(item: item)
        case "Repair":
            item.isAvailable = false
            controller.handleRepair(item: item)
        default:
            break
        }

        do {
            try context.save()
            dismiss()
        } catch {
            print("Failed to save context after status change: \(error)")
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: WardrobeItem.self, configurations: config)

    let sampleItem = WardrobeItem(
        name: "Jeans Culottes",
        category: "Bottoms",
        colors: ["Blue", "Black"],
        describe: "Jeans, Coulotte, Long, Oversized, Uniqlo",
        style: "Casual",
        type: "Bottom",
        imagePath: "kulot,kulot2,kulot3",
        isAvailable: true
    )

    container.mainContext.insert(sampleItem)

    return NavigationView {
        DetailItemView(item: sampleItem)
    }
    .modelContainer(container)
}
