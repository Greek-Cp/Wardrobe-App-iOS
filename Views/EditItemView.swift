import SwiftUI
//
//struct EditItemView: View {
//    let controller = EditController()
//    var item: WardrobeItem?
//    
//    @State private var name: String
//    @State private var category: String
//    @State private var color: String
//    @Environment(\.presentationMode) var presentationMode
//    
//    init(item: WardrobeItem? = nil) {
//        self.item = item
//        _name = State(initialValue: item?.name ?? "")
//        _category = State(initialValue: item?.category ?? "")
//        _color = State(initialValue: item?.color ?? "")
//    }
//    
//    var body: some View {
//        Form {
//            Section(header: Text("Item Details")) {
//                TextField("Name", text: $name)
//                TextField("Category", text: $category)
//                TextField("Color", text: $color)
//            }
//            
//            Section {
//                Button("Save") {
//                    let updatedItem = item ?? WardrobeItem(name: "", category: "", color: "",)
//                    updatedItem.name = name
//                    updatedItem.category = category
//                    updatedItem.color = color
//                    
//                    controller.saveItem(updatedItem)
//                    presentationMode.wrappedValue.dismiss()
//                }
//                .frame(maxWidth: .infinity, alignment: .center)
//            }
//        }
//        .navigationTitle(item == nil ? "Add New Item" : "Edit Item")
//        .navigationBarTitleDisplayMode(.inline)
//    }
//}
//
//struct EditItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            EditItemView()
//        }
//    }
//}
