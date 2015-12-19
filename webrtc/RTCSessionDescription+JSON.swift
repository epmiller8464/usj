//
//  RTCSessionDescription+JSON.swift
//  webrtc
//
//  Created by ghostmac on 8/4/15.
//  Copyright (c) 2015 ghostmac. All rights reserved.
//

import Foundation

public extension RTCSessionDescription {
	
	public static func descriptionFromJSONDictionary(dict: NSDictionary) -> RTCSessionDescription {
		
		let type = dict[Utility.kRTCSessionDescriptionTypeKey] as! NSString;
		let sdp = dict[Utility.kRTCSessionDescriptionSdpKey] as! NSString;
		
		return RTCSessionDescription(type:type as String, sdp: sdp as String);
	}
	
	public func JSONData() -> NSData? {
		
		let json  :NSDictionary = [Utility.kRTCSessionDescriptionTypeKey : self.type,	Utility.kRTCSessionDescriptionSdpKey : self.description];
		
		let data = try? NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.PrettyPrinted);
		
		return data;
		
	}
	
	public func JSONData(id:String) -> NSData? {
		
		let json  :NSDictionary = [
			Utility.kRTCSessionDescriptionTypeKey : self.type,
//			Utility.kRTCSessionDescriptionSdpKey : self.description,
			"sdpOffer" : self.description,
			"id":id];
		
		let data = try? NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.PrettyPrinted);
		
		return data;
		
	}

}