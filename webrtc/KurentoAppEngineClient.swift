
//
//  KurentoAppEngineClient.swift
//  webrtc
//
//  Created by ghostmac on 9/17/15.
//  Copyright (c) 2015 ghostmac. All rights reserved.
//

import Foundation

public class KurentoAppEngineClient : AnyObject, RoomServerClient {
	
	static let kRoomServerHostUrl = "http://192.168.0.6:8181/";
	static let kRoomServerJoinFormat =	"http://192.168.0.6:8181/join/";//%@/%@";
	static let kRoomServerMessageFormat = "http://192.168.0.6:8181/message/";
	static let kRoomServerLeaveFormat = "http://192.168.0.6:8181/leave/%@/%@";
	private var _channel: protocol<SignalingChannel>?;

	static let kKurentoAppEngineClientErrorDomain = "KurentoAppEngineClient";
	static let kKurentoAppEngineClientErrorBadResponse = -1;

	
	public init(){
		
	}
	
	public func joinRoomWithRoomId(roomId: String, completionHandler: ((response: JoinResponse?, error: NSError?) -> Void)?) {

		let urlString = NSString(string: KurentoAppEngineClient.kRoomServerJoinFormat);//,roomId,"epm");
		let roomURL = NSURL(string:urlString as String);
		print(String(format:"Joining room:%@ on room server.", roomId));
		let request = NSMutableURLRequest(URL: roomURL!);
		request.setValue( "application/json", forHTTPHeaderField:"Content-Type");
		request.HTTPMethod = "POST";
		let e  = 	NSErrorPointer();
		var data: NSData?
		do {
			data = try NSJSONSerialization.dataWithJSONObject(["id":"master","is_initiator":"1","roomId":roomId], options: NSJSONWritingOptions.PrettyPrinted)
		} catch let error as NSError {
			e.memory = error
			data = nil
		};
		request.HTTPBody  = data;
		
		
		NSURLConnection.sendAsyncRequest(request, completionHandler: {(response:NSURLResponse?,data: NSData?,error:NSError?) in
			
			//var strongSelf :KurentoAppEngineClient? = weakSelf;
			
			if error != nil {
				if completionHandler != nil {
					completionHandler!(response: nil,error: error!);
				}
				return;
			}
			let joinResponse = JoinResponse.responseFromJSONData(data);
			
			if joinResponse == nil {
				if completionHandler != nil {
					completionHandler!(response: nil,error: self.badErrorResponse);
				}
				return;
			}
			if completionHandler != nil {
				completionHandler!(response: joinResponse, error: nil);
			}
		});
	}
	
	public func sendMessage(message: SignalingMessage?, forRoomId roomId: NSString?, clientId: NSString?, completionHandler: ((message: MessageResponse?, error: NSError?) -> Void)?) {
		//
		
		let urlString = NSString(format: KurentoAppEngineClient.kRoomServerMessageFormat, roomId!,clientId!);
		let roomURL = NSURL(string: urlString as String);
		
		print(String(format:"C-> RS POST: %@", urlString));
		
		let data = message!.JSONData();
		let request = NSMutableURLRequest(URL: roomURL!);
		request.setValue( "application/json", forHTTPHeaderField:"Content-Type");
		request.HTTPMethod = "POST";
		request.HTTPBody = data;
		
		
		//weak var weakSelf :  KurentoAppEngineClient? = self;
		NSURLConnection.sendAsyncRequest(request, completionHandler: {(response:NSURLResponse?,data: NSData?,error:NSError?) in
			
			//	var strongSelf :KurentoAppEngineClient? = weakSelf;
			
			if error != nil {
				if completionHandler != nil {
					completionHandler!(message: nil,error: error!);
				}
				return;
			}
			let messageResponse = MessageResponse.responseFromJSONData(data);
			if messageResponse == nil {
				if completionHandler != nil {
					completionHandler!(message: nil,error: self.badErrorResponse);
				}
				return;
			}
			
			if completionHandler != nil {
				
				completionHandler!(message:messageResponse,error: nil);
			}
		});
		
	}
	public func leaveRoomWithRoomId(roomId: NSString?, clientId: NSString?, completionHandler: ((error: NSError?) -> Void)?) {
		//
		let urlString = NSString(format: KurentoAppEngineClient.kRoomServerLeaveFormat, roomId!,clientId!);
		let roomURL = NSURL(string: urlString as String);
		
		print(String(format:"C-> RS POST: %@", urlString));
		
		//var data = message!.JSONData();
		let request = NSMutableURLRequest(URL: roomURL!);
		request.HTTPMethod = "POST";
		//request.HTTPBody = data;
		let response : AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil;
		let error = NSErrorPointer();// = nil;
		
		
		do {
			try NSURLConnection.sendSynchronousRequest(request, returningResponse: response)
		} catch let error1 as NSError {
			error.memory = error1
		};
		
		//			var strongSelf :KurentoAppEngineClient? = weakSelf;
		//
		if error != nil {
			print(String(format:"Error leaving room %@ on room server: %@",roomId!,clientId!));
			
			if completionHandler != nil {
				completionHandler!(error: error.memory);
			}
			return;
		}
		
		if completionHandler != nil {
			completionHandler!(error: nil);
		}
	}
	
	
	var badErrorResponse : NSError {
		get{
			return NSError(domain: KurentoAppEngineClient.kKurentoAppEngineClientErrorDomain,
				code:KurentoAppEngineClient.kKurentoAppEngineClientErrorBadResponse, userInfo: [ NSLocalizedDescriptionKey: "Error parsing response."])
		}
	}
	
	
	
}