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
            
            Circle()
                .fill(colorFromString(item.color))
                .frame(width: 20, height: 20)
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
        default:
            return .gray
        }
    }
}
