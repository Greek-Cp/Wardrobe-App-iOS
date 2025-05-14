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
                    if let image = UIImage(contentsOfFile: item.imagePath) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                    } else {
                        Color.gray.frame(height: 250)
                        ProgressView("Loading...")
                    }
                    
                    Button("Edit") {
                        // action edit handler
                    }
                    .padding(.trailing, 16)
                    .padding(.top, 8)
                    .foregroundColor(.gray)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
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

                HStack {
                    tagView(item.category)
                    tagView(item.color)
                    tagView(item.style)
                }
                .padding(.horizontal)

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
                    }.frame(height: 150)
                }
                .padding(.horizontal)
                HStack(spacing: 16) {
                    statusButton(icon: "checkmark", label: "Available", isSelected: item.isAvailable, color: .blue) {
                        selectedStatus = "Available"
                        showConfirmation = true
                        
                    }
                    statusButton(icon: "hanger", label: "Laundry", isSelected: false, color: .gray) {
                        selectedStatus = "Laundry"
                        showConfirmation = true
                        
                    }
                    statusButton(icon: "tshirt.fill", label: "Use", isSelected: false, color: .gray) {
                        selectedStatus = "Use"
                        showConfirmation = true
                        
                    }
                    statusButton(icon: "scissors", label: "Repair", isSelected: false, color: .gray) {
                        selectedStatus = "Repair"
                        showConfirmation = true
                        
                    }
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
    
    private func statusButton(icon: String, label: String, isSelected: Bool, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .padding()
                    .background(isSelected ? color : Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Text(label)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
        }
    }
    
    private func applyStatusChange() {
        switch selectedStatus {
        case "Available":
            controller.markItemAsAvailable(item: item)
        case "Laundry":
            controller.handleLaundry(item: item)
        case "Use":
            controller.handleWear(item: item)
        case "Repair":
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
        imagePath: "",
        isAvailable: true
    )

    container.mainContext.insert(sampleItem)

    return NavigationView {
        DetailItemView(item: sampleItem)
    }
    .modelContainer(container)
}
