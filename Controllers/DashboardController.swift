import Foundation
import SwiftData

class DashboardController {
    func fetchItems() -> [WardrobeItem] {
           // Dummy data for demo
           return [
               WardrobeItem(
                   name: "Blue Shirt",
                   category: "Tops",
                   color: "Blue",
                   describe: "A stylish blue shirt, perfect for casual outings.",
                   style: "Casual",
                   type: "Cotton",
                   imagePath: "blue_shirt_image"
               ),
               
               WardrobeItem(
                   name: "Black Jeans",
                   category: "Bottoms",
                   color: "Black",
                   describe: "Slim fit black jeans that go well with almost any top.",
                   style: "Casual",
                   type: "Denim",
                   imagePath: "black_jeans_image"
               ),
               
               WardrobeItem(
                   name: "Red Dress",
                   category: "Dresses",
                   color: "Red",
                   describe: "A bright red dress, perfect for formal events.",
                   style: "Formal",
                   type: "Silk",
                   imagePath: "red_dress_image"
               ),
               
               WardrobeItem(
                   name: "White Sneakers",
                   category: "Shoes",
                   color: "White",
                   describe: "Comfortable white sneakers for all-day wear.",
                   style: "Casual",
                   type: "Leather",
                   imagePath: "white_sneakers_image"
               ),
               
               WardrobeItem(
                   name: "Black Jacket",
                   category: "Outerwear",
                   color: "Black",
                   describe: "A sleek black jacket for cold weather.",
                   style: "Casual",
                   type: "Wool",
                   imagePath: "black_jacket_image"
               ),
               
               WardrobeItem(
                   name: "Green T-shirt",
                   category: "Tops",
                   color: "Green",
                   describe: "A comfortable green t-shirt for everyday wear.",
                   style: "Casual",
                   type: "Cotton",
                   imagePath: "green_tshirt_image"
               ),
               
               WardrobeItem(
                   name: "Grey Sweatpants",
                   category: "Bottoms",
                   color: "Grey",
                   describe: "Soft and cozy grey sweatpants, perfect for lounging.",
                   style: "Casual",
                   type: "Polyester",
                   imagePath: "grey_sweatpants_image"
               ),
               
               WardrobeItem(
                   name: "Brown Boots",
                   category: "Shoes",
                   color: "Brown",
                   describe: "Sturdy brown boots for outdoor activities.",
                   style: "Outdoor",
                   type: "Leather",
                   imagePath: "brown_boots_image"
               )
           ]
       }
}
