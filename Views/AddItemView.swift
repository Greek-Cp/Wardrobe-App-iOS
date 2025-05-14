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
    @Binding var selectedColor: String
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
                        selectedColor = colorName
                        dismiss() //this auto close the NavStack after user choose one color
                    }) {
                        HStack {
                            Circle()
                                .fill(colors[colorName] ?? .gray) //defaults to gray color in case color not found
                                .frame(width: 30, height: 30)
                            Text(colorName)
                            Spacer()
                            if selectedColor == colorName {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
            .navigationTitle("Select Color")
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
    @State private var color = ""
    @State private var style = "Casual" // Default style
    @State private var description = ""
    @State private var isAvailable = true
    @State private var showingTypeSelection = false
    @State private var showingColorSelection = false
    @State private var image: UIImage? = nil
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Image Upload Area
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 250)
                        
                        if let selectedImage = image {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 250)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        } else {
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
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    .onTapGesture {
                        // Would trigger photo picker in a real app
                        // For now just a placeholder
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
                                Text("Color")
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                                Spacer()
                                if !color.isEmpty {
                                    Circle()
                                        .fill(getColor(for: color))
                                        .frame(width: 16, height: 16)
                                        .padding(.trailing, 4)
                                }
                                Text(color.isEmpty ? "Select..." : color)
                                    .foregroundColor(color.isEmpty ? .gray : .primary)
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
                            
                            HStack(spacing: 20) {
                                Toggle(isOn: Binding(
                                    get: { style == "Casual" },
                                    set: { if $0 { style = "Casual" } }
                                )) {
                                    Text("Casual")
                                        .fontWeight(.medium)
                                }
                                .toggleStyle(RadioButtonStyle())
                                
                                Toggle(isOn: Binding(
                                    get: { style == "Homewear" },
                                    set: { if $0 { style = "Homewear" } }
                                )) {
                                    Text("Homewear")
                                        .fontWeight(.medium)
                                }
                                .toggleStyle(RadioButtonStyle())
                                
                                Toggle(isOn: Binding(
                                    get: { style == "Formal" },
                                    set: { if $0 { style = "Formal" } }
                                )) {
                                    Text("Formal")
                                        .fontWeight(.medium)
                                }
                                .toggleStyle(RadioButtonStyle())
                            }
                            .padding(.bottom, 8)
                        }
                        Divider()
                        
                        // Description Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Describe (optional):")
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
                        dismiss()
                        //TODO: should confirm to the user any data filled in this page will not be saved?
                    }) {
                        Image(systemName: "chevron.left")
                        Text("Dashboard")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newItem = WardrobeItem(
                            name: name,
                            category: type,
                            color: color,
                            describe: description,
                            style: style,
                            type: type,
                            imagePath: "placeholder_image",
                            isAvailable: true
                        )
                        
                        modelContext.insert(newItem)
                        dismiss()
                    }
                    .foregroundColor(name.isEmpty || type.isEmpty || color.isEmpty ? .gray : .blue)
                    .disabled(name.isEmpty || type.isEmpty || color.isEmpty) //TODO: should alert the user which field isn't filled yet instead? Also don't forget to add photo checking as well.
                }
            }
            .sheet(isPresented: $showingTypeSelection) {
                TypeSelectionView(selectedType: $type)
            }
            .sheet(isPresented: $showingColorSelection) {
                ColorSelectionView(selectedColor: $color)
            }
        }
    }
    
    // Helper function to convert color name to Color
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
}
#Preview {
    AddItemView()
}
