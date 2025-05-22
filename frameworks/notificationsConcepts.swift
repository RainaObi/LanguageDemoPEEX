import SwiftUI
import UserNotifications

// MARK: - ViewModel

class NotificationManager: ObservableObject {
    init() {
        requestAuthorization()
    }

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }

    func scheduleLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Time to check your app!"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    func handleNotificationResponse(_ response: UNNotificationResponse) {
        let identifier = response.notification.request.identifier
        print("Handled notification with ID: \(identifier)")
    }
}

// MARK: - View

struct NotificationView: View {
    @StateObject private var manager = NotificationManager()

    var body: some View {
        VStack(spacing: 20) {
            Text("Local Notification Demo")
            Button("Schedule Notification") {
                manager.scheduleLocalNotification()
            }
        }
        .padding()
        .onAppear {
            UNUserNotificationCenter.current().delegate = UIApplication.shared.delegate as? UNUserNotificationCenterDelegate
        }
    }
}

// MARK: - AppDelegate Extension (if needed for custom handling)

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Registered for remote notifications. Token: \(deviceToken.map { String(format: "%02.2hhx", $0) }.joined())")
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle notification tap
        print("Notification tapped: \(response.notification.request.identifier)")
        completionHandler()
    }
}
