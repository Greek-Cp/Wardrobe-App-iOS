//
//  ItemController.swift
//  WardrobeApp1
//
//  Created by Mac on 13/05/25.
//

import Foundation
import Foundation
import SwiftUI
import SwiftData

class ItemController {
    func saveItem(context: ModelContext, name: String, category: String, colors: [String],
                 describe: String, style: String, imagePath: String, status: String = ItemStatus.available.rawValue) {
        
        let newItem = WardrobeItem(
            name: name,
            category: category,
            colors: colors,
            describe: describe,
            style: style,
            type: category,
            imagePath: imagePath,
            status: status
        )
        
        context.insert(newItem)
        
        do {
            try context.save()
        } catch {
            print("Error saving wardrobe item: \(error)")
        }
    }
    
    func updateItem(item: WardrobeItem, name: String, category: String, colors: [String],
                   describe: String, style: String, imagePath: String?, status: String) {
        
        item.name = name
        item.category = category
        item.colors = colors
        item.describe = describe
        item.style = style
        item.type = category
        
        if let imagePath = imagePath {
            item.imagePath = imagePath
        }
        
        item.status = status
    }
    
    func markItemAsUnavailable(item: WardrobeItem) {
        item.status = ItemStatus.unavailable.rawValue
    }
    
    func markItemAsAvailable(item: WardrobeItem) {
        item.status = ItemStatus.available.rawValue
    }
    
    func markItemAsRarelyUsed(item: WardrobeItem) {
        item.status = ItemStatus.rarelyUsed.rawValue
    }
    
    func handleWear(item: WardrobeItem) {
        // Logic for when an item is worn
        // Could track usage, update last worn date, etc.
        print("Item worn: \(item.name)")
    }
    
    func handleLaundry(item: WardrobeItem) {
        // Logic for when an item is sent to laundry
        markItemAsUnavailable(item: item)
        print("Item sent to laundry: \(item.name)")
    }
    
    func handleRepair(item: WardrobeItem) {
        // Logic for when an item is sent for repair
        markItemAsUnavailable(item: item)
        print("Item sent for repair: \(item.name)")
    }
}
