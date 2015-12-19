//
//  MessageResponse.swift
//  webrtc
//
//  Created by ghostmac on 8/4/15.
//  Copyright (c) 2015 ghostmac. All rights reserved.
//

import Foundation

public enum MessageResultType : Int {
	
	case kMessageResultTypeUnknown;
	case kMessageResultTypeSuccess;
	case kMessageResultTypeInvalidRoom;
	case kMessageResultTypeInvalidClient;
	
}


public class MessageResponse : AnyObject {
	
	private var _result : MessageResultType = MessageResultType.kMessageResultTypeUnknown;
	
	public var result : MessageResultType {
		get {
			return _result;
		}
	}
	
	
	
	public  static func responseFromJSONData(data: NSData?) -> MessageResponse? {
		
		let rJSON = NSDictionary.dictionaryWithJSONData(data);
		if rJSON == nil {
			print("error in MessageResponse.responseFromJSONData");
		}
		let response = MessageResponse();
		response._result = resultTypeFromString(Utility.kMessageResultKey);
		
		return response;
		
	}
	
	public static func resultTypeFromString(resultString: NSString?) -> MessageResultType {
		
		var  result = MessageResultType.kMessageResultTypeUnknown;
		if resultString == "SUCCESS" {
			result = MessageResultType.kMessageResultTypeSuccess;
		} else if resultString == "INVALID_CLIENT" {
			result = MessageResultType.kMessageResultTypeInvalidClient;
		}else if resultString == "INVALID_ROOM" {
			result = MessageResultType.kMessageResultTypeInvalidRoom;
		}
		return result;
	}
}


 