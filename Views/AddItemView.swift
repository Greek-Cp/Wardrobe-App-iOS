import SwiftUI

// Custom Radio Button Style
struct RadioButtonStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            ZStack {
                Circle()
                    .stroke(Color.blue, lineWidth: 1)
                    .frame(width: 24, height: 24)
                
                if configuration.isOn {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 16, height: 16)
                }
            }
            configuration.label
        }
    }
}

// Color Selection View
struct ColorSelectionView: View {
    @Binding var selectedColors: [String]
    @Environment(\.dismiss) private var dismiss
    
    let colors: [String: Color] = [
        "Black": .black,
        "White": .white,
        "Red": .red,
        "Blue": .blue,
        "Green": .green,
        "Yellow": .yellow,
        "Purple": .purple,
        "Gray": .gray,
        "Brown": Color(red: 0.6, green: 0.4, blue: 0.2)
    ]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(Array(colors.keys.sorted()), id: \.self) { colorName in
                    Button(action: {
                        if selectedColors.contains(colorName) {
                            selectedColors.removeAll { $0 == colorName }
                        } else {
                            selectedColors.append(colorName)
                        }
                    }) {
                        HStack {
                            Circle()
                                .fill(colors[colorName] ?? .gray)
                                .frame(width: 30, height: 30)
                            Text(colorName)
                            Spacer()
                            if selectedColors.contains(colorName) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
            .navigationTitle("Select Colors")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// Type Selection View
struct TypeSelectionView: View {
    @Binding var selectedType: String
    @Environment(\.dismiss) private var dismiss
    
    let types = [
        "Tops", "Bottoms", "Outerwear", "Dresses",
        "Shoes", "Accessories", "Underwear", "Activewear"
    ]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(types, id: \.self) { type in
                    Button(action: {
                        selectedType = type
                        dismiss()
                    }) {
                        HStack {
                            Text(type)
                            Spacer()
                            if selectedType == type {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
            .navigationTitle("Select Type")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// Add Item View
struct AddItemView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var name = ""
    @State private var type = ""
    @State private var selectedColors: [String] = []
    @State private var style = "Casual" // Default style
    @State private var description = ""
    @State private var isAvailable = true
    @State private var showingTypeSelection = false
    @State private var showingColorSelection = false
    @State private var images: [UIImage] = []
    @State private var showingImagePicker = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var currentImageIndex = 0
    
    let styles = ["Casual", "Formal", "Sport", "Homewear", "Party", "Work"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Image Upload Area
                    ZStack {
                        TabView(selection: $currentImageIndex) {
                            if images.isEmpty {
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
                                ForEach(Array(images.enumerated()), id: \.offset) { index, image in
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 250)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .tag(index)
                                }
                            }
                        }
                        .frame(height: 250)
                        .tabViewStyle(PageTabViewStyle())
                        
                        if !images.isEmpty {
                            VStack {
                                Spacer()
                                HStack {
                                    ForEach(0..<images.count, id: \.self) { index in
                                        Circle()
                                            .fill(currentImageIndex == index ? Color.blue : Color.gray)
                                            .frame(width: 8, height: 8)
                                    }
                                }
                                .padding(.bottom, 8)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    .onTapGesture {
                        showingImagePicker = true
                    }
                    
                    VStack(spacing: 0) {
                        // Name Field
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Name")
                                .fontWeight(.medium)
                            TextField("Cloth name here...", text: $name)
                                .padding(.vertical, 8)
                        }
                        .padding(.vertical, 8)
                        Divider()
                        
                        // Type Field
                        Button(action: {
                            showingTypeSelection = true
                        }) {
                            HStack {
                                Text("Type")
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                                Spacer()
                                Text(type.isEmpty ? "Select..." : type)
                                    .foregroundColor(type.isEmpty ? .gray : .primary)
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 16)
                        }
                        Divider()
                        
                        // Color Field
                        Button(action: {
                            showingColorSelection = true
                        }) {
                            HStack {
                                Text("Colors")
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                                Spacer()
                                if !selectedColors.isEmpty {
                                    HStack(spacing: 4) {
                                        ForEach(selectedColors.prefix(3), id: \.self) { colorName in
                                            Circle()
                                                .fill(getColor(for: colorName))
                                                .frame(width: 16, height: 16)
                                        }
                                        if selectedColors.count > 3 {
                                            Text("+\(selectedColors.count - 3)")
                                                .foregroundColor(.gray)
                                                .font(.caption)
                                        }
                                    }
                                    .padding(.trailing, 4)
                                }
                                Text(selectedColors.isEmpty ? "Select..." : "\(selectedColors.count) selected")
                                    .foregroundColor(selectedColors.isEmpty ? .gray : .primary)
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 16)
                        }
                        Divider()
                        
                        // Style Selection
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Style")
                                .fontWeight(.medium)
                                .padding(.top, 8)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(styles, id: \.self) { styleOption in
                                    Button(action: {
                                        style = styleOption
                                    }) {
                                        Text(styleOption)
                                            .font(.subheadline)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 12)
                                            .frame(maxWidth: .infinity)
                                            .background(style == styleOption ? Color.blue : Color.gray.opacity(0.1))
                                            .foregroundColor(style == styleOption ? .white : .primary)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                            .padding(.bottom, 8)
                        }
                        Divider()
                        
                        // Description Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .fontWeight(.medium)
                                .padding(.top, 8)
                            
                            TextField("Add description/keywords...", text: $description)
                                .padding(.vertical, 8)
                        }
                        Divider()
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                }
            }
            .background(Color(UIColor.systemBackground))
            .navigationTitle("Add Cloth")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        if !name.isEmpty || !type.isEmpty || !selectedColors.isEmpty || !images.isEmpty {
                            showingAlert = true
                            alertMessage = "Are you sure you want to discard this item? Any changes will be lost."
                        } else {
                            dismiss()
                        }
                    }) {
                        Image(systemName: "chevron.left")
                        Text("Dashboard")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveItem()
                    }
                    .foregroundColor(canSave ? .blue : .gray)
                    .disabled(!canSave)
                }
            }
            .sheet(isPresented: $showingTypeSelection) {
                TypeSelectionView(selectedType: $type)
            }
            .sheet(isPresented: $showingColorSelection) {
                ColorSelectionView(selectedColors: $selectedColors)
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImages: $images)
            }
            .alert(alertMessage, isPresented: $showingAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Discard", role: .destructive) {
                    dismiss()
                }
            }
        }
    }
    
