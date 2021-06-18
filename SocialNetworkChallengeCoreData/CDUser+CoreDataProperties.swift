//
//  CDUser+CoreDataProperties.swift
//  SocialNetworkChallenge
//
//  Created by Tim Musil on 18.06.21.
//
//

import Foundation
import CoreData


extension CDUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDUser> {
        return NSFetchRequest<CDUser>(entityName: "CDUser")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var age: Int16
    @NSManaged public var isActive: Bool
    @NSManaged public var company: String?
    @NSManaged public var email: String?
    @NSManaged public var address: String?
    @NSManaged public var about: String?
    @NSManaged public var registered: Date?
    @NSManaged public var tags: [String]?
    @NSManaged public var friends: [UUID]?
    
    var wrappedId: UUID {
        id ?? UUID()
    }
    
    var wrappedName: String {
        name ?? "Unknown Name"
    }

    var wrappedAge: Int {
        Int(age)
    }
    
    var wrappedCompany: String {
        company ?? "Unknown Company"
    }
    
    var wrappedEmail: String {
        email ?? "Unknown Email"
    }

    var wrappedFriends: [UUID] {
        friends ?? [UUID]()
    }

}

extension CDUser : Identifiable {

}
