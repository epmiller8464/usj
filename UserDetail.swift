//
//  UserDetail.swift
//  usj
//
//  Created by ghostmac on 12/11/15.
//  Copyright © 2015 ghostmac. All rights reserved.
//

import Foundation
import CoreData


class UserDetail: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
	@NSManaged var age: String?
	@NSManaged var email: String?
	@NSManaged var firstName: String?
	@NSManaged var lastName: String?
	@NSManaged var mi: String?
	@NSManaged var userName: String?
	@NSManaged var id: String?
	@NSManaged var authToken: String?

}
