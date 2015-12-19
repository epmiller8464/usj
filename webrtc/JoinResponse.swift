//
//  File.swift
//  webrtc
//
//  Created by ghostmac on 8/4/15.
//  Copyright (c) 2015 ghostmac. All rights reserved.
//

import Foundation

public enum JoinResultType : Int {
	case kJoinResultTypeUnknown;
	case kJoinResultTypeSuccess;
	case kJoinResultTypeFull;
	
}

public class JoinResponse : AnyObject {
	
	
	
	var _result : JoinResultType = JoinResultType.kJoinResultTypeUnknown;
	var _isInitiator : Bool = false;
	var _roomId : NSString = "";
	var _clientId : NSString = "'";
	var _messages : NSArray = [];
	var _webSocketURL : NSURL? = nil;
	var _webSocketRestURL : NSURL?  = nil;
	
	public var result : JoinResultType {
		
		get{return _result;}
	}
	
	
	public var isInitiator : Bool {
		
		get{return _isInitiator;}
	}
	public var roomId : NSString {
		
		get{return _roomId;}
	}
	public var clientId :NSString {
		
		get{return _clientId;}
	}
	public var messages : NSArray {
		
		get{return _messages;}
	}
	public var webSocketURL : NSURL? {
		
		get{return _webSocketURL;}
	}
	public var webSocketRestURL : NSURL? {
		
		get{return _webSocketRestURL;}
	}
	
	public static func responseFromJSONData(data:NSData?)-> JoinResponse? {
		
		let responseJSON = NSDictionary.dictionaryWithJSONData(data);
		if responseJSON == nil {
			return nil;
		}
		let response = JoinResponse();
		let resString =	responseJSON![Utility.kJoinResultKey] as! NSString;
		response._result = JoinResponse.resultTypeFromString(resString);
		
		let params = responseJSON![Utility.kJoinResultParamsKey] as! NSDictionary!;
		let isInitiator = (params[Utility.kJoinInitiatorKey] as? String);
		
		response._isInitiator = isInitiator == nil ? false : isInitiator!.boolValue();
		response._roomId = params[Utility.kJoinRoomIdKey] as! NSString;
		response._clientId = params[Utility.kJoinClientIdKey] as! NSString;
		
		let messages = params[Utility.kJoinMessagesKey] as! NSArray;
		let signalingMessages = NSMutableArray(capacity: messages.count);
		
		for rawMessage  in messages {
			let message = rawMessage as? NSString;// as NSMutableString
			if message != nil {
				let sm = SignalingMessage.messageFromJSONString(message!);
				signalingMessages.addObject(sm!);
			}
		}
		response._messages = signalingMessages;
		
		let wsUrl = params[Utility.kJoinWebSocketURLKey] as! NSString;
		response._webSocketURL = NSURL(string: wsUrl as String)!;
		
		let wsRestUrl = params[Utility.kJoinWebSocketRestURLKey] as! NSString;
		response._webSocketRestURL = NSURL(string: wsRestUrl as String)!;
		
		return response;
	}
	
	public static func resultTypeFromString(resultString: NSString?) -> JoinResultType {
		
		var  result = JoinResultType.kJoinResultTypeUnknown;
		if resultString == "SUCCESS" {
			result = JoinResultType.kJoinResultTypeSuccess;
		} else if resultString == "FULL" {
			result = JoinResultType.kJoinResultTypeFull;
		}
		return result;
	}
}






