//
//  Star+CoreDataProperties.swift
//  Star
//
//  Created by Linus Skucas on 8/21/21.
//
//

import Foundation
import CoreData


extension Star {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Star> {
        return NSFetchRequest<Star>(entityName: "Star")
    }

    @NSManaged public var content: Data?
    @NSManaged public var contentDescription: String?
    @NSManaged public var contentUTI: String?
    @NSManaged public var creationDate: Date?
    @NSManaged public var dateLookedAt: Date?
    @NSManaged public var lookedAt: Bool
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var reminderTime: Date?
    
    public var wrappedCreationDate: Date {
        creationDate ?? Date()
    }
    
    public var wrappedContent: Data {
        content ?? Data()
    }
    
    public var wrappedContentUTI: String {
        contentUTI ?? "public.text"
    }
    
    public var wrappedName: String {
        name ?? "Unknown Name"
    }
    
    public var wrappedDescription: String {
        contentDescription ?? "Unknown Description"
    }
}

extension Star : Identifiable {

}
