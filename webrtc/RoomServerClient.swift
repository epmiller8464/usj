//
//  RoomServerClient.swift
//  webrtc
//
//  Created by ghostmac on 8/4/15.
//  Copyright (c) 2015 ghostmac. All rights reserved.
//

import Foundation

public protocol RoomServerClient : AnyObject {
	
	func joinRoomWithRoomId(roomId: String, completionHandler: ((response: JoinResponse?,error:NSError?) -> Void)?);
	
	func sendMessage(message: SignalingMessage?,forRoomId roomId: NSString?, clientId : NSString?, completionHandler: ((message:MessageResponse?,error:NSError?) -> Void)?);
	
	func leaveRoomWithRoomId(roomId: NSString?, clientId : NSString?, completionHandler: ((error:NSError?) -> Void)?);
}