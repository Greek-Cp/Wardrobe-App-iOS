import Foundation

class DetailController {
    func getItem(id: UUID) -> WardrobeItem {
        // Ini hanya dummy, dalam versi lengkap akan mengambil dari database
        return WardrobeItem(
            name: "Blue Shirt", 
            category: "Tops", 
            colors: ["Blue", "White"],
            describe: "", 
            style: "", 
            type: "", 
            imagePath: ""
        )
    }
}
