//
//  IncidentStore.swift
//  Incidenttracker
//
//  Created by Kevin VanderLugt on 1/10/15.
//  Copyright (c) 2015 Alpine Pipeline. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

private let _DataStoreSharedInstance = DataStore()
//@objc(Incident)

class DataStore: NSObject {
	
	// Singleton instance - Trying this for dealing with core data
	class var sharedInstance: DataStore {
		return _DataStoreSharedInstance
	}
	
	var currentIncident: Incident?
	var currentUser: UserDetail?
	
	func createUser() -> UserDetail {
		if (currentUser == nil) {
			currentUser = NSEntityDescription.insertNewObjectForEntityForName("UserDetail", inManagedObjectContext: self.managedObjectContext) as? UserDetail
			currentUser?.userStatus = .Default
		}
		return currentUser!
	}
	
	func userExists()-> Bool{
		
		var _userExists = false
		if currentUser == nil {
			do {
				let fetchRequest = NSFetchRequest(entityName: "UserDetail")
				let results = try self.managedObjectContext.executeFetchRequest(fetchRequest)
				
				if results.count > 0 {
					let temp =	(results[0] as? NSManagedObject) as? UserDetail
					_userExists = temp!.userStatus! == .Added || temp!.userStatus! == .Verified
					print(temp!.toDict());
				}
				
			}catch{
				print(error);
			}
		}
		return _userExists
	}
	
	func getCurrentUser() -> UserDetail {
		if currentUser == nil {
			let fetchRequest = NSFetchRequest(entityName: "UserDetail")
			
			do {
				let results = try self.managedObjectContext.executeFetchRequest(fetchRequest)
				
				if results.count > 0{
					currentUser = (results[0] as? NSManagedObject) as? UserDetail
				}else{
					currentUser = createUser()
				}
				
			}catch{
				print(error);
			}
		}
		return currentUser!
	}
	
	lazy var allIncidents: [Incident] = {
		let fetchRequest = NSFetchRequest(entityName: "Incident")
		//		let sortDescriptor = NSSortDescriptor(key: "incidentDate", ascending: true)
		//		fetchRequest.sortDescriptors = [sortDescriptor]
		
		if let fetchResults = (try? self.managedObjectContext.executeFetchRequest(fetchRequest)) as? [Incident] {
			return fetchResults
		}
		return [Incident]()
	}()
	
	func createIncident() -> Incident{
		if (currentIncident == nil) {
			currentIncident = NSEntityDescription.insertNewObjectForEntityForName("Incident", inManagedObjectContext: self.managedObjectContext) as? Incident
			//			allIncidents.append(currentIncident!)
		}
		return currentIncident!
	}
	
	func stopIncident() {
		if currentIncident != nil {
			currentIncident?.endHammertime = NSDate().timeIntervalSince1970
			currentIncident?.endHammertime = NSDate().timeIntervalSince1970
			saveContext()
		}
		
		currentIncident = nil
	}
	
	func indexOfcurrentIncident() -> Int? {
		if currentIncident != nil {
			return allIncidents.indexOf(currentIncident!)
		}
		return nil
	}
	
	// MARK: - Core Data stack
	
	lazy var applicationDocumentsDirectory: NSURL = {
		// The directory the application uses to store the Core Data store file. This code uses a directory named "com.alpinepipeline.test" in the application's documents Application Support directory.
		let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
		return urls[urls.count-1]
	}()
	
	lazy var managedObjectModel: NSManagedObjectModel = {
		// The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
		let modelURL = NSBundle.mainBundle().URLForResource("usj", withExtension: "momd")!
		return NSManagedObjectModel(contentsOfURL: modelURL)!
	}()
	
	lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
		// The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
		// Create the coordinator and store
		let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
		let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
		var failureReason = "There was an error creating or loading the application's saved data."
		do {
			try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
		} catch {
			// Report any error we got.
			var dict = [String: AnyObject]()
			dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
			dict[NSLocalizedFailureReasonErrorKey] = failureReason
			
			dict[NSUnderlyingErrorKey] = error as? NSError
			let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
			// Replace this with code to handle the error appropriately.
			// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
			NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
			abort()
		}
		
		return coordinator
	}()
	
	lazy var managedObjectContext: NSManagedObjectContext = {
		// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
		let coordinator = self.persistentStoreCoordinator
		var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
		managedObjectContext.persistentStoreCoordinator = coordinator
		return managedObjectContext
	}()
	
	
	// MARK: - Core Data Saving support
	
	func saveContext () {
		if managedObjectContext.hasChanges {
			do {
				try managedObjectContext.save()
			} catch {
				// Replace this implementation with code to handle the error appropriately.
				// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				let nserror = error as NSError
				NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
				abort()
			}
		}
	}
	
	func deleteObject (target:NSManagedObject) -> Bool{
		
		managedObjectContext.deleteObject(target)
		//		managedObjectContext.deletedObjects.contains(target)
		saveContext()
		return !managedObjectContext.deletedObjects.contains(target)
	}
	
}