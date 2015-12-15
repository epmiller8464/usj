//
//  UserDetail+CoreDataProperties.swift
//  
//
//  Created by ghostmac on 12/15/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension UserDetail {

    @NSManaged var age: String?
    @NSManaged var clientId: String?
    @NSManaged var clientSecret: String?
    @NSManaged var email: String?
    @NSManaged var firstName: String?
    @NSManaged var id: String?
    @NSManaged var lastName: String?
    @NSManaged var mi: String?
    @NSManaged var phoneNumber: String?
    @NSManaged var username: String?
    @NSManaged var uuid: String?
    @NSManaged var verified: NSNumber?

}
