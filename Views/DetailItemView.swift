import SwiftUI

//
//struct DetailItemView: View {
//    let itemId: UUID
//    let controller = DetailController()
//    @State private var item: WardrobeItem?
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 20) {
//            if let item = item {
//                Text(item.name)
//                    .font(.largeTitle)
//                    .bold()
//                
//                VStack(alignment: .leading) {
//                    Text("Category: \(item.category)")
//                    Text("Color: \(item.color)")
//                    Text("Added: \(item.dateAdded, formatter: itemFormatter)")
//                }
//                .font(.body)
//                
//                Spacer()
//                
//                NavigationLink(destination: EditItemView(item: item)) {
//                    CustomButton(title: "Edit Item")
//                }
//            } else {
//                Text("Loading...")
//            }
//        }
//        .padding()
//        .navigationTitle("Item Details")
//        .navigationBarTitleDisplayMode(.inline)
//        .onAppear {
//            // Get dummy item when view appears
//            self.item = controller.getItem(id: itemId)
//        }
//    }
//}
//
//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .medium
//    formatter.timeStyle = .none
//    return formatter
//}()
