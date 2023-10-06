//
//  CoreDataManager.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 20.03.2023.
//

import UIKit
import CoreData
import UserNotifications

// MARK: - CRUD

public final class CoreDataMamanager: NSObject {
    
    public static let shared = CoreDataMamanager()
    private override init() {}
    
    private var appDelegate: AppDelegate { UIApplication.shared.delegate as! AppDelegate }
    private var context: NSManagedObjectContext { appDelegate.persistentContainer.viewContext }
    
    // MARK: - Create
    
    public func createTask(name: String = "Без названия",
                           info: String = "",
                           isDone: Bool = false,
                           isImportant: Bool = false,
                           deadline: Date? = nil,
                           completion: @escaping (Task) -> Void) {
        guard let taskEntityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        let task = Task(entity: taskEntityDescription, insertInto: context)
        task.id = UUID()
        task.name = name
        task.info = info
        task.isDone = isDone
        task.isImportant = isImportant
        task.deadline = deadline
        task.dataCreation = Date.now
        if let _ = task.deadline { scheduleNotification(for: task) }
        appDelegate.saveContext()
        completion(task)
    }
    public func createDuplicate(of task: Task) {
        guard let taskEntityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        let copyTask = Task(entity: taskEntityDescription, insertInto: context)
        copyTask.id = UUID()
        copyTask.name = task.name + " copy"
        copyTask.info = task.info
        copyTask.isDone = task.isDone
        copyTask.deadline = task.deadline
        copyTask.isImportant = task.isImportant
        if let _ = copyTask.deadline { scheduleNotification(for: task) }
        copyTask.dataCreation = Date.now
        appDelegate.saveContext()
    }
    
    // MARK: - Read
    
    public func fetchTasks() -> [Task] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        do { return (try? context.fetch(fetchRequest) as? [Task]) ?? [] }
    }
    func fetchTasksDefined(with type: App.TaskSortKey = .none) -> [Task] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        let tasks = (try? context.fetch(fetchRequest) as? [Task]) ?? []
        do {
            switch type {
            case .deadlineTop:
                return tasks.sorted { t1, t2 in
                    if t1.deadline?.stripTime(.toDays) == t2.deadline?.stripTime(.toDays) {
                        return t1.isImportant.description > t2.isImportant.description
                    }
                    else {
                        return t1.deadline ?? Date.distantFuture < t2.deadline ?? Date.distantFuture
                    }
                }
            case .deadlineDown:
                return tasks.sorted { t1, t2 in
                    if t1.deadline?.stripTime(.toDays) == t2.deadline?.stripTime(.toDays) {
                        return t1.isImportant.description > t2.isImportant.description
                    }
                    else {
                        return t1.deadline ?? Date.distantFuture > t2.deadline ?? Date.distantFuture
                    }
                }
            case .importanceTop:  return tasks.sorted(by: { $0.isImportant.description > $1.isImportant.description })
            case .importanceDown: return tasks.sorted(by: { $0.isImportant.description < $1.isImportant.description })
            case .completed:      return tasks.filter { $0.isDone == true }
            case .notCompleted:   return tasks.filter { $0.isDone == false }
            case .none:           return tasks
            }
        }
    }
    public func fetchTask(with id: UUID?) -> Task? {
        guard let id = id else { return nil }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        do {
            let tasks = try? context.fetch(fetchRequest) as? [Task]
            return tasks?.first(where: { $0.id == id })
        }
    }
    
    // MARK: - Update
    
    public func updateTask(with id: UUID?, name: String? = nil,
                           info: String? = nil,
                           isDone: Bool? = nil,
                           isImportant: Bool? = nil,
                           deadline: Date?) {
        guard let id = id else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        guard let tasks = try? context.fetch(fetchRequest) as? [Task],
              let task = tasks.first(where: { $0.id == id }) else { return }
        if let name = name { task.name = name }
        if let info = info { task.info = info }
        if let isDone = isDone { task.isDone = isDone }
        if let isImportant = isImportant { task.isImportant = isImportant }
        if task.deadline != deadline {
            deleteNotification(for: task)
            task.deadline = deadline
            if let _ = task.deadline { scheduleNotification(for: task) }
        }
        appDelegate.saveContext() // Сохранить изменения в Core Data
    }
    
    public func updataTypeTask(with id: UUID?, isDone: Bool) {
        guard let id = id else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        do {
            guard let tasks = try? context.fetch(fetchRequest) as? [Task],
                  let task = tasks.first(where: { $0.id == id }) else { return }
            task.isDone = isDone
        }
        appDelegate.saveContext()
    }
    public func updataDeadlineTask(with id: UUID?, deadline: Date?) {
        guard let id = id else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        do {
            guard let tasks = try? context.fetch(fetchRequest) as? [Task],
                  let task = tasks.first(where: { $0.id == id }) else { return }
            if deadline != task.deadline {
                deleteNotification(for: task)
                task.deadline = deadline
                if let _ = task.deadline { scheduleNotification(for: task) }
            }
        }
        appDelegate.saveContext()
    }
    
    // MARK: - Delete
    
    public func deletaAllTasks() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        do {
            let tasks = try? context.fetch(fetchRequest) as? [Task]
            tasks?.forEach { context.delete($0) }
        }
        appDelegate.saveContext()
    }
    public func deletaTask(with id: UUID?) {
        guard let id = id else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        do {
            guard let tasks = try? context.fetch(fetchRequest) as? [Task],
                  let task = tasks.first(where: { $0.id == id}) else { return }
            deleteNotification(for: task)
            context.delete(task)
        }
        appDelegate.saveContext()
    }
}

