import SwiftUI
import SwiftData

struct DetailItemView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State var item: WardrobeItem
    @State private var selectedStatus: String = ""
    @State private var showConfirmation = false
    
    private let controller = ItemController()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ZStack(alignment: .topTrailing) {
                    ZStack {
                        if let uiImage = UIImage(contentsOfFile: item.imagePath) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity)
                        } else if UIImage(named: item.imagePath) != nil {
                            Image(item.imagePath) // Loads from assets
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
                
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 50, height: 24)
                    .foregroundColor(.white.opacity(0.9))
                    .overlay(Circle().frame(width: 10, height: 10).foregroundColor(.black))
                    .padding(.top, -8)

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
                    HStack {
                        tagView(item.category)
                        tagView(item.color)
                        tagView(item.style)
                    }
                    .padding(.horizontal)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Description")
                        .font(.headline)
                    ZStack(alignment: Alignment (horizontal: .leading, vertical: .top)){
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
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
        color: "Blue",
        describe: "Jeans, Coulotte, Long, Oversized, Uniqlo",
        style: "Casual",
        type: "Bottom",
        imagePath: "kulot",
        isAvailable: true
    )

    container.mainContext.insert(sampleItem)

    return NavigationView {
        DetailItemView(item: sampleItem)
    }
    .modelContainer(container)
}
