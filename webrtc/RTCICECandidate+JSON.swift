//
//  RTCICECandidate+JSON.swift
//  webrtc
//
//  Created by ghostmac on 8/4/15.
//  Copyright (c) 2015 ghostmac. All rights reserved.
//

import Foundation

public extension RTCICECandidate {
	
	
	
	public static func candidateFromJSONDictionary(dictionary: NSDictionary) -> RTCICECandidate {
		
		let mid = dictionary[Utility.kRTCICECandidateMidKey] as? String;
		let sdp = dictionary[Utility.kRTCICECandidateSdpKey] as? String;
		let num = dictionary[Utility.kRTCICECandidateMLineIndexKey] as? String;
		let mLineIndex = num == nil ? 0 :Int(num!);
		
		return RTCICECandidate(mid: mid!, index: mLineIndex!, sdp: sdp!);
	}
	
	
	public func JSONData() -> NSData? {
		
		let json  :NSDictionary = [Utility.kRTCICECandidateTypeKey : Utility.kRTCICECandidateTypeValue,
			Utility.kRTCICECandidateMLineIndexKey : self.sdpMLineIndex,
			Utility.kRTCICECandidateMidKey : self.sdpMid,
			Utility.kRTCICECandidateSdpKey : self.sdp];
		let error = NSErrorPointer();// = nil;
		var data: NSData?
		do {
			data = try NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.PrettyPrinted)
		} catch let error1 as NSError {
			error.memory = error1
			data = nil
		};
		
		if error != nil{
			print(error);
			return nil;
		}
		
		return data!;
		
	}
	
	/*
	candidate: 'candidate:186199869 2 udp 2122260222 192.168.1.101 53201 typ host generation 0',
	sdpMid: 'audio',
	sdpMLineIndex: 0
	*/
 
	
	public func JSONData(id:String) -> NSData? {
		
		let json  :NSDictionary = [Utility.kRTCICECandidateTypeKey : Utility.kRTCICECandidateTypeValue,
			"sdpMLineIndex" : self.sdpMLineIndex,
			"sdpMid" : self.sdpMid,
			Utility.kRTCICECandidateSdpKey : self.sdp];
//			"id":id];
		let jsonData : NSDictionary = ["id":id,Utility.kRTCICECandidateTypeValue:json,"cid":"ios"];

		let error = NSErrorPointer();// = nil;
		var data: NSData?
		do {
			data = try NSJSONSerialization.dataWithJSONObject(jsonData, options: NSJSONWritingOptions.PrettyPrinted)
		} catch let error1 as NSError {
			error.memory = error1
			data = nil
		};
		
		if error != nil{
			print(error);
			return nil;
		}
		
		return data!;
		
	}
}