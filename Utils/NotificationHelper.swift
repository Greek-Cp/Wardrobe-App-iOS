import Foundation
import UserNotifications

class NotificationHelper {
    static func checkItemsAndNotify(_ items: [WardrobeItem]) {
        let calendar = Calendar.current
        let today = Date()
        
        let itemsToNotify = items.filter { item in
            guard let lastActionDate = item.lastActionDate else {
                return true // belum pernah dipakai
            }
            let components = calendar.dateComponents([.day], from: lastActionDate, to: today)
            return (components.day ?? 0) >= 14
        }

        if !itemsToNotify.isEmpty {
            scheduleNotification(count: itemsToNotify.count)
        }
    }
    static func rareUsedNotify(_ items: [WardrobeItem]) {
        let calendar = Calendar.current
        let today = Date()
        
        let itemsToNotify = items.filter { item in
            guard let lastUsed = item.lastUsed else {
                return true // belum pernah dipakai
            }
            let components = calendar.dateComponents([.day], from: lastUsed, to: today)
            return (components.day ?? 0) >= 60
        }

        if !itemsToNotify.isEmpty {
            scheduleRarelyNotification(count: itemsToNotify.count)
        }
    }

    static private func scheduleNotification(count: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Don't Forget Your Wardrobe"
        content.body = "\(count) items have been inactive for some time. They may need your attention."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
    
    static private func  scheduleRarelyNotification(count: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Time to Wear Your Clothes!"
        content.body = "\(count) clothes haven't been worn in a while. Check your wardrobe!"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
}
