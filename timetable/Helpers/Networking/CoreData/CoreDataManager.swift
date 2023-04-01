//
//  CoreDataManager.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 20.03.2023.
//

import Foundation
import UIKit
import CoreData

// MARK: - CRUD

public final class CoreDataMamanager: NSObject {
    public static let shared = CoreDataMamanager()
    private override init() {}
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Create
    
    public func createTask(taskName: String?, taskInfo: String?, isDone: Bool?, importance: Int16?, deadline: Date? = nil) {
        guard let taskEntityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else {
            return
        }
        let task = Task(entity: taskEntityDescription, insertInto: context)
        task.id = UUID()
        task.taskName = taskName
        task.taskInfo = taskInfo
        if let isDone = isDone { task.isDone = isDone }
        if let importance = importance { task.importance = importance }
        task.deadline = deadline
        appDelegate.saveContext()
    }
    
    // MARK: - Read
    
    public func fetchTasks() -> [Task] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        do {
            return (try? context.fetch(fetchRequest) as? [Task]) ?? []
        }
    }
    func fetchTasksDefined(with type: App.TaskType) -> [Task] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        do {
            switch type {
            case .active:
                var ans: [Task] = []
                guard let tasks = try? context.fetch(fetchRequest) as? [Task] else { return [] }
                for task in tasks {
                    if !task.isDone {
                        ans.append(task)
                    }
                }
                return ans
            case .all:
                return (try? context.fetch(fetchRequest) as? [Task]) ?? []
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
    
    public func updataTask(with id: UUID?, taskName: String? = "",
                           taskInfo: String? = "",
                           isDone: Bool? = false,
                           importance: Int16? = 0,
                           deadline: Date? = nil
    ) {
        guard let id = id else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        do {
            guard let tasks = try? context.fetch(fetchRequest) as? [Task],
                  let task = tasks.first(where: { $0.id == id }) else { return }
            task.taskName = taskName
            task.taskInfo = taskInfo
            task.isDone = isDone!
            task.importance = importance!
            task.deadline = deadline
        }
        
        appDelegate.saveContext()
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
    public func updataDeadlineTask(with id: UUID?, deadline: Date) {
        guard let id = id else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        do {
            guard let tasks = try? context.fetch(fetchRequest) as? [Task],
                  let task = tasks.first(where: { $0.id == id }) else { return }
            task.deadline = deadline
        }
        
        appDelegate.saveContext()
    }
    
    // MARK: - Delete
    
    public func deletaAllTask() {
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
            context.delete(task)
        }
        
        appDelegate.saveContext()
    }
}
