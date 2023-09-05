//
//  Profile+CoreDataProperties.swift
//  
//
//  Created by Дмитрий Корчагин on 02.04.2023.
//
//

import Foundation
import CoreData

@objc(Profile)
public final class Profile: NSManagedObject { }

extension Profile {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }
    
    @NSManaged public var photo: Data?
}
