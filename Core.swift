////
////  Core.swift
////  usj
////
////  Created by ghostmac on 12/21/15.
////  Copyright © 2015 ghostmac. All rights reserved.
////
//
//import Foundation
//import CoreData
//
//var error: NSError?
//let success: Bool = managedObjectContext.save(&error)
//// handle success or error
//
//// make it Swift-er
//func saveContext(context:NSManagedObjectContext) -> (success: Bool, error: NSError?)
//
//// Example
//let result = saveContext(context)
//if !result.success {
//	println("Error: \(result.error)")
//}
//
//
//// T is a phantom type
//class FetchRequest <T: NSManagedObject>: NSFetchRequest {
//	init(entity: NSEntityDescription) {
//		super.init()
//		self.entity = entity
//	}
//}
//
//typealias FetchResult = (success: Bool, objects: [T: NSManageObject], error: NSError?)
//func fetch <T> (request: FetchRequest<T>,
//	context: NSManagedObjectContext) -> FetchResult {
//		var error: NSError?
//		if let results = context.executeFetchRequest(request, error: error?) {
//			return (true, results as! [T], error)
//		}
//		return (false, [], error)
//}
//
//
//// Example
//let request = FetchRequest<Band>(entity: entityDescription)
//let results = fetch(request: request, inContext: context)
//
//if !results.success {
//	println("Error = \(results.error)")
//}
//
//results.objects // [Band]