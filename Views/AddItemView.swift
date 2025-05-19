import SwiftUI

var colorTheme = Color(red: 146/255, green: 198/255, blue: 164/255)
//var colorTheme = Color.blue

struct BackButton: View {
    @State private var showAlert = false
    let alertTitle: String = "Return to Dashboard?"
    let alertMsg: String = "All cloth information filled here won't be saved."
    
    let unsavedData: Bool
    let onReturn: () -> Void
    
    var body: some View {
        Button(action: {
            unsavedData ? showAlert = true : onReturn()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(colorTheme)
            Text("Dashboard")
                .foregroundColor(colorTheme)
        }
        .alert(
            alertTitle,
            isPresented: $showAlert,
            actions: {
                Button("Cancel", role: .cancel) {
                }
                Button("Return", role: .destructive){
                    onReturn()
                }
                
            },
            message: {
                Text(alertMsg)
            }
        )
    }
}

struct AddPhotoView: View {
    @State private var showingImageOptions = false
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.2))
            .frame(height: 250)
            .overlay {
                VStack {
                    ZStack {
                        Circle()
                            .fill(colorTheme.opacity(0.15))
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "plus")
                            .font(.system(size: 30))
                            .foregroundColor(colorTheme)
                    }
                    Text("Add Media")
                        .foregroundColor(colorTheme)
                        .font(.subheadline)
                        .padding(.top, 4)
                }
            }
    }
}

// Custom Radio Button Style
struct RadioButtonStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            ZStack {
                Circle()
                    .stroke(colorTheme, lineWidth: 1)
                    .frame(width: 24, height: 24)
                
                if configuration.isOn {
                    Circle()
                        .fill(colorTheme)
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
                                    .foregroundColor(colorTheme)
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
                    .foregroundColor(colorTheme)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(colorTheme)
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
                                    .foregroundColor(colorTheme)
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
                    .foregroundColor(colorTheme)
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
    @State private var showingCamera = false
    @State private var showingImageOptions = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var currentImageIndex = 0
    @State private var status_coba = "add"
    
    let styles = ["Casual", "Formal", "Sport", "Homewear", "Party", "Work"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Image Upload Area
                    ZStack {
                        TabView(selection: $currentImageIndex) {
                            if images.isEmpty {
                                AddPhotoView()
                                    .tag(0)
                                    .onTapGesture {
                                        showingImageOptions = true
                                    }
                            } else {
                                ForEach(Array(images.enumerated()), id: \.offset) { index, image in
                                    ZStack(alignment: .topTrailing) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 250)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                            .tag(index)
                                            .onTapGesture {
                                                showingImageOptions = true
                                            }
                                        
                                        Button(action: {
                                            images.remove(at: index)
                                            
                                            if images.isEmpty {
                                                currentImageIndex = 0
                                            } else if index <= currentImageIndex && currentImageIndex > 0 {
                                                currentImageIndex -= 1
                                            }
                                        }) {
                                            ZStack {
                                                Circle()
                                                    .fill(Color.black.opacity(0.6))
                                                    .frame(width: 28, height: 28)
                                                
                                                Image(systemName: "xmark")
                                                    .font(.system(size: 20, weight: .bold))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        .padding(8)
                                    }
                                    .tag(index)
                                }
                                AddPhotoView()
                                    .tag(images.count)
                                    .onTapGesture {
                                        showingImageOptions = true
                                    }
                            }
                        }
                        .frame(height: 250)
                        .tabViewStyle(PageTabViewStyle())
                        .indexViewStyle(.page(backgroundDisplayMode: .always))
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
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
                                            .background(style == styleOption ? colorTheme : Color.gray.opacity(0.1))
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
                    BackButton(unsavedData: !images.isEmpty || !name.isEmpty || !type.isEmpty || !selectedColors.isEmpty || !description.isEmpty, onReturn: {
                        dismiss()
                    })
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveItem()
                    }
                    .foregroundColor(canSave ? colorTheme : .gray)
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
                ImagePicker(selectedImages: $images, status: $status_coba)
            }
            .sheet(isPresented: $showingCamera) {
                CameraView(image: $images) { result in
                    switch result {
                    case .success(let image):
                        images.append(image)
                    case .failure(let error):
                        alertMessage = error.localizedDescription
                        showingAlert = true
                    }
                }
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
            .alert(alertMessage, isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
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
            status: ItemStatus.available.rawValue    
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
