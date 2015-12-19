//
//  SignalingChannel.swift
//  webrtc
//
//  Created by ghostmac on 8/4/15.
//  Copyright (c) 2015 ghostmac. All rights reserved.
//

import Foundation

public enum SignalingChannelState : Int {
	
	
	// State when disconnected.
	case kSignalingChannelStateClosed;
	// State when connection is established but not ready for use.
	case	kSignalingChannelStateOpen;
	// State when connection is established and registered.
	case kSignalingChannelStateRegistered;
	// State when connection encounters a fatal error.
	case kSignalingChannelStateError;
	
	public func getState(state:SignalingChannelState) -> String {
		switch state {
			// State when disconnected.
		case kSignalingChannelStateClosed:
			return String("State:Closed");
			// State when connection is established but not ready for use.
		case	kSignalingChannelStateOpen:
			// State when connection is established and registered.
			return String("State:Open");
		case kSignalingChannelStateRegistered:
			return String("State:Registered");
			// State when connection encounters a fatal error.
		case kSignalingChannelStateError:
			return String("State:Error");
		}
	}
}
//
//func allItemsMatch<SignalingChannel: SignalingChannel where C1:protocol<SignalingChannel>>(someContainer: C1) -> Bool {
//		
//		
//		// all items match, so return true
//		return true
//		
//}

public protocol SignalingChannelDelegate   {
	
	func channel<Channel:protocol<SignalingChannel>>(channel:Channel?, didStateChange state:SignalingChannelState) -> Void;
	//
	func channel<Channel:protocol<SignalingChannel>>(channel:Channel?, didReceiveMessage message:SignalingMessage) -> Void;
}


public protocol KMSSignalingChannelDelegate   {
	
	func channel<SignalingChannel:protocol<KMSSignalingChannel>>(channel:SignalingChannel?, didStateChange state:SignalingChannelState) -> Void;
	//
	func channel<SignalingChannel:protocol<KMSSignalingChannel>>(channel:SignalingChannel?, didReceiveMessage message:SignalingMessage) -> Void;
	
	func onChannelReady()
	
	func createOffer();
	
	func makeCall(to:String);
	func onIceCandidate(message:ICECandidateMessage);
}

//
public protocol SignalingChannel  {
	
	var locationId : NSString {get}
	var id : NSString {get}
	var state : SignalingChannelState? {get}
	var delegate : protocol<SignalingChannelDelegate>? {get set}
	
	func register(lid: NSString,id:NSString);
	
	func sendMessage(message:SignalingMessage);
}

//public protocol SignalingChannel  {
//	
//	//	var locationId : NSString {get}
//	var id : NSString? {get set}
//	var state : SignalingChannelState? {get}
//	var delegate : protocol<KMSSignalingChannelDelegate>? {get set}
//	
//	func register();
//	
//	func call(to:NSString,message:SessionDescriptionMessage);
//	
//	func onIceCandidate(message:ICECandidateMessage);
//	
//	func onIncomingCallResponse(message: AnyObject!);
//	
//	func sendMessage(message:SignalingMessage);
//}

public protocol KMSSignalingChannel  {
	
//	var locationId : NSString {get}
	var id : NSString? {get set}
	var state : SignalingChannelState? {get}
	var delegate : protocol<KMSSignalingChannelDelegate>? {get set}
	
	func register();

	func call(to:NSString,message:SessionDescriptionMessage);
	
	func onIceCandidate(message:ICECandidateMessage);
	
	func onIncomingCallResponse(message: AnyObject!);
	
	func sendMessage(message:SignalingMessage);
}



