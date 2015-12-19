//
//  AppEngineClient.swift
//  webrtc
//
//  Created by ghostmac on 8/4/15.
//  Copyright (c) 2015 ghostmac. All rights reserved.
//

import Foundation

public class AppEngineClient : AnyObject, RoomServerClient {
	
	static let kRoomServerHostUrl = "https://apprtc.appspot.com";
	static let kRoomServerJoinFormat =	"https://apprtc.appspot.com/join/%@";
	static let kRoomServerMessageFormat = "https://apprtc.appspot.com/message/%@/%@";
	static let kRoomServerLeaveFormat = "https://apprtc.appspot.com/leave/%@/%@";
	static let kAppEngineClientErrorDomain = "ARDAppEngineClient";
	static let kAppEngineClientErrorBadResponse = -1;
	
	public func joinRoomWithRoomId(roomId: String, completionHandler: ((response: JoinResponse?, error: NSError?) -> Void)?) {
		//<#code#>
		let urlString = NSString(format: AppEngineClient.kRoomServerJoinFormat, roomId);
		let roomURL = NSURL(string:urlString as String);
		print(String(format:"Joining room:%@ on room server.", roomId));
		let request = NSMutableURLRequest(URL: roomURL!);
		request.HTTPMethod = "POST";
		//	weak var weakSelf :  AppEngineClient? = self;
		NSURLConnection.sendAsyncRequest(request, completionHandler: {(response:NSURLResponse?,data: NSData?,error:NSError?) in
			
			//var strongSelf :AppEngineClient? = weakSelf;
			
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
		
		let urlString = NSString(format: AppEngineClient.kRoomServerMessageFormat, roomId!,clientId!);
		let roomURL = NSURL(string: urlString as String);
		
		print(String(format:"C-> RS POST: %@", urlString));
		
		let data = message!.JSONData();
		let request = NSMutableURLRequest(URL: roomURL!);
		request.HTTPMethod = "POST";
		request.HTTPBody = data;
		
		
		//weak var weakSelf :  AppEngineClient? = self;
		NSURLConnection.sendAsyncRequest(request, completionHandler: {(response:NSURLResponse?,data: NSData?,error:NSError?) in
			
			//	var strongSelf :AppEngineClient? = weakSelf;
			
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
		let urlString = NSString(format: AppEngineClient.kRoomServerLeaveFormat, roomId!,clientId!);
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
		
		//			var strongSelf :AppEngineClient? = weakSelf;
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
			return NSError(domain: AppEngineClient.kAppEngineClientErrorDomain,
				code:AppEngineClient.kAppEngineClientErrorBadResponse, userInfo: [ NSLocalizedDescriptionKey: "Error parsing response."])
		}
	}
	
	
	
}