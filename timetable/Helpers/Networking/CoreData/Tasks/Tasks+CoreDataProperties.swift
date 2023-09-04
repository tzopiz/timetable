//
//  Tasks+CoreDataProperties.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 20.03.2023.
//
//

import Foundation
import CoreData
import UIKit

// codable not use but may be later
@objc(Task)
public class Task: NSManagedObject, Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case taskName
        case taskInfo
        case isDone
        case isImportant
        case dataCreation
        case deadline
    }
    @NSManaged public var id: UUID
    @NSManaged public var taskName: String
    @NSManaged public var taskInfo: String
    @NSManaged public var isDone: Bool
    @NSManaged public var isImportant: Bool
    @NSManaged public var dataCreation: Date
    @NSManaged public var deadline: Date?

    // You can inject the managed object context via an initializer if needed.
    // This example assumes you have a persistentContainer that provides the context.
    
    required convenience public init(from decoder: Decoder) throws {
        guard let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext,
              let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedObjectContext) else {
            fatalError("Failed to decode Task")
        }

        self.init(entity: entity, insertInto: managedObjectContext)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        taskName = try container.decode(String.self, forKey: .taskName)
        taskInfo = try container.decode(String.self, forKey: .taskInfo)
        isDone = try container.decode(Bool.self, forKey: .isDone)
        isImportant = try container.decode(Bool.self, forKey: .isImportant)
        dataCreation = try container.decode(Date.self, forKey: .dataCreation)
        deadline = try container.decodeIfPresent(Date.self, forKey: .deadline)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(taskName, forKey: .taskName)
        try container.encode(taskInfo, forKey: .taskInfo)
        try container.encode(isDone, forKey: .isDone)
        try container.encode(isImportant, forKey: .isImportant)
        try container.encode(dataCreation, forKey: .dataCreation)
        try container.encodeIfPresent(deadline, forKey: .deadline)
    }
    public func formattedDescription() -> String {
        var description = "Задача: \(taskName)\n"
        description += "Описание: \(taskInfo)\n"
        description += "Сделано: \(isDone ? "Да" : "Нет")\n"
        description += "Важная: \(isImportant ? "Да" : "Нет")\n"
        description += "Дата создания: \(Date().formattedDeadline(dataCreation))\n"
        
        if let deadline = deadline {
            description += "Дедлайн: \(Date().formattedDeadline(deadline))\n"
        }
        
        return description
    }
}



extension Task : Identifiable {}
