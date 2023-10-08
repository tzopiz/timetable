//
//  AppDelegate.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit
import CoreData
import UserNotifications

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil)
    -> Bool {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else { return }
            self.notificationCenter.getNotificationSettings { settings in
                guard settings.authorizationStatus == .authorized else { return }
            }
        }
        notificationCenter.delegate = self
        return true
    }
    
    // MARK: - UISceneSession Lifecycle
    
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions)
    -> UISceneConfiguration { UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role) }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataTimetable")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let viewContext = persistentContainer.viewContext
        if viewContext.hasChanges {
            do { try viewContext.save() }
            catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
