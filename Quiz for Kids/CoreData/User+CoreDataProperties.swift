//
//  User+CoreDataProperties.swift
//  Quiz for Kids
//
//  Created by Amru Hashim on 2/22/24.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var userName: String?
    @NSManaged public var scoresREL: NSSet?

}

// MARK: Generated accessors for scoresREL
extension User {

    @objc(addScoresRELObject:)
    @NSManaged public func addToScoresREL(_ value: UserScores)

    @objc(removeScoresRELObject:)
    @NSManaged public func removeFromScoresREL(_ value: UserScores)

    @objc(addScoresREL:)
    @NSManaged public func addToScoresREL(_ values: NSSet)

    @objc(removeScoresREL:)
    @NSManaged public func removeFromScoresREL(_ values: NSSet)

}

extension User : Identifiable {

}
