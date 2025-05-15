import SwiftUI

struct ItemCell: View {
    let item: WardrobeItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text(item.category)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Display up to 3 colors
            HStack(spacing: 4) {
                ForEach(item.colors.prefix(3), id: \.self) { colorName in
                    Circle()
                        .fill(colorFromString(colorName))
                        .frame(width: 20, height: 20)
                }
                if item.colors.count > 3 {
                    Text("+\(item.colors.count - 3)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    func colorFromString(_ colorName: String) -> Color {
        switch colorName.lowercased() {
        case "red":
            return .red
        case "blue":
            return .blue
        case "green":
            return .green
        case "black":
            return .black
        case "white":
            return .white
        case "yellow":
            return .yellow
        case "purple":
            return .purple
        case "gray":
            return .gray
        case "brown":
            return Color(red: 0.6, green: 0.4, blue: 0.2)
        default:
            return .gray
        }
    }
}
