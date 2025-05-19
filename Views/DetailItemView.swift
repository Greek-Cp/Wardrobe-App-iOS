import SwiftUI
import SwiftData
import PhotosUI

struct DetailItemView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @State var item: WardrobeItem
    @State private var selectedAction: String = ""
    @State private var currentImageIndex = 0
    @State private var isEditing = false
    @State private var editedName = ""
    @State private var editedType = ""
    @State private var editedColors: [String] = []
    @State private var editedStyle = ""
    @State private var editedDescription = ""
    @State private var editedImages: [UIImage] = []
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var showingImageOptions = false
    @State private var showingTypeSelection = false
    @State private var showingColorSelection = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    private let controller = ItemController()
    private let styles = ["Casual", "Formal", "Sport", "Homewear", "Party", "Work"]
    
    // Helper function to convert status to action
    private func getActionFromStatus(_ status: String) -> String {
        switch status {
        case ItemStatus.available.rawValue:
            return "Available"
        case ItemStatus.unavailable.rawValue:
            // Check if item is in use, laundry, or repair based on history or last action
            if let lastAction = controller.getLastAction(for: item) {
                return lastAction
            }
            return "Use" // Default to "Use" if no history
        case ItemStatus.rarelyUsed.rawValue:
            return "Rarely Used"
        default:
            return "Available"
        }
    }
    
    var body: some View {
        CustomNavigationBar(title: "Detail Item") {
            presentationMode.wrappedValue.dismiss()
        }
        ScrollView {
            VStack(spacing: 16) {
                // Image Carousel
                ZStack(alignment: .topTrailing) {
                    if isEditing {
                        // Editing mode image display
                        ZStack {
                            TabView(selection: $currentImageIndex) {
                                if editedImages.isEmpty {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(height: 250)
                                        .overlay {
                                            VStack {
                                                ZStack {
                                                    Circle()
                                                        .fill(Color.blue.opacity(0.15))
                                                        .frame(width: 60, height: 60)
                                                    
                                                    Image(systemName: "plus")
                                                        .font(.system(size: 30))
                                                        .foregroundColor(.blue)
                                                }
                                                Text("Add Media")
                                                    .foregroundColor(.blue)
                                                    .font(.subheadline)
                                                    .padding(.top, 4)
                                            }
                                        }
                                        .tag(0)
                                } else {
                                    ForEach(Array(editedImages.enumerated()), id: \.offset) { index, image in
                                        Image(uiImage: image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 320)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                            .frame(maxWidth: .greatestFiniteMagnitude)
                                            .tag(index)
                                    }
                                }
                            }
                            .frame(height: 320)
                            .tabViewStyle(PageTabViewStyle())
                            .onTapGesture {
                                showingImageOptions = true
                            }
                        }
                    } else {
                        // Normal view image display
                        TabView(selection: $currentImageIndex) {
                            ForEach(Array(item.imagePaths.enumerated()), id: \.offset) { index, path in
                                if let uiImage = UIImage(contentsOfFile: path) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 320)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .tag(index)
                                }
                            }
                        }
                        .frame(height: 320)
                        .tabViewStyle(PageTabViewStyle())
                    }
                    
                    Button(action: {
                        if isEditing {
                            saveChanges()
                        } else {
                            startEditing()
                        }
                    }) {
                        Text(isEditing ? "Save" : "Edit")
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.ultraThickMaterial)
                            .clipShape(Capsule())
                    }
                    .padding(12)
                    .foregroundColor(.primary)
                }
                if isEditing {
                    // Editing mode content
                    VStack(spacing: 16) {
                        // Name Field
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Name")
                                .fontWeight(.medium)
                            TextField("Cloth name here...", text: $editedName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        // Type Field
                        Button(action: {
                            showingTypeSelection = true
                        }) {
                            HStack {
                                Text("Type")
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                                Spacer()
                                Text(editedType.isEmpty ? "Select..." : editedType)
                                    .foregroundColor(editedType.isEmpty ? .gray : .primary)
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 8)
                        }
                        
                        // Color Selection
                        Button(action: {
                            showingColorSelection = true
                        }) {
                            HStack {
                                Text("Colors")
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                                Spacer()
                                if !editedColors.isEmpty {
                                    HStack(spacing: 4) {
                                        ForEach(editedColors.prefix(3), id: \.self) { colorName in
                                            Circle()
                                                .fill(getColor(for: colorName))
                                                .frame(width: 16, height: 16)
                                        }
                                        if editedColors.count > 3 {
                                            Text("+\(editedColors.count - 3)")
                                                .foregroundColor(.gray)
                                                .font(.caption)
                                        }
                                    }
                                }
                                Text(editedColors.isEmpty ? "Select..." : "\(editedColors.count) selected")
                                    .foregroundColor(editedColors.isEmpty ? .gray : .primary)
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 8)
                        }
                        
                        // Style Selection
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Style")
                                .fontWeight(.medium)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(styles, id: \.self) { styleOption in
                                    Button(action: {
                                        editedStyle = styleOption
                                    }) {
                                        Text(styleOption)
                                            .font(.subheadline)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 12)
                                            .frame(maxWidth: .infinity)
                                            .background(editedStyle == styleOption ? Color.blue : Color.gray.opacity(0.1))
                                            .foregroundColor(editedStyle == styleOption ? .white : .primary)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                        }
                        
                        // Description Field
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Description")
                                .fontWeight(.medium)
                            TextField("Add description/keywords...", text: $editedDescription)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    .padding(.horizontal)
                } else {
                    // Normal view content
                    VStack(spacing: 4) {
                        Text(item.name)
                            .font(.title2)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            if let lastAction = controller.getLastAction(for: item) {
                                if lastAction == ItemAction.available.rawValue {
                                    Text(lastAction)
                                        .foregroundColor(.green)
                                        .fontWeight(.medium)
                                } else {
                                    VStack(alignment: .leading) {
                                        Text(lastAction)
                                            .foregroundColor(.red)
                                            .fontWeight(.medium)
                                        Text(controller.getFormattedLastActionDate(for: item))
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                            } else {
                                Text(item.status)
                                    .foregroundColor(item.status == ItemStatus.available.rawValue ? .green : .red)
                                    .fontWeight(.medium)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
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
                        ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
                            RoundedRectangle(cornerRadius: 25.0)
                                .foregroundStyle(Color.gray.opacity(0.1))
                            Text(item.describe)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .padding(.top)
                                .padding(.leading)
                        }
                        .frame(height: 120)
                    }
                    .padding(.horizontal)
                    
                    // Status buttons
                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            statusButton(icon: "checkmark", label: "Available")
                            statusButton(icon: "tshirt.fill", label: "Use")
                            statusButton(icon: "hanger", label: "Laundry")
                            statusButton(icon: "scissors", label: "Repair")
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(Color.white, for: .navigationBar)
        .tint(Color(red: 146/255, green: 198/255, blue: 164/255))
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImages: $editedImages)
        }
        .sheet(isPresented: $showingCamera) {
            CameraView(image: $editedImages) { result in
                switch result {
                case .success(let image):
                    editedImages.append(image)
                case .failure(let error):
                    alertMessage = error.localizedDescription
                    showingAlert = true
                }
            }
        }
        .sheet(isPresented: $showingTypeSelection) {
            TypeSelectionView(selectedType: $editedType)
        }
        .sheet(isPresented: $showingColorSelection) {
            ColorSelectionView(selectedColors: $editedColors)
        }
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        }
        .confirmationDialog("Choose Image Source", isPresented: $showingImageOptions, titleVisibility: .visible) {
            Button("Take Photo") {
                showingCamera = true
            }
            Button("Choose from Library") {
                showingImagePicker = true
            }
            Button("Cancel", role: .cancel) {}
        }
        .onAppear {
            // Set initial selected action based on current status
            selectedAction = getActionFromStatus(item.status)
        }
    }
    
    private func startEditing() {
        editedName = item.name
        editedType = item.category
        editedColors = item.colors
        editedStyle = item.style
        editedDescription = item.describe
        editedImages = item.imagePaths.compactMap { UIImage(contentsOfFile: $0) }
        isEditing = true
    }
    
    private func saveChanges() {
        // Save new images if any
        var newImagePaths: [String] = []
        for image in editedImages {
            if let imagePath = ImageManager.shared.saveImage(image) {
                newImagePaths.append(imagePath)
            }
        }
        
        // Delete old images if they were replaced
        if !newImagePaths.isEmpty {
            for oldPath in item.imagePaths {
                ImageManager.shared.deleteImage(at: oldPath)
            }
        }
        
        // Update item properties
        controller.updateItem(
            item: item,
            name: editedName,
            category: editedType,
            colors: editedColors,
            describe: editedDescription,
            style: editedStyle,
            imagePath: newImagePaths.isEmpty ? nil : newImagePaths.joined(separator: ","),
            status: item.status
        )
        
        do {
            try context.save()
            isEditing = false
        } catch {
            alertMessage = "Failed to save changes. Please try again."
            showingAlert = true
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
    
    private func statusButton(icon: String, label: String) -> some View {
        let isSelected = selectedAction == label
        let buttonColor = isSelected ? Color(red: 146/255, green: 198/255, blue: 164/255) : Color.gray.opacity(0.3)
        
        return Button(action: {
            withAnimation(.spring(response: 0.3)) {
                selectedAction = label
                updateStatus(to: label)
            }
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
    
    private func updateStatus(to action: String) {
        switch action {
        case "Available":
            item.status = ItemStatus.available.rawValue
            controller.markItemAsAvailable(item: item)
        case "Use":
            item.status = ItemStatus.unavailable.rawValue
            controller.handleWear(item: item)
        case "Laundry":
            item.status = ItemStatus.unavailable.rawValue
            controller.handleLaundry(item: item)
        case "Repair":
            item.status = ItemStatus.unavailable.rawValue
            controller.handleRepair(item: item)
        default:
            break
        }

        do {
            try context.save()
        } catch {
            print("Failed to save context after status change: \(error)")
        }
    }
    
    private func statusColor(for status: String) -> Color {
        switch status {
        case ItemStatus.available.rawValue:
            return .green
        case ItemStatus.unavailable.rawValue:
            return .red
        case ItemStatus.rarelyUsed.rawValue:
            return .orange
        default:
            return .gray
        }
    }
    
    private func statusIcon(for status: String) -> String {
        switch status {
        case ItemStatus.available.rawValue:
            return "checkmark.circle"
        case ItemStatus.unavailable.rawValue:
            return "xmark.circle"
        case ItemStatus.rarelyUsed.rawValue:
            return "clock"
        default:
            return "questionmark.circle"
        }
    }
    
    @ViewBuilder
    private func tagView(_ text: String) -> some View {
        Text(text)
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(Color(red: 146/255, green: 198/255, blue: 164/255))
            .foregroundColor(.white)
            .cornerRadius(12)
    }
}