extension CoreDataMamanager {
    public func saveProfileImage(_ image: UIImage? = nil) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Profile")
        do {
            let profiles = try? context.fetch(fetchRequest) as? [Profile]
            var profile: Profile?
            if profiles?.count == 0 {
                profile = NSEntityDescription.insertNewObject(forEntityName: "Profile",
                                                              into: context) as? Profile
            } else {
                profile = profiles?.first
            }
            if image == nil &&  profile?.photo == nil{
                profile?.photo = App.Images.imageProfile.pngData()
            } else if image != nil {
                profile?.photo = image?.pngData()
            }
            appDelegate.saveContext()
        }
    }
    public func fetchImageProfile() -> UIImage? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Profile")
        do {
            let profiles = try context.fetch(fetchRequest) as! [Profile]
            let profile = profiles.first
            return UIImage(data: profile?.photo ?? Data())
        } catch { print(error.localizedDescription) }
        return nil
    }
    public func deleteProfilePhoto() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Profile")
        do {
            guard let profiles = try? context.fetch(fetchRequest) as? [Profile],
                  let profile = profiles.first else { return }
            let pngImage = App.Images.imageProfile.pngData()
            profile.photo = pngImage
        }
        appDelegate.saveContext()
    }
    
}


extension CoreDataMamanager {
    // TODO: -
    // MARK: - Notifications
    
    private func scheduleNotification(for task: Task) {
        guard let deadline = task.deadline else { return }
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Напоминание о задаче"
        notificationContent.body = "У вас есть задача '\(task.name)' с крайним сроком \(deadline)"
        notificationContent.sound = task.isImportant ?  UNNotificationSound.defaultCritical : UNNotificationSound.default
        
        let calendar = Calendar.current
        let notificationDate = calendar.date(byAdding: .day, value: -1, to: deadline)
        
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: notificationDate!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let notificationRequest = UNNotificationRequest(identifier: task.id.uuidString, content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(notificationRequest) { error in
            if let error = error { print("Ошибка при планировании уведомления: \(error)") }
            else { print("Уведомление успешно запланировано") }
        }
    }
    private func deleteNotification(for task: Task) {
        let identifier = task.id.uuidString
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