    private var canSave: Bool {
        !name.isEmpty && !type.isEmpty && !selectedColors.isEmpty && !images.isEmpty
    }
    
    private func saveItem() {
        var imagePaths: [String] = []
        
        // Save all images
        for image in images {
            if let imagePath = ImageManager.shared.saveImage(image) {
                imagePaths.append(imagePath)
            }
        }
        
        guard !imagePaths.isEmpty else {
            showingAlert = true
            alertMessage = "Failed to save images. Please try again."
            return
        }
        
        let newItem = WardrobeItem(
            name: name,
            category: type,
            colors: selectedColors,
            describe: description,
            style: style,
            type: type,
            imagePath: imagePaths.joined(separator: ","), // Store multiple paths separated by comma
            isAvailable: true
        )
        
        modelContext.insert(newItem)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            showingAlert = true
            alertMessage = "Failed to save item. Please try again."
            // Clean up the saved images if item saving fails
            for path in imagePaths {
                ImageManager.shared.deleteImage(at: path)
            }
        }
    }
    
    func getColor(for name: String) -> Color {
        switch name.lowercased() {
        case "red": return .red
        case "blue": return .blue
        case "green": return .green
        case "black": return .black
        case "white": return .white
        case "yellow": return .yellow
        case "purple": return .purple
        case "gray": return .gray
        case "brown": return Color(red: 0.6, green: 0.4, blue: 0.2)
        default: return .gray
        }
    }
}
#Preview {
    AddItemView()
}
