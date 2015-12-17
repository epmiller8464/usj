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
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
public  extension UserDetail {
	
	@NSManaged var age: String?
	@NSManaged var clientId: String?
	@NSManaged var clientSecret: String?
	@NSManaged var email: String?
	@NSManaged var firstName: String?
	@NSManaged var id: String?
	@NSManaged var lastName: String?
	@NSManaged var mi: String?
	@NSManaged var phone: String?
	@NSManaged var username: String?
	@NSManaged var uuid: String?
	@NSManaged var verified: NSNumber?
}
//Mapper
//
class UserDetailMap: Mappable {
	var age: String?
	var clientId: String?
	var clientSecret: String?
	var email: String?
	var firstName: String?
	var id: String?
	var lastName: String?
	var mi: String?
	var phone: String?
	var username: String?
	var uuid: String?
	var verified: NSNumber?
	var _id : String?
	required init?(_ map: Map){
		
	}
	
	func mapping(map: Map) {
		age <- map["age"]
		clientSecret <- map["clientSecret"]
		clientId <- map["clientId"]
		email <- map["email"]
		firstName <- map["firstName"]
		id <- map["id"]
		lastName <- map["lastName"]
		mi <- map["mi"]
		phone <- map["phone"]
		username <- map["username"]
		uuid <- map["uuid"]
		verified <- map["verified"]
		_id <- map["_id"]
	}
}

