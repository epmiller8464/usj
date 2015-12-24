//
//  IncidentLocation+CoreDataProperties.swift
//  usj
//
//  Created by ghostmac on 12/23/15.
//  Copyright © 2015 ghostmac. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension IncidentLocation {

    @NSManaged var incidentId: String?
    @NSManaged var loc: NSObject?

}
