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
    // Add status history tracking using UUID string as key
    private var itemStatusHistory: [String: String] = [:]
    
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
    
    func updateItem(item: WardrobeItem, name: String? = nil, category: String? = nil, colors: [String]? = nil, describe: String? = nil, style: String? = nil, imagePath: String? = nil, status: String? = nil) {
        if let name = name {
            item.name = name
        }
        if let category = category {
            item.category = category
        }
        if let colors = colors {
            item.colors = colors
        }
        if let describe = describe {
            item.describe = describe
        }
        if let style = style {
            item.style = style
        }
        if let imagePath = imagePath {
            item.imagePath = imagePath
        }
        if let status = status {
            item.status = status
            updateItemStatus(item: item, action: status)
        }
    }
    
    private func updateItemStatus(item: WardrobeItem, action: String) {
        let now = Date()
        item.lastActionDate = now
        item.lastAction = action
        
        if action == ItemAction.use.rawValue {
            item.lastUsed = now
        }
    }
    
    func markItemAsUnavailable(item: WardrobeItem) {
        item.status = ItemStatus.unavailable.rawValue
    }
    
    func markItemAsAvailable(item: WardrobeItem) {
        item.status = ItemStatus.available.rawValue
        updateItemStatus(item: item, action: ItemAction.available.rawValue)
    }
    
    func markItemAsRarelyUsed(item: WardrobeItem) {
        item.status = ItemStatus.rarelyUsed.rawValue
    }
    
    func handleWear(item: WardrobeItem) {
        item.status = ItemStatus.unavailable.rawValue
        updateItemStatus(item: item, action: ItemAction.use.rawValue)
    }
    
    func handleLaundry(item: WardrobeItem) {
        item.status = ItemStatus.unavailable.rawValue
        updateItemStatus(item: item, action: ItemAction.laundry.rawValue)
    }
    
    func handleRepair(item: WardrobeItem) {
        item.status = ItemStatus.unavailable.rawValue
        updateItemStatus(item: item, action: ItemAction.repair.rawValue)
    }
    
    func getLastAction(for item: WardrobeItem) -> String? {
        return item.lastAction
    }
    
    func getFormattedLastActionDate(for item: WardrobeItem) -> String {
        guard let date = item.lastActionDate else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
