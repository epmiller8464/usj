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
	@NSManaged var username: String?
	@NSManaged var id: String?
	@NSManaged var authToken: String?

	override func validateForInsert() throws {
		try super.validateForInsert()
		//try self.validateConsistency()
	}
	override func validateForUpdate() throws {
		try super.validateForUpdate()
		//try self.validateConsistency()
	}
	
	func validateConsistency() throws {
		var errString : String? =  nil
		var hasErrors = false
//		guard let myAge = self.age else {
//			return
//		}
		if self.email == nil {
			errString = "an email must be provided."
		}
		
		if self.username == nil{
			errString = "an email must be provided."
		}
		
		if(hasErrors){
			
		let userInfo = [NSLocalizedFailureReasonErrorKey: errString!, NSValidationObjectErrorKey: self]
		let error =  NSError(domain: "USER_DETAIL_ERROR_DOMAIN", code: 1123, userInfo: userInfo)
		throw error
		}
	}

}