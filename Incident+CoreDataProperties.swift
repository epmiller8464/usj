//
//  Incident+CoreDataProperties.swift
//  usj
//
//  Created by ghostmac on 12/22/15.
//  Copyright © 2015 ghostmac. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

enum IncidentCategoryType : String{
	case TrafficStop, WitnessedUnknown
	
	func getValueProper() -> String{		
		switch self {
		case .TrafficStop:
			return "Traffic Stop"
		case .WitnessedUnknown:
			return "Witnessed Unknown"
		}
	}
}

enum SourceType : String{
	case VICTIM, WITNESS
}

enum IncidentState : String {
	case New, InProgress, Cancelled, Closed
}

extension Incident {

//    @NSManaged var categoryType: String?
//    @NSManaged var details: String?
//    @NSManaged var id: String?
//    @NSManaged var incidentDate: NSDate?
//    @NSManaged var incidentTarget: String?
//    @NSManaged var lastModified: NSNumber?
//	@NSManaged var hammertime: NSNumber?
//	@NSManaged var endHammertime: NSNumber?
//    @NSManaged var sourceIdentity: String?
//    @NSManaged var sourceType: String?
//    @NSManaged var state: String?
//    @NSManaged var streamId: String?
//	@NSManaged var loc: NSObject?
//	@NSManaged var tags: NSObject?//[String]?
	
	@NSManaged var categoryType: String?
	@NSManaged var details: String?
	@NSManaged var endHammertime: NSNumber?
	@NSManaged var hammertime: NSNumber?
	@NSManaged var id: String?
	@NSManaged var incidentDate: NSNumber?
	@NSManaged var incidentTarget: String?
	@NSManaged var lastModified: NSNumber?
	@NSManaged var loc: NSObject?
	@NSManaged var sourceIdentity: String?
	@NSManaged var sourceType: String?
	@NSManaged var state: String?
	@NSManaged var streamId: String?
	@NSManaged var tags: NSObject?

}


public class IncidentMap: Mappable {
	var categoryType: String?
	var state: String?
	var descr: String?
//	var lat: NSNumber?
//	var long: NSNumber?
	var sourceIdentity: String?
	var incidentTarget: String?
	var streamId: String?
	var id: String?
	var sourceType: String?
	var lastModified : NSNumber?
	var incidentDate: NSDate?
	var hammertime: NSNumber?
	var endHammertime: NSNumber?
	var loc : NSObject?
	public required init?(_ map: Map){
		
	}
	
	public func mapping(map: Map) {
		categoryType <- map["categoryType"]
		state <- map["state"]
		descr <- map["description"]
//		lat <- map["lat"]
//		long <- map["long"]
		loc <- map["loc"]
		id <- map["id"]
		sourceIdentity <- map["sourceIdentity"]
		incidentTarget <- map["incidentTarget"]
		streamId <- map["streamId"]
		sourceType <- map["sourceType"]
		lastModified <- map["lastModified"]
		hammertime <- map["hammertime"]
		endHammertime <- map["endHammertime"]
		incidentDate <- (map["incidentDate"] , JsDateTransform())
	}
}
//
public class JsDateTransform: TransformType {
	public typealias Object = NSDate
	public typealias JSON = String
	
	public init() {}
	
	public func transformFromJSON(value: AnyObject?) -> NSDate? {
		if let timeInt = value as? String {
			let dateFormater = NSDateFormatter()
			dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
			//dateFormater.timeZone = NSTimeZone(name: "UTC")
			return dateFormater.dateFromString(timeInt)
		}
		return nil
	}
	
	public func transformToJSON(value: NSDate?) -> String? {
		if let date = value {
			return date.description
		}
		return nil
	}
}
