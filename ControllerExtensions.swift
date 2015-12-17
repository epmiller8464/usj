//
//  ReflectedTypeProviderProtocol.swift
//  usj
//
//  Created by ghostmac on 12/12/15.
//  Copyright © 2015 ghostmac. All rights reserved.
//

import UIKit
import Foundation
import CoreData
public protocol StaticStoryboardType {
	var typeName : String {get}
}

extension NSManagedObject {
	
	func toDict() -> Dictionary<String, AnyObject>! {
		
		let attributes = self.entity.attributesByName.keys
		let relationships = self.entity.relationshipsByName.keys
		var dict: [String: AnyObject] = [String: AnyObject]()
		let dateFormater = NSDateFormatter()
		dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
		
		for attribute in attributes {
			if self.entity.attributesByName[attribute]!.attributeValueClassName != nil &&
				self.entity.attributesByName[attribute]!.attributeValueClassName == "NSDate" {
					let value: AnyObject? = self.valueForKey(attribute )
					if value != nil {
						dict[attribute ] = dateFormater.stringFromDate(value as! NSDate)
					} else {
						dict[attribute ] = ""
					}
					
			} else {
				let value: AnyObject? = self.valueForKey(attribute )
				dict[attribute ] = value
			}
		}
		
		for attribute in relationships {
			let relationship: NSManagedObject = self.valueForKey(attribute ) as! NSManagedObject
			let value = relationship.valueForKey("key") as! String
			dict[attribute ] = value
		}
		
		return dict
	}
}