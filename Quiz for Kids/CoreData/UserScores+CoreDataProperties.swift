//
//  UserScores+CoreDataProperties.swift
//  Quiz for Kids
//
//  Created by Amru Hashim on 2/22/24.
//
//

import Foundation
import CoreData


extension UserScores {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserScores> {
        return NSFetchRequest<UserScores>(entityName: "UserScores")
    }

    @NSManaged public var qArea: String?
    @NSManaged public var qDate: Date?
    @NSManaged public var qTime: String?
    @NSManaged public var qPoints: Int16
    @NSManaged public var userREL: User?

}
