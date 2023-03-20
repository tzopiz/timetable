//
//  Tasks+CoreDataProperties.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 20.03.2023.
//
//

import Foundation
import CoreData

@objc(Task)
public class Task: NSManagedObject {}

extension Task : Identifiable {}

extension Task {
    @NSManaged public var id: UUID
    @NSManaged public var taskName: String?
    @NSManaged public var taskInfo: String?
    @NSManaged public var isDone: Bool
    @NSManaged public var importance: Int16
}
