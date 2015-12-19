//
//  SignalingMessage.swift
//  webrtc
//
//  Created by ghostmac on 8/4/15.
//  Copyright (c) 2015 ghostmac. All rights reserved.
//

import Foundation

public  enum SignalingMessageType {
	case kUnknown;
	case kSignalingMessageTypeCandidate;
	case kSignalingMessageTypeOffer;
	case kSignalingMessageTypeAnswer;
	case kSignalingMessageTypeMessage;
	case kSignalingMessageTypeBye;
}


public class SignalingMessage : AnyObject {
	
	var _type : SignalingMessageType;
	public var type : SignalingMessageType { get{ return self._type; }}
	public var id : String?;
	public var sessionId : String?;
	public var response : String?;
	public var message : AnyObject?;
	
	init?(type:SignalingMessageType){
		
		self._type = type;
		self.id = "viewer";
	}
	
	public static func messageFromJSONString(jsonString:NSString) -> SignalingMessage? {
		print(jsonString);
		var message : SignalingMessage? = nil;
		let values = NSDictionary.dictionaryWithJSONString(jsonString);
		if values == nil {
			print("Error parsing signaling message JSON.");
			return nil;
		}
		let typeString = values![Utility.kSignalingMessageTypeKey] as! NSString?;
		
		if typeString == "candidate" {
			let candidate = RTCICECandidate.candidateFromJSONDictionary(values!);
			message = ICECandidateMessage(candidate: candidate);
		}  else if typeString == "offer" || typeString == "answer" {
			let desc = RTCSessionDescription.descriptionFromJSONDictionary(values!);
			message = SessionDescriptionMessage(description: desc);
		} else if typeString == "bye" {
			message = ByeMessage();
		}
		else{
			print("unexpected error occured");
		}
		
		
		return message;
	}
	
	public var description : NSString  {
	
		get{
			return NSString(data: self.JSONData()!, encoding: NSUTF8StringEncoding)!;
		}
	}
	
	public func JSONData() -> NSData? {
		return nil;
	}
	
}



public class ICECandidateMessage : SignalingMessage {
	
	var _candidate : RTCICECandidate;
	public var candidate : RTCICECandidate {
		
		get{
			return self._candidate;
		}
	}
	
	
	init?(candidate:RTCICECandidate){
		
		self._candidate = candidate;
		super.init(type: SignalingMessageType.kSignalingMessageTypeCandidate);
		self.id = "onIceCandidate";
		
	}
	public override func JSONData() -> NSData? {
//		return self.candidate.JSONData();
		return self.candidate.JSONData(self.id!);
	}
}




public class SessionDescriptionMessage : SignalingMessage {
	
	var _sessionDescription : RTCSessionDescription;
	public var sessionDescription : RTCSessionDescription {
		
		get{
			return self._sessionDescription;
		}
	}
	
	
	init?(description:RTCSessionDescription){
		
		self._sessionDescription = description;
		var smType : SignalingMessageType?;//.kSignalingMessageTypeOffer;
		let typeString = description.type;
		
		if typeString == "offer"{
			smType = SignalingMessageType.kSignalingMessageTypeOffer;
			super.init(type: smType!);
		}else if typeString == "answer" {
		smType = SignalingMessageType.kSignalingMessageTypeAnswer;
			super.init(type: smType!);
		}
		else{
			print("error parsing session desc");
			smType = SignalingMessageType.kUnknown;
			super.init(type: smType!);
			return nil;
		}
	}
	
	public override func JSONData() -> NSData? {
//		return self.sessionDescription.JSONData();
		return self.sessionDescription.JSONData(self.id!);
	}
}


public class ByeMessage : SignalingMessage {
	
	
	init?(){
		
		super.init(type: SignalingMessageType.kSignalingMessageTypeBye);
		
	}
	
	public override func JSONData() -> NSData? {
		return try? NSJSONSerialization.dataWithJSONObject(["type":"bye"], options: NSJSONWritingOptions());
	}
}


public class KMSSignalingMessage : SignalingMessage {

	init?(description:RTCSessionDescription){
		
		var smType : SignalingMessageType?;//.kSignalingMessageTypeOffer;
		let typeString = description.type;
		
		if typeString == "offer"{
			smType = SignalingMessageType.kSignalingMessageTypeOffer;
			super.init(type: smType!);
		}else if typeString == "answer" {
			smType = SignalingMessageType.kSignalingMessageTypeAnswer;
			super.init(type: smType!);
		}
		else{
			print("error parsing session desc");
			smType = SignalingMessageType.kUnknown;
			super.init(type: smType!);
			return nil;
		}
	}
	
	public override func JSONData() -> NSData? {
		return nil;//self.sessionDescription.JSONData()     ;
	}

}





