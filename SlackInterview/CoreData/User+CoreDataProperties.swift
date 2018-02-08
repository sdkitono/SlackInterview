//
//  User+CoreDataProperties.swift
//  SlackInterview
//
//  Created by Samuel Kitono on 7/2/18.
//  Copyright © 2018 Samuel Kitono. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: String
    @NSManaged public var updatedTime: Double
    @NSManaged public var name: String?
    @NSManaged public var realName: String?
    @NSManaged public var email: String?
    @NSManaged public var image48: String?
    @NSManaged public var image192: String?
    @NSManaged public var title: String?
    @NSManaged public var phone: String?
    @NSManaged public var skype: String?
}
