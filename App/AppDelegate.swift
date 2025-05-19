import UIKit
import UserNotifications

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
                        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Minta izin notifikasi
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Permission granted ✅")
            } else {
                print("Permission denied ❌")
            }
        }

        // Set delegate untuk bisa munculin notifikasi saat app dibuka
        UNUserNotificationCenter.current().delegate = self

        return true
    }

    // Biar notifikasi bisa muncul saat app terbuka
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
                                    @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }

    // ... fungsi lain seperti UISceneSession Lifecycle jika perlu
}

