//
//  TURNClient.swift
//  webrtc
//
//  Created by ghostmac on 8/4/15.
//  Copyright (c) 2015 ghostmac. All rights reserved.
//
import Foundation

public protocol TurnClientProtocol : AnyObject{
	//“let completionBlock: (NSData, NSError) -> Void = {data, error in /* ... */}”
	func requestServersWithCompletionHandler(completionHandler: (turnServers : NSArray?, error:NSError?) -> Void);
}

public protocol CEODTurnClientProtocol : TurnClientProtocol, AnyObject {
	
	//“let completionBlock: (NSData, NSError) -> Void = {data, error in /* ... */}”
	init?(url:NSURL?);
}


public class TurnClient : CEODTurnClientProtocol, AnyObject{
	static var kTURNOriginURLString : String = "https://apprtc.appspot.com";
	static var kARDCEODTURNClientErrorDomain : String = "ARDCEODTURNClient";
	static var kARDCEODTURNClientErrorBadResponse : Int = 1;
	
	var url : NSURL?;
	public required init?(url: NSURL?) {
		self.url = url;
		if nil == self.url || self.url!.absoluteString.isNilOrEmpty() {
			//
			return nil;
		}
		
	}
	public func requestServersWithCompletionHandler(completionHandler: (turnServers: NSArray?,error: NSError?) -> Void) {
		//code
		
		let request = NSMutableURLRequest(URL:self.url!);
		request.addValue("Mozilla/5.0", forHTTPHeaderField: "user-agent");
		request.addValue(TurnClient.kTURNOriginURLString, forHTTPHeaderField: "origin");
	
		NSURLConnection.sendAsyncRequest(request,
			completionHandler:{
				(response:NSURLResponse?, data:NSData?,error: NSError?) -> Void in
				
				var turnServers = NSArray();
				if error != nil {
					completionHandler(turnServers:turnServers, error: error);
					return;
				}
				
				let data =	NSDictionary.dictionaryWithJSONData(data!);
				turnServers = RTCICEServer.serversFromCEODJSONDictionary(data!);
				let e =  NSError(domain:TurnClient.kARDCEODTURNClientErrorDomain, code:TurnClient.kARDCEODTURNClientErrorBadResponse,userInfo: [NSLocalizedDescriptionKey: "bad request fool"]);
				if 0 == turnServers.count {
					completionHandler(turnServers: turnServers, error:e);
					return;
				}
				completionHandler(turnServers: turnServers, error: nil);
		});
	}
	
	
}
