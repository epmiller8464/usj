//
//  Globals.swift
//  usj
//
//  Created by ghostmac on 12/17/15.
//  Copyright © 2015 ghostmac. All rights reserved.
//

import Foundation
let pattern =  "[(]?\\d{3}[)]?[-.\\s]?\\b\\d{3}[-.]?\\d{4}\\b"

public func isValidPhoneNumber(input:String) -> Bool{
	var isValid = false
	do{
		isValid = try Regex(pattern)!.test(input)
	}catch{
		
	}
	return isValid
}


public func isNilOrEmpty(str:String?) -> Bool{
	//	str!.containsString(str);
	return str == nil ||  str!.isNilOrEmpty()
}